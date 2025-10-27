import '../../domain/model/challenging_behaviour_diary_entry.dart';

class ChallengingBehaviourDiaryEntryTransport {
  final int cbId;
  final ChallengingBehaviourDiaryEntry entry;
  final bool isNew;

  ChallengingBehaviourDiaryEntryTransport({
    required this.cbId,
    required this.entry,
    required this.isNew,
  });
}