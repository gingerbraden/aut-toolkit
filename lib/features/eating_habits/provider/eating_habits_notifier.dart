import 'package:aut_toolkit/features/eating_habits/data/eating_habit_repository_impl.dart';
import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_local_source.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/domain/repository/eating_habit_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../main.dart';

/// Provides the global ObjectBox instance initialized in main()
final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox; // uses the global variable from main.dart
});

/// Provides the EatingHabitEntity box
final eatingHabitBoxProvider = Provider<Box<EatingHabitEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.eatingHabitEntityBox;
});

// ✅ 2. Provide the local source
final eatingHabitLocalSourceProvider = Provider<EatingHabitLocalSource>((ref) {
  final box = ref.watch(eatingHabitBoxProvider);
  return EatingHabitLocalSource(box);
});

// ✅ 3. Provide the repository (domain-level interface)
final eatingHabitRepositoryProvider = Provider<EatingHabitRepository>((ref) {
  final localSource = ref.watch(eatingHabitLocalSourceProvider);
  return EatingHabitRepositoryImpl(localSource);
});

// ✅ 4. StateNotifier for managing habits in the UI
final eatingHabitsProvider =
    StateNotifierProvider<EatingHabitsNotifier, List<EatingHabit>>((ref) {
      final repo = ref.watch(eatingHabitRepositoryProvider);
      return EatingHabitsNotifier(repo);
    });

class EatingHabitsNotifier extends StateNotifier<List<EatingHabit>> {
  final EatingHabitRepository _repo;

  EatingHabitsNotifier(this._repo) : super([]) {
    loadHabits();
  }

  void loadHabits() {
    state = _repo.getAllHabits();
  }

  void addHabit(EatingHabit habit) {
    _repo.saveHabit(habit);
    loadHabits();
  }

  void deleteHabit(EatingHabit habit) {
    _repo.deleteHabit(habit);
    loadHabits();
  }
}
