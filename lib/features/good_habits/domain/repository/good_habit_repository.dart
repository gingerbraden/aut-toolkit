import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';

abstract class GoodHabitRepository {
  List<GoodHabit> getAllHabits();
  void saveHabit(GoodHabit eatingHabit);
  void deleteHabit(GoodHabit eatingHabit);
}
