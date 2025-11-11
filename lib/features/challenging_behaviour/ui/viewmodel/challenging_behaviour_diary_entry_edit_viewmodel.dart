import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengingBehaviourDiaryEntryEditState {
  final DateTime date;
  final List<String> people;

  const ChallengingBehaviourDiaryEntryEditState({
    required this.date,
    required this.people,
  });

  ChallengingBehaviourDiaryEntryEditState copyWith({
    DateTime? date,
    List<String>? people,
  }) {
    return ChallengingBehaviourDiaryEntryEditState(
      date: date ?? this.date,
      people: people ?? List.from(this.people),
    );
  }
}

class ChallengingBehaviourDiaryEntryEditViewModel
    extends Notifier<ChallengingBehaviourDiaryEntryEditState> {
  late ChallengingBehaviourDiaryEntry entry;
  late bool isNew;
  late int cbId;
  late BuildContext context;

  @override
  ChallengingBehaviourDiaryEntryEditState build() =>
      ChallengingBehaviourDiaryEntryEditState(date: DateTime.now(), people: []);

  void init({
    required ChallengingBehaviourDiaryEntry entry,
    required bool isNew,
    required int cbId,
    required BuildContext context,
  }) {
    this.entry = entry;
    this.isNew = isNew;
    this.cbId = cbId;
    this.context = context;

    state = ChallengingBehaviourDiaryEntryEditState(
      date: entry.date,
      people: List.from(entry.people),
    );
  }

  void addPerson(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    final updated = List<String>.from(state.people)..add(text);
    state = state.copyWith(people: updated);
  }

  void removePerson(String person) {
    final updated = List<String>.from(state.people)..remove(person);
    state = state.copyWith(people: updated);
  }

  Future<void> pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: state.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.date),
    );
    if (pickedTime == null) return;

    final newDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    state = state.copyWith(date: newDate);
  }

  void saveChanges({
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required TextEditingController locationController,
    required TextEditingController durationController,
    required TextEditingController circumstancesController,
    required TextEditingController outcomeController,
    required TextEditingController reflectionController,
  }) {
    if (!(formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.entry_added), behavior: SnackBarBehavior.floating, showCloseIcon: true));

    final newEntry = ChallengingBehaviourDiaryEntry(
      id: entry.id,
      location: locationController.text.trim(),
      date: state.date,
      duration: int.parse(durationController.text),
      circumstances: circumstancesController.text.trim(),
      people: state.people,
      outcome: outcomeController.text.trim(),
      reflection: reflectionController.text.trim(),
    );

    ref
        .read(challengingBehavioursProvider.notifier)
        .addDiaryEntry(cbId, newEntry);
    router.pop();
    if (!isNew) router.pop();
  }
}

final challengingBehaviourDiaryEntryEditViewModelProvider =
    NotifierProvider<
      ChallengingBehaviourDiaryEntryEditViewModel,
      ChallengingBehaviourDiaryEntryEditState
    >(ChallengingBehaviourDiaryEntryEditViewModel.new);
