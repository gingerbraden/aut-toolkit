import 'package:aut_toolkit/core/model/sync_entity.dart';

class EatingHabitRemoteEntity extends SyncEntity {
  int localId;
  DateTime from;
  DateTime? to;
  bool isEatingFlag;
  String name;
  String description;
  String userId;
  String selectedPersonId;
  String? imageFilePath;
  String? remoteImagePath;

  EatingHabitRemoteEntity({
    required this.localId,
    required this.from,
    required this.to,
    required this.isEatingFlag,
    required this.name,
    required this.description,
    required this.userId,
    required this.selectedPersonId,
    required this.imageFilePath,
    required this.remoteImagePath,
    required super.updatedAt
  });

}
