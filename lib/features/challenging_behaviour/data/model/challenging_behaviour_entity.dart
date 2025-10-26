import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';

@Entity()
class ChallengingBehaviourEntity {
  @Id()
  int? id;

  // name of the behaviour
  String name;

  // when did the behaviour start occuring
  DateTime from;

  // general description of the behaviour
  String generalDescription;

  // diary entries
  @Backlink()
  ToMany<ChallengingBehaviourDiaryEntryEntity> diaryEntries;

  // still occuring?
  bool occuring;

  ChallengingBehaviourEntity({
    this.id = 0,
    required this.name,
    required this.from,
    required this.generalDescription,
    required this.diaryEntries,
    required this.occuring
  });
}
