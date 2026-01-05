import 'package:objectbox/objectbox.dart';

@Entity()
class SelectedPersonEntity {
  @Id()
  int id = 0;
  bool isSelected;
  String userId;
  String name;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;

  SelectedPersonEntity({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.isSelected,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
    this.remoteId
  });

}
