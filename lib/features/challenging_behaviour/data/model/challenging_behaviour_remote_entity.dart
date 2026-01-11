import '../../../../core/model/sync_entity.dart';
import 'challenging_behaviour_diary_entry_remote_entity.dart';

class ChallengingBehaviourRemoteEntity extends SyncEntity {
  int localId;

  String name;

  DateTime from;

  String generalDescription;

  List<ChallengingBehaviourDiaryEntryRemoteEntity> diaryEntries;

  bool occuring;

  String userId;

  String selectedPersonId;

  ChallengingBehaviourRemoteEntity({
    required this.localId,
    required this.name,
    required this.from,
    required this.generalDescription,
    required this.diaryEntries,
    required this.occuring,
    required this.userId,
    required this.selectedPersonId,
    required super.updatedAt,
  });
}
