import 'dart:io';

import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/core/utils/image_util.dart';
import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_mappers.dart';
import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_remote_entity.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_local_source.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_remote_source.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/domain/repository/eating_habit_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';
class EatingHabitRepositoryImpl implements EatingHabitRepository, SyncableRepository {
  final EatingHabitLocalSource _localSource;
  final EatingHabitRemoteSource _remoteSource;
  final SyncManager _syncManager;

  EatingHabitRepositoryImpl(
      this._localSource,
      this._remoteSource,
      this._syncManager,
      ) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  List<EatingHabit> getAllHabits() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveHabit(EatingHabit eatingHabit) {
    if (eatingHabit.id == 0 || eatingHabit.remoteId == null) {
      eatingHabit.pendingAction = PendingAction.CREATE;
      eatingHabit.isSynced = false;
    } else {
      eatingHabit.pendingAction = PendingAction.UPDATE;
      eatingHabit.isSynced = false;
    }

    eatingHabit.updatedAt = DateTime.now();
    _localSource.put(eatingHabit.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteHabit(EatingHabit eatingHabit) {
    final entity = eatingHabit.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();

    _localSource.put(entity);
    _syncManager.processOnce();
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
      print('Error fetching remote eating habits: $e');
    }
  }

  @override
  Future<void> processPending() async {
    final pendingEntities = _localSource.getAllPending();

    for (final e in pendingEntities) {
      try {
        final action = PendingAction.values[e.pendingAction];

        String? uploadedUrl;

        if (e.remoteImgPath != null && e.remoteImgPath!.isNotEmpty) {
          await _remoteSource.deleteRemoteImage(e.remoteImgPath!);
        }

        if (e.imageFilePath != null && File(e.imageFilePath!).existsSync() && e.remoteImgPath == null) {
          final file = File(e.imageFilePath!);

          uploadedUrl = await _remoteSource.uploadFile(
            file,
            'eating_habits_images',
            '${e.userId}_${e.remoteId}_${DateTime.now()}.jpg',
          );

          e.remoteImgPath = uploadedUrl;
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
          if (e.imageFilePath != null) {
            ImageUtil.deleteImage(e.imageFilePath!);
          }
          _localSource.remove(e.id);
          continue;
        }

        e.pendingAction = PendingAction.NONE.index;
        e.isSynced = true;
        _localSource.put(e);

      } catch (err) {
        print("Error syncing eating habit: $err");
        continue;
      }
    }
  }

  @override
  Stream<List<EatingHabit>> watchAll() {
    return _localSource
        .watchAll()
        .map((entities) => entities.map((e) => e.toModel()).toList());
  }

  Future<void> _syncImageIfNeeded(EatingHabitRemoteEntity remote) async {
    if (remote.imageFilePath == null) return;
    if (remote.imageFilePath!.isEmpty) return;

    final file = File(remote.imageFilePath!);

    if (await file.exists()) return;

    if (remote.remoteImagePath != null &&
        remote.remoteImagePath!.isNotEmpty) {
      final ref =
      FirebaseStorage.instance.refFromURL(remote.remoteImagePath!);

      final filePath = remote.imageFilePath;
      final file = File(filePath!);

      try {
        final task = ref.writeToFile(file);
        await task;
      } catch (e) {
        print('Image download failed: $e');
      }

    }
  }
}
