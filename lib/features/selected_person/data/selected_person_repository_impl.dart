import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_local_source.dart';
import 'package:aut_toolkit/features/good_habits/data/source/good_habit_local_source.dart';
import 'package:aut_toolkit/features/selected_person/data/model/selected_person_mappers.dart';
import 'package:aut_toolkit/features/selected_person/data/source/selected_person_local_source.dart';
import 'package:aut_toolkit/features/selected_person/data/source/selected_person_remote_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';
import '../domain/model/selected_person.dart';
import '../domain/repository/selected_person_repository.dart';

class SelectedPersonRepositoryImpl
    implements SelectedPersonRepository, SyncableRepository {
  final SelectedPersonLocalSource _localSource;
  final ChallengingBehaviourLocalSource _challengingBehaviourLocalSource;
  final EatingHabitLocalSource _eatingHabitLocalSource;
  final GoodHabitLocalSource _goodHabitLocalSource;
  final SelectedPersonRemoteSource _remoteSource;
  final SyncManager _syncManager;

  SelectedPersonRepositoryImpl(
    this._localSource,
    this._challengingBehaviourLocalSource,
    this._eatingHabitLocalSource,
    this._goodHabitLocalSource,
    this._remoteSource,
    this._syncManager,
  ) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  List<SelectedPerson> getAll() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void save(SelectedPerson sp) {
    final allPersons = _localSource.getAll();

    final now = DateTime.now();

    for (var person in allPersons) {
      if (person.isSelected) {
        person.isSelected = false;
        person.updatedAt = now;
        person.isSynced = false;
        person.pendingAction = person.id == 0 || person.remoteId == null
            ? PendingAction.CREATE.index
            : PendingAction.UPDATE.index;

        _localSource.put(person);
      }
    }

    sp.isSelected = true;
    sp.updatedAt = now;
    sp.isSynced = false;
    sp.pendingAction = sp.id == 0 || sp.remoteId == null
        ? PendingAction.CREATE
        : PendingAction.UPDATE;

    _localSource.put(sp.toEntity());

    _syncManager.processOnce();
  }


  @override
  void delete(SelectedPerson sp) {
    if (sp.id == null || sp.id == 0) return;

    final now = DateTime.now();

    final spEntity = sp.toEntity();
    spEntity.isDeleted = true;
    spEntity.pendingAction = PendingAction.DELETE.index;
    spEntity.isSynced = false;
    spEntity.updatedAt = now;

    _localSource.put(spEntity);

    for (var chb in _challengingBehaviourLocalSource.getAllBehaviours()) {
      if (chb.selectedPersonId == sp.id!) {
        final entity = chb;
        entity.isDeleted = true;
        entity.pendingAction = PendingAction.DELETE.index;
        entity.isSynced = false;
        entity.updatedAt = now;

        _challengingBehaviourLocalSource.putBehaviour(entity);
      }
    }

    for (var eh in _eatingHabitLocalSource.getAll()) {
      if (eh.selectedPersonId == sp.id!) {
        final entity = eh;
        entity.isDeleted = true;
        entity.pendingAction = PendingAction.DELETE.index;
        entity.isSynced = false;
        entity.updatedAt = now;

        _eatingHabitLocalSource.put(entity);
      }
    }

    for (var gh in _goodHabitLocalSource.getAll()) {
      if (gh.selectedPersonId == sp.id!) {
        final entity = gh;
        entity.isDeleted = true;
        entity.pendingAction = PendingAction.DELETE.index;
        entity.isSynced = false;
        entity.updatedAt = now;

        _goodHabitLocalSource.put(entity);
      }
    }

    final remainingPersons = _localSource.getAll()
        .where((p) => !p.isDeleted && p.id != sp.id)
        .toList();

    if (remainingPersons.isNotEmpty) {
      final next = remainingPersons.first;
      next.isSelected = true;
      next.pendingAction = PendingAction.UPDATE.index;
      next.isSynced = false;
      next.updatedAt = now;
      _localSource.put(next);
    }

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
      print('Error fetching remote first-then boards in repository: $e');
    }
  }

  @override
  Stream<List<SelectedPerson>> watchAll() {
    return _localSource
        .watchAll()
        .map((entities) => entities.map((e) => e.toModel()).toList());
  }
}
