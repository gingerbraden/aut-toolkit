import 'dart:async';

import 'package:aut_toolkit/core/services/objectbox.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/repository/first_then_board_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/services/sync_manager.dart';
import '../../../../main.dart';
import '../data/first_then_board_repository_impl.dart';
import '../data/model/first_then_board_entity.dart';
import '../domain/model/first_then_board.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) => objectbox);

final firstThenBoardBoxProvider =
Provider<Box<FirstThenBoardEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.firstThenBoardBox;
});

final firstThenBoardLocalSourceProvider =
Provider<FirstThenBoardLocalSource>((ref) {
  final box = ref.watch(firstThenBoardBoxProvider);
  return FirstThenBoardLocalSource(box);
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  sm.start();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final firstThenBoardRemoteSourceProvider = Provider<FirstThenBoardRemoteSource>((ref) {
  return FirstThenBoardRemoteSource();
});

final firstThenBoardRepositoryProvider =
Provider<FirstThenBoardRepository>((ref) {
  final localSource = ref.watch(firstThenBoardLocalSourceProvider);
  final remote = ref.watch(firstThenBoardRemoteSourceProvider);
  final sync = ref.watch(syncManagerProvider);
  return FirstThenBoardRepositoryImpl(localSource, remote, sync);
});

final firstThenBoardProvider = StateNotifierProvider.family<
    FirstThenBoardNotifier,
    List<FirstThenBoard>,
    String>((ref, userId) {
  final repo = ref.watch(firstThenBoardRepositoryProvider);
  return FirstThenBoardNotifier(repo, userId);
});

class FirstThenBoardNotifier extends StateNotifier<List<FirstThenBoard>> {
  final FirstThenBoardRepository _repo;
  final String _userId;
  late final StreamSubscription _sub;

  FirstThenBoardNotifier(this._repo, this._userId) : super([]) {
    _sub = _repo.watchAll().listen((boards) {
      state = boards;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void addBoard(FirstThenBoard board) {
    _repo.saveBoard(board);
  }

  void deleteBoard(FirstThenBoard board) {
    _repo.deleteBoard(board);
  }
}
