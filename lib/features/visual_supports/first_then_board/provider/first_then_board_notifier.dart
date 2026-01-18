import 'dart:async';

import 'package:aut_toolkit/core/services/objectbox.dart';
import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/repository/first_then_board_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/services/sync_manager.dart';
import '../../../../main.dart';
import '../data/model/first_then_board_entity.dart';
import '../domain/model/first_then_board.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) => objectbox);

final firstThenBoardBoxProvider = Provider<Box<FirstThenBoardEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.firstThenBoardBox;
});

final firstThenBoardLocalSourceProvider = Provider<FirstThenBoardLocalSource>((
  ref,
) {
  final box = ref.watch(firstThenBoardBoxProvider);
  return FirstThenBoardLocalSource(box);
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final firstThenBoardRemoteSourceProvider = Provider<FirstThenBoardRemoteSource>(
  (ref) {
    return FirstThenBoardRemoteSource();
  },
);

final firstThenBoardRepositoryProvider = Provider<FirstThenBoardRepository>((
  ref,
) {
  return RepoService().firstThenBoardRepositoryImpl;
});

final firstThenBoardProvider =
    StateNotifierProvider.family<
      FirstThenBoardNotifier,
      List<FirstThenBoard>,
      String
    >((ref, userId) {
      final repo = ref.watch(firstThenBoardRepositoryProvider);
      return FirstThenBoardNotifier(repo, userId);
    });

class FirstThenBoardNotifier extends StateNotifier<List<FirstThenBoard>> {
  final FirstThenBoardRepository _repo;
  final String _userId;
  late final StreamSubscription _boardSub;
  late final StreamSubscription _cardSub;

  FirstThenBoardNotifier(this._repo, this._userId) : super([]) {
    _boardSub = _repo.watchAll().listen((boards) {
      state = boards;
    });

    final cardBox = objectbox.cardBox;
    _cardSub = cardBox.query().watch(triggerImmediately: false).listen((_) {
      final currentBoards = _repo.getAllBoardsForUserId(_userId);
      state = currentBoards;
    });
  }

  @override
  void dispose() {
    _boardSub.cancel();
    _cardSub.cancel();
    super.dispose();
  }

  void addBoard(FirstThenBoard board) {
    _repo.saveBoard(board);
  }

  void deleteBoard(FirstThenBoard board) {
    _repo.deleteBoard(board);
  }
}
