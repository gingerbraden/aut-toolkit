import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/features/selected_person/provider/selected_person_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengingBehaviourEditViewModelProvider =
    NotifierProvider<
      ChallengingBehaviourEditViewModel,
      ChallengingBehaviourEditState
    >(ChallengingBehaviourEditViewModel.new);

class ChallengingBehaviourEditViewModel
    extends Notifier<ChallengingBehaviourEditState> {
  late ChallengingBehaviour cb;
  late bool isNew;

  @override
  ChallengingBehaviourEditState build() => ChallengingBehaviourEditState(
    occuring: Occuring.ocurring,
    fromDate: DateTime.now(),
    name: "",
    description: "",
  );

  void init({
    required ChallengingBehaviour behaviour,
    required bool isNewBehaviour,
  }) {
    cb = behaviour;
    isNew = isNewBehaviour;

    state = ChallengingBehaviourEditState(
      occuring: cb.occuring ? Occuring.ocurring : Occuring.notOccuring,
      fromDate: cb.from,
      name: cb.name,
      description: cb.description,
    );
  }

  void setOccuring(Occuring value) {
    state = state.copyWith(occuring: value);
  }

  void setDate(DateTime newDate) {
    state = state.copyWith(fromDate: newDate);
  }

  void setName(String name) => state = state.copyWith(name: name);

  void setDescription(String desc) => state = state.copyWith(description: desc);

  void saveChanges() {
    final selectedPersonId = ref
        .watch(selectedPersonsProvider.notifier)
        .getSelected()
        .id!;

    final updatedCb = ChallengingBehaviour(
      id: cb.id!,
      name: state.name,
      from: state.fromDate,
      description: state.description,
      diaryEntries: cb.diaryEntries,
      occuring: state.occuring == Occuring.ocurring,
      userId: cb.userId,
      selectedPersonId: selectedPersonId,
    );

    ref.read(challengingBehavioursProvider.notifier).addBehaviour(updatedCb);
  }

  ChallengingBehaviour createUpdatedBehaviour({
    required String name,
    required String description,
    required int selectedPersonId,
  }) {
    return ChallengingBehaviour(
      id: cb.id!,
      name: name.trim(),
      from: state.fromDate,
      description: description.trim(),
      diaryEntries: [],
      occuring: state.occuring == Occuring.ocurring,
      userId: cb.userId,
      selectedPersonId: selectedPersonId,
    );
  }
}

enum Occuring { ocurring, notOccuring }

class ChallengingBehaviourEditState {
  final Occuring occuring;
  final DateTime fromDate;
  final String name;
  final String description;

  const ChallengingBehaviourEditState({
    required this.occuring,
    required this.fromDate,
    required this.name,
    required this.description,
  });

  ChallengingBehaviourEditState copyWith({
    Occuring? occuring,
    DateTime? fromDate,
    String? name,
    String? description,
  }) {
    return ChallengingBehaviourEditState(
      occuring: occuring ?? this.occuring,
      fromDate: fromDate ?? this.fromDate,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
