import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';

import '../../../../../core/model/sync_entity.dart';

class FirstThenBoard {
  int? id;
  String userId;
  UserCard first;
  UserCard then;
  String name;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  FirstThenBoard({
    this.id = 0,
    required this.userId,
    required this.first,
    required this.then,
    required this.name,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE,
  });
}
