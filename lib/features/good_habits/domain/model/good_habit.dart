import 'package:aut_toolkit/core/model/general_habit.dart';

class GoodHabit extends GeneralHabit {
  bool isOcuringFlag;
  DateTime? to;

  GoodHabit({
    super.id = 0,
    required super.from,
    required super.userId,
    required super.name,
    required super.description,
    required this.isOcuringFlag,
    required super.selectedPersonId,
    required this.to,
    required super.updatedAt,
    required super.remoteId,
    super.pendingAction,
    super.isDeleted,
    super.isSynced,
  });
}
