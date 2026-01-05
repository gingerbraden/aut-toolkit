import 'dart:io';

import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_local_source.dart';
import 'package:aut_toolkit/features/card_management/data/source/card_remote_source.dart';
import 'package:aut_toolkit/main.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

      for (final remoteEntity in remoteData) {
        final local = _localSource.getById(remoteEntity.localId);
        final entityToSave = remoteEntity.toEntity();

        if (local != null && local.pendingAction != PendingAction.NONE.index) {
          entityToSave.pendingAction = local.pendingAction;
          entityToSave.isSynced = local.isSynced;
        }

        _localSource.put(entityToSave);
      }

      final remoteIds = remoteData.map((e) => e.localId).toSet();
      for (final localEntity in localData) {
        if (!remoteIds.contains(localEntity.id)) {
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
            }
            if (File(e.localImgPath).existsSync() &&
                (e.remoteImgPath == null ||
                    e.remoteImgPath != null && e.remoteImgPath!.isEmpty)) {
              final file = File(e.localImgPath);

              uploadedUrl = await _remoteSource.uploadFile(
                file,
                'user_cards_images',
                '${e.userId}_${e.id}.jpg',
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
}
