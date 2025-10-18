import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:objectbox/objectbox.dart';

class EatingHabitLocalSource {
  final Box<EatingHabitEntity> eatingHabitBox;

  EatingHabitLocalSource(this.eatingHabitBox);

  List<EatingHabitEntity> getAll() => eatingHabitBox.getAll();

  int put(EatingHabitEntity entity) => eatingHabitBox.put(entity);

  void remove(int id) => eatingHabitBox.remove(id);
}
