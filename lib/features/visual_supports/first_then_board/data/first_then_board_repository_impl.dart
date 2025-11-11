import 'package:aut_toolkit/features/visual_supports/first_then_board/data/model/first_then_board_mappers.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/source/first_then_board_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/model/first_then_board.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/repository/first_then_board_repository.dart';

class FirstThenBoardRepositoryImpl implements FirstThenBoardRepository {
  final FirstThenBoardLocalSource _localSource;

  FirstThenBoardRepositoryImpl(this._localSource);

  @override
  void saveBoard(FirstThenBoard board) {
    _localSource.put(board.toEntity());
  }

  @override
  void deleteBoard(FirstThenBoard board) {
    _localSource.remove(board.id!);
  }

  @override
  List<FirstThenBoard> getAllBoardsForUserId(String userId) {
    return _localSource
        .getAllForUserId(userId)
        .map((e) => e.toModel())
        .toList();
  }
}
