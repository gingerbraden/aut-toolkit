import 'package:aut_toolkit/core/services/objectbox.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/repository/first_then_board_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../main.dart';
import '../data/first_then_board_repository_impl.dart';
import '../data/model/first_then_board_entity.dart';
import '../domain/model/first_then_board.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final firstThenBoardBoxBoxProvider = Provider<Box<FirstThenBoardEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.firstThenBoardBox;
});

final firstThenBoardBoxLocalSourceProvider =
    Provider<FirstThenBoardLocalSource>((ref) {
      final box = ref.watch(firstThenBoardBoxBoxProvider);
      return FirstThenBoardLocalSource(box);
    });

final firstThenBoardBoxRepositoryProvider = Provider<FirstThenBoardRepository>((
  ref,
) {
  final localSource = ref.watch(firstThenBoardBoxLocalSourceProvider);
  return FirstThenBoardRepositoryImpl(localSource);
});

final firstThenBoardProvider =
    StateNotifierProvider.family<
      FirstThenBoardNotifier,
      List<FirstThenBoard>,
      String
    >((ref, userId) {
      final repo = ref.watch(firstThenBoardBoxRepositoryProvider);
      return FirstThenBoardNotifier(repo, userId);
    });

class FirstThenBoardNotifier extends StateNotifier<List<FirstThenBoard>> {
  final FirstThenBoardRepository _repo;
  final String _userId;

  FirstThenBoardNotifier(this._repo, this._userId) : super([]) {
    loadBoards();
  }

  void loadBoards() {
    state = _repo.getAllBoardsForUserId(_userId);
  }

  void addHabit(FirstThenBoard board) {
    _repo.saveBoard(board);
    loadBoards();
  }

  void deleteHabit(FirstThenBoard board) {
    _repo.deleteBoard(board);
    loadBoards();
  }
}
