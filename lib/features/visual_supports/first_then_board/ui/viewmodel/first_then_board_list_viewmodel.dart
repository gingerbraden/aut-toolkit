import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/model/first_then_board.dart';
import '../../provider/first_then_board_notifier.dart';

final firstThenBoardViewModelProvider =
    StateNotifierProvider.family<
      FirstThenBoardViewModel,
      List<FirstThenBoard>,
      String
    >((ref, userId) => FirstThenBoardViewModel(ref, userId));

class FirstThenBoardViewModel extends StateNotifier<List<FirstThenBoard>> {
  final Ref ref;
  final String userId;
  List<FirstThenBoard> _allBoards = [];
  String _searchQuery = '';

  FirstThenBoardViewModel(this.ref, this.userId) : super([]) {
    loadBoards();
  }

  void loadBoards() {
    _allBoards = ref.watch(firstThenBoardProvider(userId)).where((h)=>!h.isDeleted).toList();
    _applySearch();
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      state = _allBoards;
    } else {
      state = _allBoards
          .where(
            (b) => b.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
  }
}
