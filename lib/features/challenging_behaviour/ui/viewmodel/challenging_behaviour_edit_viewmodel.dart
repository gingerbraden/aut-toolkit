import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/features/selected_person/provider/selected_person_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Occuring { ocurring, notOccuring }

class ChallengingBehaviourEditState {
  final Occuring occuring;
  final DateTime fromDate;

  const ChallengingBehaviourEditState({
    required this.occuring,
    required this.fromDate,
  });

  ChallengingBehaviourEditState copyWith({
    Occuring? occuring,
    DateTime? fromDate,
  }) {
    return ChallengingBehaviourEditState(
      occuring: occuring ?? this.occuring,
      fromDate: fromDate ?? this.fromDate,
    );
  }
}

class ChallengingBehaviourEditViewModel
    extends Notifier<ChallengingBehaviourEditState> {
  late ChallengingBehaviour cb;
  late bool isNew;
  late BuildContext context;

  @override
  ChallengingBehaviourEditState build() => ChallengingBehaviourEditState(
    occuring: Occuring.ocurring,
    fromDate: DateTime.now(),
  );

  void init({
    required ChallengingBehaviour behaviour,
    required bool isNewBehaviour,
    required BuildContext ctx,
  }) {
    cb = behaviour;
    isNew = isNewBehaviour;
    context = ctx;

    state = ChallengingBehaviourEditState(
      occuring: cb.occuring ? Occuring.ocurring : Occuring.notOccuring,
      fromDate: cb.from,
    );
  }

  void setOccuring(Occuring value) {
    state = state.copyWith(occuring: value);
  }

  Future<void> pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: state.fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    state = state.copyWith(fromDate: newDate);
  }

  void saveChanges({
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
  }) {
    if (!(formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.change_saved), behavior: SnackBarBehavior.floating, showCloseIcon: true));

    final updatedCb = ChallengingBehaviour(
      id: cb.id!,
      name: nameController.text.trim(),
      from: state.fromDate,
      description: descriptionController.text.trim(),
      diaryEntries: [],
      occuring: state.occuring == Occuring.ocurring,
      userId: cb.userId,
      selectedPersonId: ref
          .watch(selectedPersonsProvider.notifier)
          .getSelected()
          .id!,
    );

    ref.read(challengingBehavioursProvider.notifier).addBehaviour(updatedCb);
    router.pop();
    if (!isNew) router.pop(true);
  }
}

final challengingBehaviourEditViewModelProvider =
    NotifierProvider<
      ChallengingBehaviourEditViewModel,
      ChallengingBehaviourEditState
    >(ChallengingBehaviourEditViewModel.new);
