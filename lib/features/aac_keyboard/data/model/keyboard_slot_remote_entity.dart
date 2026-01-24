import '../../../../core/model/sync_entity.dart';

class KeyboardSlotRemoteEntity extends SyncEntity {
  int? id;
  int x;
  int y;
  String? card;
  String? keyboard;

  KeyboardSlotRemoteEntity({
    this.id = 0,
    required this.keyboard,
    required this.card,
    required this.x,
    required this.y,
    required super.updatedAt,
    required super.remoteId
  });
}
