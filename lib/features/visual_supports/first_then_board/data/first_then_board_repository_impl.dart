import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/model/first_then_board_mappers.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/model/first_then_board.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/repository/first_then_board_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/model/sync_entity.dart';
import '../../../../core/services/sync_manager.dart';

class FirstThenBoardRepositoryImpl implements FirstThenBoardRepository, SyncableRepository {
  final FirstThenBoardLocalSource _localSource;
  final FirstThenBoardRemoteSource _remoteSource;
  final SyncManager _syncManager;

  FirstThenBoardRepositoryImpl(this._localSource, this._remoteSource, this._syncManager) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  void saveBoard(FirstThenBoard board) {
    if (board.id == 0 || board.remoteId == null) {
      board.pendingAction = PendingAction.CREATE;
      board.isSynced = false;
    } else {
      board.pendingAction = PendingAction.UPDATE;
      board.isSynced = false;
    }
    board.updatedAt = DateTime.now();
    _localSource.put(board.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteBoard(FirstThenBoard board) {
    final entity = board.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();

    _localSource.put(entity);
    _syncManager.processOnce();
  }

  @override
  List<FirstThenBoard> getAllBoardsForUserId(String userId) {
    return _localSource
        .getAllForUserId(userId)
        .map((e) => e.toModel())
        .toList();
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
  Stream<List<FirstThenBoard>> watchAll() {
    return _localSource.watchAll().map(
          (entities) => entities.map((e) => e.toModel()).toList(),
    );
  }
}
