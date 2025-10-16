import 'package:aut_toolkit/features/eating_habits/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/repository/eating_habits_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EatingHabitsNotifier extends Notifier<List<EatingHabit>> {
  @override
  List<EatingHabit> build() {
    return EatingHabitsRepository().getHabits();
  }
}

final eatingHabitsNotifierProvider =
    NotifierProvider<EatingHabitsNotifier, List<EatingHabit>>(() {
      return EatingHabitsNotifier();
    });
