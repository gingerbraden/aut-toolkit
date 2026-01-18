import 'dart:io';

import 'package:aut_toolkit/core/services/arasaac_service.dart';
import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/model/user_card_remote_entity.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_local_source.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_remote_source.dart';
import 'package:aut_toolkit/main.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';
import '../domain/model/user_card.dart';
import '../domain/repository/card_repository.dart';

class CardRepositoryImpl implements CardRepository, SyncableRepository {
  final CardLocalSource _localSource;
  final CardRemoteSource _remoteSource;
  final SyncManager _syncManager;

  CardRepositoryImpl(this._localSource, this._remoteSource, this._syncManager) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  List<UserCard> getAllCards() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveCard(UserCard card) {
    if (card.id == 0 || card.remoteId == null) {
      card.pendingAction = PendingAction.CREATE;
      card.isSynced = false;
    } else {
      card.pendingAction = PendingAction.UPDATE;
      card.isSynced = false;
    }
    card.updatedAt = DateTime.now();
    _localSource.put(card.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteCard(UserCard card) {
    final entity = card.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();

    _localSource.put(entity);
    _syncManager.processOnce();
  }

  @override
  Stream<List<UserCard>> watchAll() {
    return _localSource.watchAll().map(
      (entities) => entities.map((e) => e.toModel()).toList(),
    );
  }

  @override
  Future<void> fetchRemote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final remoteData = await _remoteSource.getAllRemote(userId: userId);
      final localData = _localSource.getAll();

      final remoteIds = <String>{};

      for (final remoteEntity in remoteData) {
        remoteIds.add(remoteEntity.remoteId!);

        final local =
        _localSource.getByRemoteId(remoteEntity.remoteId!);

        final entityToSave = remoteEntity.toEntity();
        entityToSave.id = 0;

        if (local != null) {
          entityToSave.id = local.id;

          if (local.pendingAction != PendingAction.NONE.index) {
            entityToSave.pendingAction = local.pendingAction;
            entityToSave.isSynced = local.isSynced;
          }
        }

        await _syncImageIfNeeded(remoteEntity);

        _localSource.put(entityToSave);
      }

      for (final localEntity in localData) {
        if (!remoteIds.contains(localEntity.remoteId)) {
          _localSource.remove(localEntity.id);
        }
      }
    } catch (e) {
      print('Error fetching remote cards: $e');
    }

  }

  @override
  Future<void> processPending() async {
    while (true) {
      final pendingEntities = _localSource.getAllPending();
      if (pendingEntities.isEmpty) break;

      for (final e in pendingEntities) {
        try {
          final action = PendingAction.values[e.pendingAction];

          String? uploadedUrl;

          if (e.arasaacId == null || e.arasaacId == 0) {
            if (e.remoteImgPath != null && e.remoteImgPath!.isNotEmpty) {
              await _remoteSource.deleteRemoteImage(e.remoteImgPath!);
              e.remoteImgPath = "";
            }
            if (File(e.localImgPath).existsSync() &&
                (e.remoteImgPath == null ||
                    e.remoteImgPath != null && e.remoteImgPath!.isEmpty)) {
              final file = File(e.localImgPath);

              uploadedUrl = await _remoteSource.uploadFile(
                file,
                'user_cards_images',
                '${e.userId}_${e.remoteId}_${DateTime.now()}.jpg',
              );

              e.remoteImgPath = uploadedUrl;
            }
          } else {
            if (e.remoteImgPath != null && e.remoteImgPath!.isNotEmpty) {
              await _remoteSource.deleteRemoteImage(e.remoteImgPath!);
              e.remoteImgPath = "";
            }
          }

          final remoteModel = e.toRemote();

          if (action == PendingAction.CREATE) {
            e.remoteId = await _remoteSource.createRemote(remoteModel);
          } else if (action == PendingAction.UPDATE) {
            if (e.remoteId == null) {
              e.remoteId = await _remoteSource.createRemote(remoteModel);
            } else {
              await _remoteSource.updateRemote(remoteModel);
            }
          } else if (action == PendingAction.DELETE) {
            if (e.remoteId != null) {
              await _remoteSource.deleteRemote(e);
            }
            ImageUtil.deleteImage(e.localImgPath);
            _localSource.remove(e.id);
            continue;
          }

          objectbox.store.runInTransaction(TxMode.write, () {
            e.pendingAction = PendingAction.NONE.index;
            e.isSynced = true;
            _localSource.put(e);
          });
        } catch (err) {
          print("Error syncing cards: $err");
          continue;
        }
      }
    }
  }
  Future<void> _syncImageIfNeeded(UserCardRemoteEntity remote) async {
    if (remote.localImgPath.isEmpty) return;

    final file = File(remote.localImgPath);

    if (await file.exists()) return;

    if (remote.arasaacId != null && remote.arasaacId != 0) {
      await ImageUtil.saveImageFromUrl(ARASAACService().getPictogramUrl(remote.arasaacId!));
      return;
    }

    if (remote.remoteImagePath != null &&
        remote.remoteImagePath!.isNotEmpty) {
      final ref =
      FirebaseStorage.instance.refFromURL(remote.remoteImagePath!);

        final filePath = remote.localImgPath;
        final file = File(filePath);

        try {
          final task = ref.writeToFile(file);
          await task;
        } catch (e) {
          print('Image download failed: $e');
        }

    }
  }


}
