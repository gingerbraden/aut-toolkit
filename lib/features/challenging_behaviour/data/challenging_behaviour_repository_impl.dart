import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_mappers.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_remote_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/repository/challenging_behaviour_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';

class ChallengingBehaviourRepositoryImpl
    implements ChallengingBehaviourRepository, SyncableRepository {
  final ChallengingBehaviourLocalSource _localSource;
  final ChallengingBehaviourRemoteSource _remoteSource;
  final SyncManager _syncManager;

  ChallengingBehaviourRepositoryImpl(
    this._localSource,
    this._remoteSource,
    this._syncManager,
  ) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  List<ChallengingBehaviour> getAllCb() {
    return _localSource
        .getAllBehaviours()
        .map((entity) => entity.toModel())
        .toList();
  }

  @override
  void saveCb(ChallengingBehaviour cb) {
    if (cb.id == 0 || cb.remoteId == null) {
      cb.pendingAction = PendingAction.CREATE;
      cb.isSynced = false;
    } else {
      cb.pendingAction = PendingAction.UPDATE;
      cb.isSynced = false;
    }
    cb.updatedAt = DateTime.now();
    _localSource.putBehaviour(cb.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteCb(ChallengingBehaviour cb) {
    final entity = cb.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();
    _localSource.putBehaviour(entity);

    _syncManager.processOnce();
  }

  @override
  void addDe(int cbId, ChallengingBehaviourDiaryEntry cbed) {
    _localSource.addDiaryEntry(cbId, cbed.toEntity());
    final updatedEntity = _localSource.getById(cbId);
    saveCb(updatedEntity!.toModel());
  }

  @override
  void deleteDe(int cbId, ChallengingBehaviourDiaryEntry cbed) {
    if (cbed.id == null) return;

    final parent = _localSource.getById(cbId);

    if (parent == null) return;

    _localSource.deleteDiaryEntry(cbed.id!);

    parent.pendingAction = PendingAction.UPDATE.index;
    parent.isSynced = false;
    parent.updatedAt = DateTime.now();

    _localSource.putBehaviour(parent);

    _syncManager.processOnce();
  }

  @override
  List<ChallengingBehaviourDiaryEntry> getAllDe(int cbId) {
    final entries = _localSource.getDiaryEntries(behaviourId: cbId);
    return entries.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> fetchRemote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final remoteData = await _remoteSource.getAllRemote(userId: userId);
      final localData = _localSource.getAllBehaviours();

      final remoteIds = <String>{};

      for (final remoteEntity in remoteData) {
        remoteIds.add(remoteEntity.remoteId!);

        final local = _localSource.getByRemoteId(remoteEntity.remoteId!);

        final entityToSave = remoteEntity.toEntity();
        entityToSave.id = 0;

        for (final diaryEntry in entityToSave.diaryEntries) {
          diaryEntry.id = 0;
        }

        if (local != null) {
          entityToSave.id = local.id;

          for (final localEntry in local.diaryEntries) {
            _localSource.deleteDiaryEntry(localEntry.id!);
          }

          if (local.pendingAction != PendingAction.NONE.index) {
            entityToSave.pendingAction = local.pendingAction;
            entityToSave.isSynced = local.isSynced;
          }
        }
        _localSource.putBehaviour(entityToSave);
      }

      for (final localEntity in localData) {
        if (!remoteIds.contains(localEntity.remoteId)) {
          _localSource.deleteBehaviour(localEntity.id);
        }
      }
    } catch (e) {
      print('Error fetching remote challenging behaviours: $e');
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
          _localSource.putBehaviour(e);
        } else if (action == PendingAction.UPDATE) {
          if (e.remoteId == null) {
            e.pendingAction = PendingAction.NONE.index;

            await _remoteSource.createRemote(e.toRemote());
            e.isSynced = true;
            _localSource.putBehaviour(e);
          } else {
            e.pendingAction = PendingAction.NONE.index;

            await _remoteSource.updateRemote(e.toRemote());
            e.isSynced = true;
            _localSource.putBehaviour(e);
          }
        } else if (action == PendingAction.DELETE) {
          if (e.remoteId != null) {
            await _remoteSource.deleteRemote(e);
          }
          _localSource.deleteBehaviour(e.id);
        }
      } catch (err) {
        continue;
      }
    }
  }

  @override
  Stream<List<ChallengingBehaviour>> watchAll() {
    return _localSource.watchAllBehaviours().map(
      (entities) => entities.map((e) => e.toModel()).toList(),
    );
  }
}
