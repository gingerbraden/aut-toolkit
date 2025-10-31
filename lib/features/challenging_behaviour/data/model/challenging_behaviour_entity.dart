import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ChallengingBehaviourEntity {
  @Id()
  int? id;

  String name;

  DateTime from;

  String generalDescription;

  @Backlink()
  ToMany<ChallengingBehaviourDiaryEntryEntity> diaryEntries;

  bool occuring;

  String userId;

  int selectedPersonId;

  ChallengingBehaviourEntity({
    this.id = 0,
    required this.name,
    required this.from,
    required this.generalDescription,
    required this.diaryEntries,
    required this.occuring,
    required this.userId,
    required this.selectedPersonId
  });
}
