import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';

import '../../../../core/model/sync_entity.dart';

class AACKeyboard {
  int? id;
  String userId;
  String name;
  List<KeyboardSlot> slots;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  AACKeyboard({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.slots,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE,
  });
}
