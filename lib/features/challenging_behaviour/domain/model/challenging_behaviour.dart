import 'package:aut_toolkit/core/model/general_habit.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';

import '../../../../core/model/sync_entity.dart';

class ChallengingBehaviour extends GeneralHabit {
  List<ChallengingBehaviourDiaryEntry> diaryEntries;
  bool occuring;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  ChallengingBehaviour({
    super.id = 0,
    required super.name,
    required super.from,
    required super.description,
    required this.diaryEntries,
    required this.occuring,
    required super.userId,
    required super.selectedPersonId,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE
  });
}
