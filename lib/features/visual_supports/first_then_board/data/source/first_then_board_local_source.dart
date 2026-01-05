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

  List<FirstThenBoardEntity> getAll() => firstThenBoardBox.getAll();

  FirstThenBoardEntity? getById(int id) => firstThenBoardBox.get(id);

  Stream<List<FirstThenBoardEntity>> watchAll() {
    final builder = firstThenBoardBox.query();

    return builder.watch(triggerImmediately: true).map((query) {
      final result = query.find();
      return result;
    });
  }

  List<FirstThenBoardEntity> getAllPending() {
    final q = firstThenBoardBox.query(FirstThenBoardEntity_.pendingAction.notEquals(0)).build();
    final result = q.find();
    q.close();
    return result;
  }
}
