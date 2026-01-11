import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/model/visual_list_mappers.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/model/visual_list.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/repository/visual_list_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/model/sync_entity.dart';
import '../../../../core/services/sync_manager.dart';

class VisualListRepositoryImpl implements VisualListRepository, SyncableRepository {
  final VisualListLocalSource _localSource;
  final VisualListRemoteSource _remoteSource;
  final SyncManager _syncManager;

  VisualListRepositoryImpl(this._localSource, this._remoteSource, this._syncManager) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  List<VisualList> getAllVisualSchedulesForUserId(String userId) {
    return _localSource
        .getAllVisualSchedulesForUserId(userId)
        .map((e) => e.toModel())
        .toList();
  }

  @override
  List<VisualList> getAllVisualDiagramsForUserId(String userId) {
    return _localSource
        .getAllVisualDiagramsForUserId(userId)
        .map((e) => e.toModel())
        .toList();
  }

  @override
  void save(VisualList list) {
    if (list.id == 0 || list.remoteId == null) {
      list.pendingAction = PendingAction.CREATE;
      list.isSynced = false;
    } else {
      list.pendingAction = PendingAction.UPDATE;
      list.isSynced = false;
    }
    list.updatedAt = DateTime.now();
    _localSource.put(list.toEntity());
    _syncManager.processOnce();
  }

  @override
  void delete(VisualList list) {
    final entity = list.toEntity();
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
      final localData = _localSource.getAll(userId);

      final remoteIds = <String>{};

      for (final remoteEntity in remoteData) {
        remoteIds.add(remoteEntity.remoteId!);

        final local =
        _localSource.getByRemoteId(remoteEntity.remoteId!);

        final entityToSave = remoteEntity.toEntity();
        entityToSave.id = 0;

        if (local != null) {
          entityToSave
            ..id = local.id
            ..pendingAction = local.pendingAction
            ..isSynced = local.isSynced;
        }

        _localSource.put(entityToSave);
      }

      for (final localEntity in localData) {
        if (!remoteIds.contains(localEntity.remoteId)) {
          _localSource.remove(localEntity.id);
        }
      }
    } catch (e) {
      print('Error fetching remote visual lists in repository: $e');
    }
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
            await _remoteSource.deleteRemote(e.toRemote());
          }
          _localSource.remove(e.id);
        }
      } catch (err) {
        continue;
      }
    }
  }

  @override
  Stream<List<VisualList>> watchAll() {
    return _localSource.watchAll().map(
          (entities) => entities.map((e) => e.toModel()).toList(),
    );
  }
}
