import '../../../../core/model/sync_entity.dart';

class SelectedPerson {

  int? id;
  bool isSelected;
  String userId;
  String name;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  SelectedPerson({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.isSelected,
    required this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE
  });

}
