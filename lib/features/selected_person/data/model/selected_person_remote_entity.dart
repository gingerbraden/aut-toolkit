import '../../../../core/model/sync_entity.dart';

class SelectedPersonRemoteEntity extends SyncEntity {
  int localId;
  bool isSelected;
  String userId;
  String name;

  SelectedPersonRemoteEntity({
    this.localId = 0,
    required this.userId,
    required this.name,
    required this.isSelected,
    required super.updatedAt,
  });

}
