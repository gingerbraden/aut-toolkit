import 'package:objectbox/objectbox.dart';

import '../../../../objectbox.g.dart';

@Entity()
class GoodHabitEntity {
  @Id()
  int id = 0;

  DateTime from;
  String userId;
  String name;
  String description;
  bool isOccuringFlag;
  String selectedPersonId;
  DateTime? to;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;

  GoodHabitEntity({
    this.id = 0,
    required this.from,
    required this.userId,
    required this.name,
    required this.description,
    required this.isOccuringFlag,
    required this.selectedPersonId,
    required this.to,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0
  });

}

extension GoodHabitBoxExtensions on Box<GoodHabitEntity> {
  GoodHabitEntity? getByRemoteId(String remoteId) {
    return query(GoodHabitEntity_.remoteId.equals(remoteId))
        .build()
        .findFirst();
  }
}