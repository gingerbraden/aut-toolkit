import 'package:aut_toolkit/features/visual_supports/first_then_board/domain/model/first_then_board.dart';

abstract class FirstThenBoardRepository {
  List<FirstThenBoard> getAllBoardsForUserId(String userId);
  void saveBoard(FirstThenBoard board);
  void deleteBoard(FirstThenBoard board);
}
