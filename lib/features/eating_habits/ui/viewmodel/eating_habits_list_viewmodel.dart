import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/eating_habit.dart';
import '../../provider/eating_habits_notifier.dart';

final filteredEatingHabitsProvider = Provider<List<EatingHabit>>((ref) {
  final habits = ref.watch(eatingHabitsProvider);
  final selectedPerson = ref.watch(selectedPersonProvider);
  return habits.where((h) => h.selectedPersonId == selectedPerson!.remoteId).where((h)=>!h.isDeleted).toList();
});

class EatingHabitsListViewModel extends Notifier<List<EatingHabit>> {
  @override
  List<EatingHabit> build() => [];

  void applyFilter(EatingHabitFilter filter) {
    switch (filter) {
      case EatingHabitFilter.eating:
        state = state.where((h) => h.isEatingFlag).toList();
        break;
      case EatingHabitFilter.notEating:
        state = state.where((h) => !h.isEatingFlag).toList();
        break;
      case EatingHabitFilter.active:
        state = state
            .where(
              (h) =>
                  h.to != null &&
                  h.from.isBefore(DateTime.now()) &&
                  h.to!.isAfter(DateTime.now()),
            )
            .toList();
        break;
      case EatingHabitFilter.inactive:
        state = state
            .where(
              (h) =>
                  h.to == null ||
                  h.to!.isBefore(DateTime.now()) ||
                  h.from.isAfter(DateTime.now()),
            )
            .toList();
        break;
      case EatingHabitFilter.all:
        break;
    }
  }

  void applySort(EatingHabitSort sort) {
    switch (sort) {
      case EatingHabitSort.nameAsc:
        state = [...state]..sort((a, b) => a.name.compareTo(b.name));
        break;
      case EatingHabitSort.nameDesc:
        state = [...state]..sort((a, b) => b.name.compareTo(a.name));
        break;
      case EatingHabitSort.dateAsc:
        state = [...state]..sort((a, b) => a.from.compareTo(b.from));
        break;
      case EatingHabitSort.dateDesc:
        state = [...state]..sort((a, b) => b.from.compareTo(a.from));
        break;
    }
  }
}

enum EatingHabitFilter { all, eating, notEating, active, inactive }

enum EatingHabitSort { nameAsc, nameDesc, dateAsc, dateDesc }
