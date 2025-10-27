import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';

class ChallengingBehaviour {
  int? id;

  // name of the behaviour
  String name;

  // when did the behaviour start occuring
  DateTime from;

  // general description of the behaviour
  String generalDescription;

  // diary entries
  List<ChallengingBehaviourDiaryEntry> diaryEntries;

  // still occuring?
  bool occuring;

  String userId;

  ChallengingBehaviour({
    this.id = 0,
    required this.name,
    required this.from,
    required this.generalDescription,
    required this.diaryEntries,
    required this.occuring,
    required this.userId
  });
}
