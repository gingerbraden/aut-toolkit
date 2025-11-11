import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/good_habit.dart';
import '../../provider/good_habits_notifier.dart';

final filteredHabitsProvider = Provider<List<GoodHabit>>((ref) {
  final habits = ref.watch(goodHabitsProvider);
  final selectedPersonId = ref
      .watch(selectedPersonsProvider.notifier)
      .getSelected()
      .id!;
  return habits.where((h) => h.selectedPersonId == selectedPersonId).toList();
});

class GoodHabitsListViewModel extends Notifier<List<GoodHabit>> {
  @override
  List<GoodHabit> build() => [];

  void loadHabits(WidgetRef ref) {
    final habits = ref.watch(goodHabitsProvider);
    final selectedPersonId = ref
        .watch(selectedPersonsProvider.notifier)
        .getSelected()
        .id!;
    state = habits
        .where((h) => h.selectedPersonId == selectedPersonId)
        .toList();
  }

  void applyFilter(GoodHabitFilter filter) {
    switch (filter) {
      case GoodHabitFilter.active:
        state = state.where((h) => h.isOcuringFlag).toList();
        break;
      case GoodHabitFilter.inactive:
        state = state.where((h) => !h.isOcuringFlag).toList();
        break;
      case GoodHabitFilter.all:
        break;
    }
  }

  void applySort(GoodHabitSort sort) {
    switch (sort) {
      case GoodHabitSort.nameAsc:
        state = [...state]..sort((a, b) => a.name.compareTo(b.name));
        break;
      case GoodHabitSort.nameDesc:
        state = [...state]..sort((a, b) => b.name.compareTo(a.name));
        break;
      case GoodHabitSort.dateAsc:
        state = [...state]..sort((a, b) => a.from.compareTo(b.from));
        break;
      case GoodHabitSort.dateDesc:
        state = [...state]..sort((a, b) => b.from.compareTo(a.from));
        break;
    }
  }
}

enum GoodHabitFilter { all, active, inactive }

enum GoodHabitSort { nameAsc, nameDesc, dateAsc, dateDesc }
