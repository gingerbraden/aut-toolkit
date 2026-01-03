import '../../../../core/model/sync_entity.dart';

class UserCard {
  int? id;
  int? arasaacId;
  String userId;
  String localImgPath;
  Map<String, String> names;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;
  String? remoteImgPath;

  UserCard({
    this.id = 0,
    this.arasaacId = 0,
    required this.userId,
    required this.localImgPath,
    required this.names,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE,
    required this.remoteImgPath,
  });
}
