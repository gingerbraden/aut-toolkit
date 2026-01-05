import '../../../../../core/model/sync_entity.dart';
import '../../../../card_management/domain/model/user_card.dart';

class VisualList {
  int? id;
  String userId;
  List<UserCard> steps;
  String name;
  bool isVisualSchedule;
  bool isVisualDiagram;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  VisualList({
    this.id = 0,
    required this.userId,
    required this.steps,
    required this.name,
    required this.isVisualSchedule,
    required this.isVisualDiagram,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE,
  });
}
