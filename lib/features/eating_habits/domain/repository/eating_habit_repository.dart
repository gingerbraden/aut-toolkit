import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';

abstract class EatingHabitRepository {
  List<EatingHabit> getAllHabits();

  void saveUser(EatingHabit eatingHabit);
}
