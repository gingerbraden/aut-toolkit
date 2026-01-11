import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../objectbox.g.dart';

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
  String selectedPersonId;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;

  ChallengingBehaviourEntity({
    this.id = 0,
    required this.name,
    required this.from,
    required this.generalDescription,
    required this.diaryEntries,
    required this.occuring,
    required this.userId,
    required this.selectedPersonId,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0
  });
}

extension ChallengingBehaviourBoxExtensions on Box<ChallengingBehaviourEntity> {
  ChallengingBehaviourEntity? getByRemoteId(String remoteId) {
    return query(ChallengingBehaviourEntity_.remoteId.equals(remoteId))
        .build()
        .findFirst();
  }
}
