import 'package:aut_toolkit/features/visual_supports/first_then_board/data/model/first_then_board_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';

class FirstThenBoardLocalSource {
  final Box<FirstThenBoardEntity> firstThenBoardBox;

  FirstThenBoardLocalSource(this.firstThenBoardBox);

  List<FirstThenBoardEntity> getAllForUserId(String userId) {
    Query<FirstThenBoardEntity> q = firstThenBoardBox
        .query(FirstThenBoardEntity_.userId.equals(userId))
        .build();
    List<FirstThenBoardEntity> l = q.find();
    return l;
  }

  int put(FirstThenBoardEntity entity) => firstThenBoardBox.put(entity);

  void remove(int id) => firstThenBoardBox.remove(id);
}
