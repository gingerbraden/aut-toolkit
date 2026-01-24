import 'package:aut_toolkit/core/model/sync_entity.dart';

import 'keyboard_slot_remote_entity.dart';

class AACKeyboardRemoteEntity extends SyncEntity {
  int localId;
  String userId;
  String name;
  List<KeyboardSlotRemoteEntity> slots;
  bool isInternal;
  bool isSelected;

  AACKeyboardRemoteEntity({
    required this.localId,
    required this.slots,
    required this.userId,
    required this.name,
    required super.updatedAt,
    required this.isInternal,
    required this.isSelected,
  });
}
