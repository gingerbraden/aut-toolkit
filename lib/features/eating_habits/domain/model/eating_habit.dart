import 'package:aut_toolkit/core/model/general_habit.dart';

class EatingHabit extends GeneralHabit {
  DateTime? to;
  bool isEatingFlag;
  String? imageFilePath;
  String? remoteImgPath;

  EatingHabit({
    super.id,
    required super.from,
    required super.userId,
    required this.to,
    required this.isEatingFlag,
    required super.name,
    required super.description,
    required super.selectedPersonId,
    required this.imageFilePath,
    required super.updatedAt,
    required super.remoteId,
    super.pendingAction,
    super.isDeleted,
    super.isSynced,
    this.remoteImgPath
  });


}
