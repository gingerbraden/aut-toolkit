import 'package:aut_toolkit/core/model/sync_entity.dart';

class GeneralHabit {
  int? id;
  DateTime from;
  String userId;
  String name;
  String description;
  int selectedPersonId;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  GeneralHabit({
    this.id = 0,
    required this.from,
    required this.userId,
    required this.name,
    required this.description,
    required this.selectedPersonId,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE
  });
}
