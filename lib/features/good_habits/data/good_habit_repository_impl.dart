import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/good_habits/data/model/good_habit_mappers.dart';
import 'package:aut_toolkit/features/good_habits/data/source/good_habit_local_source.dart';
import 'package:aut_toolkit/features/good_habits/data/source/good_habit_remote_source.dart';
import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';
import '../domain/repository/good_habit_repository.dart';

class GoodHabitRepositoryImpl implements GoodHabitRepository, SyncableRepository  {
  final GoodHabitLocalSource _localSource;
  final GoodHabitRemoteSource _remoteSource;
  final SyncManager _syncManager;

  GoodHabitRepositoryImpl(
      this._localSource,
      this._remoteSource,
      this._syncManager,
      ) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }
  @override
  List<GoodHabit> getAllHabits() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveHabit(GoodHabit goodHabit) {
    if (goodHabit.id == 0 || goodHabit.remoteId == null) {
      goodHabit.pendingAction = PendingAction.CREATE;
      goodHabit.isSynced = false;
    } else {
      goodHabit.pendingAction = PendingAction.UPDATE;
      goodHabit.isSynced = false;
    }
    goodHabit.updatedAt = DateTime.now();
    _localSource.put(goodHabit.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteHabit(GoodHabit goodHabit) {
    final entity = goodHabit.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();
    _localSource.put(entity);

    _syncManager.processOnce();
  }

  @override
  Future<void> processPending() async {
    final pendingEntities = _localSource.getAllPending();
    for (final e in pendingEntities) {
      try {
        final action = PendingAction.values[e.pendingAction];
        if (action == PendingAction.CREATE) {
          e.pendingAction = PendingAction.NONE.index;

          await _remoteSource.createRemote(e.toRemote());
          e.isSynced = true;
          _localSource.put(e);
        } else if (action == PendingAction.UPDATE) {
          if (e.remoteId == null) {
            e.pendingAction = PendingAction.NONE.index;

            await _remoteSource.createRemote(e.toRemote());
            e.isSynced = true;
            _localSource.put(e);
          } else {
            e.pendingAction = PendingAction.NONE.index;

            await _remoteSource.updateRemote(e.toRemote());
            e.isSynced = true;
            _localSource.put(e);
          }
        } else if (action == PendingAction.DELETE) {
          if (e.remoteId != null) {
            await _remoteSource.deleteRemote(e);
          }
          _localSource.remove(e.id);
        }
      } catch (err) {
        continue;
      }
    }
  }

  @override
  Future<void> fetchRemote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final remoteData = await _remoteSource.getAllRemote(userId: userId);

      final localData = _localSource.getAll();

      for (final remoteEntity in remoteData) {
        _localSource.put(remoteEntity.toEntity());
      }

      final remoteIds = remoteData.map((e) => e.localId).toSet();
      for (final localEntity in localData) {
        if (!remoteIds.contains(localEntity.id)) {
          _localSource.remove(localEntity.id);
        }
      }
    } catch (e) {
      print('Error fetching remote habits: $e');
    }
  }

  @override
  Stream<List<GoodHabit>> watchAll() {
    return _localSource
        .watchAllBehaviours()
        .map((entities) => entities.map((e) => e.toModel()).toList());
  }


}
