import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/eating_habit.dart';
import '../../provider/eating_habits_notifier.dart';

final eatingHabitViewModelProvider = NotifierProvider.autoDispose
    .family<EatingHabitEditViewModel, EatingHabitFormState, EatingHabit>(
      EatingHabitEditViewModel.new,
    );

class EatingHabitEditViewModel extends Notifier<EatingHabitFormState> {
  final EatingHabit _habit;

  EatingHabitEditViewModel(this._habit);

  @override
  EatingHabitFormState build() {
    return EatingHabitFormState(
      name: _habit.name,
      description: _habit.description,
      status: _habit.isEatingFlag
          ? EatingStatus.eating
          : EatingStatus.notEating,
      fromDate: _habit.from,
      toDate: _habit.to,
      imagePath: _habit.imageFilePath,
    );
  }

  void updateName(String name) => state = state.copyWith(name: name);

  void updateDescription(String description) =>
      state = state.copyWith(description: description);

  void updateStatus(EatingStatus status) =>
      state = state.copyWith(status: status);

  void updateFromDate(DateTime date) => state = state.copyWith(fromDate: date);

  void updateToDate(DateTime? date) => state = state.copyWith(toDate: date);

  void updateImage(String? path) => state = state.copyWith(imagePath: path);

  void saveChanges(WidgetRef ref) {
    final selectedPersonId = ref
        .read(selectedPersonsProvider.notifier)
        .getSelected()
        .id!;
    final updatedHabit = EatingHabit(
      id: _habit.id,
      userId: _habit.userId,
      selectedPersonId: selectedPersonId,
      name: state.name,
      description: state.description,
      isEatingFlag: state.status == EatingStatus.eating,
      from: state.fromDate,
      to: state.toDate,
      imageFilePath: state.imagePath,
    );
    ref.read(eatingHabitsProvider.notifier).addHabit(updatedHabit);
  }
}

enum EatingStatus { eating, notEating }

class EatingHabitFormState {
  final String name;
  final String description;
  final EatingStatus status;
  final DateTime fromDate;
  final DateTime? toDate;
  final String? imagePath;

  EatingHabitFormState({
    required this.name,
    required this.description,
    required this.status,
    required this.fromDate,
    this.toDate,
    this.imagePath,
  });

  EatingHabitFormState copyWith({
    String? name,
    String? description,
    EatingStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    String? imagePath,
  }) {
    return EatingHabitFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
