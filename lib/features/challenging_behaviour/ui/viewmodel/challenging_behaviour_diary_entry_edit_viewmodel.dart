import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengingBehaviourDiaryEntryEditViewModelProvider =
    NotifierProvider<
      ChallengingBehaviourDiaryEntryEditViewModel,
      ChallengingBehaviourDiaryEntryEditState
    >(ChallengingBehaviourDiaryEntryEditViewModel.new);

class ChallengingBehaviourDiaryEntryEditViewModel
    extends Notifier<ChallengingBehaviourDiaryEntryEditState> {
  late ChallengingBehaviourDiaryEntry entry;
  late bool isNew;
  late int cbId;

  @override
  ChallengingBehaviourDiaryEntryEditState build() =>
      ChallengingBehaviourDiaryEntryEditState(date: DateTime.now(), people: []);

  void init({
    required ChallengingBehaviourDiaryEntry entry,
    required bool isNew,
    required int cbId,
  }) {
    this.entry = entry;
    this.isNew = isNew;
    this.cbId = cbId;

    state = ChallengingBehaviourDiaryEntryEditState(
      date: entry.date,
      people: List.from(entry.people),
    );
  }

  void addPerson(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    state = state.copyWith(people: [...state.people, text]);
  }

  void removePerson(String person) {
    state = state.copyWith(
      people: state.people.where((p) => p != person).toList(),
    );
  }

  void updateDate(DateTime newDate) {
    state = state.copyWith(date: newDate);
  }

  void saveChanges({
    required WidgetRef ref,
    required ChallengingBehaviourDiaryEntry updatedEntry,
  }) {
    ref
        .read(challengingBehavioursProvider.notifier)
        .addDiaryEntry(cbId, updatedEntry);
  }
}

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
