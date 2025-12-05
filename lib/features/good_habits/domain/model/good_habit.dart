import 'package:aut_toolkit/core/model/general_habit.dart';
import 'package:aut_toolkit/core/model/sync_entity.dart';

class GoodHabit extends GeneralHabit {
  bool isOcuringFlag;
  DateTime? to;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  GoodHabit({
    super.id = 0,
    required super.from,
    required super.userId,
    required super.name,
    required super.description,
    required this.isOcuringFlag,
    required super.selectedPersonId,
    required this.to,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE
  });
}
