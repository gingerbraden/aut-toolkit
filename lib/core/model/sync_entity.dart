enum PendingAction {
  NONE,
  CREATE,
  UPDATE,
  DELETE,
}

class SyncEntity {
  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  SyncEntity({
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.pendingAction = PendingAction.NONE,
    this.isDeleted = false
  });
}