import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/model/first_then_board.dart';
import '../../provider/first_then_board_notifier.dart';

final firstThenBoardEditViewModelProvider =
    StateNotifierProvider.family<
      FirstThenBoardEditViewModel,
      FirstThenBoardEditFormState,
      FirstThenBoard
    >((ref, board) => FirstThenBoardEditViewModel(ref, board));

class FirstThenBoardEditFormState {
  final String name;
  final UserCard first;
  final UserCard then;

  FirstThenBoardEditFormState({
    required this.name,
    required this.first,
    required this.then,
  });

  FirstThenBoardEditFormState copyWith({
    String? name,
    UserCard? first,
    UserCard? then,
  }) => FirstThenBoardEditFormState(
    name: name ?? this.name,
    first: first ?? this.first,
    then: then ?? this.then,
  );
}

class FirstThenBoardEditViewModel
    extends StateNotifier<FirstThenBoardEditFormState> {
  final Ref ref;
  final FirstThenBoard _board;

  FirstThenBoardEditViewModel(this.ref, this._board)
    : super(
        FirstThenBoardEditFormState(
          name: _board.name,
          first: _board.first,
          then: _board.then,
        ),
      );

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateFirst(UserCard first) {
    state = state.copyWith(first: first);
  }

  void updateThen(UserCard then) {
    state = state.copyWith(then: then);
  }

  void saveChanges() {
    final updatedBoard = FirstThenBoard(
      id: _board.id,
      userId: _board.userId,
      name: state.name,
      first: state.first,
      then: state.then,
    );
    ref
        .read(firstThenBoardProvider(_board.userId).notifier)
        .addBoard(updatedBoard);
  }

  void deleteBoard() {
    ref.read(firstThenBoardProvider(_board.userId).notifier).deleteBoard(_board);
  }
}
