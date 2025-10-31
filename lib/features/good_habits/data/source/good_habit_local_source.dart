import 'package:objectbox/objectbox.dart';

import '../model/good_habit_entity.dart';

class GoodHabitLocalSource {
  final Box<GoodHabitEntity> goodHabitBox;

  GoodHabitLocalSource(this.goodHabitBox);

  List<GoodHabitEntity> getAll() => goodHabitBox.getAll();

  int put(GoodHabitEntity entity) => goodHabitBox.put(entity);

  void remove(int id) => goodHabitBox.remove(id);
}
