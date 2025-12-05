import 'package:aut_toolkit/core/model/sync_entity.dart';

class GoodHabitRemoteEntity extends SyncEntity {
  int localId;
  DateTime from;
  String userId;
  String name;
  String description;
  bool isOccuringFlag;
  int selectedPersonId;
  DateTime? to;

  GoodHabitRemoteEntity({
    required this.localId,
    required this.from,
    required this.userId,
    required this.name,
    required this.description,
    required this.isOccuringFlag,
    required this.selectedPersonId,
    required this.to,
    required super.updatedAt
  });
}
