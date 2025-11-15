import 'package:flutter_riverpod/legacy.dart';

import '../../../../card_management/domain/model/user_card.dart';
import '../../domain/model/first_then_board.dart';

final firstThenBoardDetailViewModelProvider =
    StateNotifierProvider.family<
      FirstThenBoardDetailViewModel,
      FirstThenBoardState,
      FirstThenBoard
    >((ref, board) => FirstThenBoardDetailViewModel(board));

class FirstThenBoardDetailViewModel extends StateNotifier<FirstThenBoardState> {
  FirstThenBoardDetailViewModel(FirstThenBoard board)
    : super(FirstThenBoardState(first: board.first, then: board.then));
}

class FirstThenBoardState {
  final UserCard first;
  final UserCard then;

  const FirstThenBoardState({required this.first, required this.then});

  FirstThenBoardState copyWith({UserCard? first, UserCard? then}) {
    return FirstThenBoardState(
      first: first ?? this.first,
      then: then ?? this.then,
    );
  }
}
