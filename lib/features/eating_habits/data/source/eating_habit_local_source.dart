import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../objectbox.g.dart';

class EatingHabitLocalSource {
  final Box<EatingHabitEntity> eatingHabitBox;

  EatingHabitLocalSource(this.eatingHabitBox);

  List<EatingHabitEntity> getAll() => eatingHabitBox.getAll();

  int put(EatingHabitEntity entity) => eatingHabitBox.put(entity);

  void remove(int id) => eatingHabitBox.remove(id);

  EatingHabitEntity? getById(int id) => eatingHabitBox.get(id);

  List<EatingHabitEntity> getAllPending() {
    final q = eatingHabitBox.query(
      EatingHabitEntity_.pendingAction.notEquals(0),
    ).build();
    final result = q.find();
    q.close();
    return result;
  }
}
