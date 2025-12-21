import 'package:objectbox/objectbox.dart';

import '../../../../objectbox.g.dart';
import '../model/good_habit_entity.dart';

class GoodHabitLocalSource {
  final Box<GoodHabitEntity> goodHabitBox;

  GoodHabitLocalSource(this.goodHabitBox);

  List<GoodHabitEntity> getAll() => goodHabitBox.getAll();

  int put(GoodHabitEntity entity) => goodHabitBox.put(entity);

  void remove(int id) => goodHabitBox.remove(id);

  GoodHabitEntity? getById(int id) => goodHabitBox.get(id);

  List<GoodHabitEntity> getAllPending() {
    final q = goodHabitBox.query(
      GoodHabitEntity_.pendingAction.notEquals(0),
    ).build();
    final result = q.find();
    q.close();
    return result;
  }

  Stream<List<GoodHabitEntity>> watchAllBehaviours() {
    final builder = goodHabitBox.query();

    return builder
        .watch(triggerImmediately: true)
        .map((query) {
      final result = query.find();
      return result;
    });
  }
}
