import 'package:aut_toolkit/core/model/sync_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/challenging_behaviour.dart';
import '../../provider/challenging_behaviour_notifier.dart';

final challengingBehaviourEditViewModelProvider =
NotifierProvider.autoDispose
    .family<ChallengingBehaviourEditViewModel,
    ChallengingBehaviourEditState,
    ChallengingBehaviour>(
  ChallengingBehaviourEditViewModel.new,
);

class ChallengingBehaviourEditViewModel
    extends Notifier<ChallengingBehaviourEditState> {
  final ChallengingBehaviour _behaviour;

  ChallengingBehaviourEditViewModel(this._behaviour);

  @override
  ChallengingBehaviourEditState build() {
    final cb = _behaviour;

    return ChallengingBehaviourEditState(
      occuring: cb.occuring ? Occuring.ocurring : Occuring.notOccuring,
      fromDate: cb.from,
      name: cb.name,
      description: cb.description,
      remoteId: cb.remoteId,
      pendingAction: cb.pendingAction,
    );
  }

  void updateOccuring(Occuring value) {
    state = state.copyWith(occuring: value);
  }

  void updateDate(DateTime newDate) {
    state = state.copyWith(fromDate: newDate);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDescription(String desc) {
    state = state.copyWith(description: desc);
  }

  void saveChanges() {
    final selectedPersonId = ref
        .read(selectedPersonsProvider.notifier)
        .getSelected()
        .id!;

    final updatedCb = ChallengingBehaviour(
      id: _behaviour.id!,
      name: state.name,
      from: state.fromDate,
      description: state.description,
      diaryEntries: _behaviour.diaryEntries,
      occuring: state.occuring == Occuring.ocurring,
      userId: _behaviour.userId,
      selectedPersonId: selectedPersonId,
      updatedAt: DateTime.now(),
      pendingAction: _behaviour.pendingAction,
      remoteId: _behaviour.remoteId,
    );

    ref.read(challengingBehavioursProvider.notifier).addBehaviour(updatedCb);
  }
}

enum Occuring { ocurring, notOccuring }

class ChallengingBehaviourEditState {
  final Occuring occuring;
  final DateTime fromDate;
  final String name;
  final String description;
  final String? remoteId;
  final PendingAction? pendingAction;

  const ChallengingBehaviourEditState({
    required this.occuring,
    required this.fromDate,
    required this.name,
    required this.description,
    this.remoteId,
    this.pendingAction,
  });

  ChallengingBehaviourEditState copyWith({
    Occuring? occuring,
    DateTime? fromDate,
    String? name,
    String? description,
    String? remoteId,
    PendingAction? pendingAction,
  }) {
    return ChallengingBehaviourEditState(
      occuring: occuring ?? this.occuring,
      fromDate: fromDate ?? this.fromDate,
      name: name ?? this.name,
      description: description ?? this.description,
      remoteId: remoteId ?? this.remoteId,
      pendingAction: pendingAction ?? this.pendingAction,
    );
  }
}
