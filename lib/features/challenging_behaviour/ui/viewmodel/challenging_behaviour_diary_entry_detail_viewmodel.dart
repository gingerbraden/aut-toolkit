import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengingBehaviourDiaryEntryDetailViewModelProvider =
    NotifierProvider<ChallengingBehaviourDiaryEntryDetailViewModel, void>(
      ChallengingBehaviourDiaryEntryDetailViewModel.new,
    );

class ChallengingBehaviourDiaryEntryDetailViewModel extends Notifier<void> {
  @override
  void build() {}

  void deleteEntry({
    required WidgetRef ref,
    required ChallengingBehaviourDiaryEntry entry,
  }) {
    ref.read(challengingBehavioursProvider.notifier).deleteDiaryEntry(entry);
  }
}
