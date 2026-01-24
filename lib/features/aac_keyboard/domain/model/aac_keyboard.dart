import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';

import '../../../../core/model/sync_entity.dart';

class AACKeyboard {
  int? id;
  String userId;
  String name;
  List<KeyboardSlot> slots;
  bool isInternal;
  bool isSelected;

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
    required this.isInternal,
    required this.isSelected,
  });

  AACKeyboard copyWith({List<KeyboardSlot>? slots}) {
    return AACKeyboard(
      id: id,
      userId: userId,
      name: name,
      slots: slots ?? List<KeyboardSlot>.from(this.slots),
      remoteId: remoteId,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
      pendingAction: pendingAction,
      isInternal: isInternal,
      isSelected: isSelected,
    );
  }
}
