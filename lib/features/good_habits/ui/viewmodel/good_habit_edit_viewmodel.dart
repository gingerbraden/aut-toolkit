import 'package:aut_toolkit/core/model/sync_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/good_habit.dart';
import '../../provider/good_habits_notifier.dart';

final goodHabitViewModelProvider = NotifierProvider.autoDispose
    .family<GoodHabitEditViewmodel, GoodHabitFormState, GoodHabit>(
      GoodHabitEditViewmodel.new,
    );

class GoodHabitEditViewmodel extends Notifier<GoodHabitFormState> {
  final GoodHabit _habit;

  GoodHabitEditViewmodel(this._habit);

  @override
  GoodHabitFormState build() {
    final h = _habit;
    return GoodHabitFormState(
      name: h.name,
      description: h.description,
      occuring: h.isOcuringFlag ? Occuring.ocurring : Occuring.notOccuring,
      fromDate: h.from,
      toDate: h.to,
      remoteId: h.remoteId,
      pendingAction: h.pendingAction
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateOccuring(Occuring occuring) {
    state = state.copyWith(occuring: occuring);
  }

  void updateFromDate(DateTime date) {
    state = state.copyWith(fromDate: date);
  }

  void updateToDate(DateTime? date) {
    state = state.copyWith(toDate: date);
  }

  void saveChanges() {
    final selectedPersonId = ref.watch(selectedPersonProvider)!.id!;


    final updatedHabit = GoodHabit(
      id: _habit.id,
      userId: _habit.userId,
      selectedPersonId: selectedPersonId,
      name: state.name,
      description: state.description,
      isOcuringFlag: state.occuring == Occuring.ocurring,
      from: state.fromDate,
      to: state.toDate,
      updatedAt: DateTime.now(),
      remoteId: _habit.remoteId,
      pendingAction: _habit.pendingAction
    );

    ref.read(goodHabitsProvider.notifier).addHabit(updatedHabit);
  }
}

enum Occuring { ocurring, notOccuring }

class GoodHabitFormState {
  final String name;
  final String description;
  final Occuring occuring;
  final DateTime fromDate;
  final DateTime? toDate;
  final String? remoteId;
  final PendingAction? pendingAction;

  GoodHabitFormState({
    required this.name,
    required this.description,
    required this.occuring,
    required this.fromDate,
    this.toDate,
    this.remoteId,
    this.pendingAction
  });

  GoodHabitFormState copyWith({
    String? name,
    String? description,
    Occuring? occuring,
    DateTime? fromDate,
    DateTime? toDate,
    String? remoteId,
    PendingAction? pendingAction
  }) {
    return GoodHabitFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      occuring: occuring ?? this.occuring,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      remoteId: remoteId ?? this.remoteId,
      pendingAction: pendingAction ?? this.pendingAction
    );
  }
}
