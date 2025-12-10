import 'package:objectbox/objectbox.dart';


@Entity()
class EatingHabitEntity {

  @Id()
  int id = 0;

  DateTime from;
  DateTime? to;
  bool isEatingFlag;
  String name;
  String description;
  String userId;
  int selectedPersonId;
  String? imageFilePath;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;
  String? remoteImgPath;

  EatingHabitEntity({
    this.id = 0,
    required this.from,
    required this.to,
    required this.isEatingFlag,
    required this.name,
    required this.description,
    required this.userId,
    required this.selectedPersonId,
    required this.imageFilePath,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
    required this.remoteImgPath
  });

}
