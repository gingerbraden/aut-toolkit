import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';

import '../../../../core/model/sync_entity.dart';

class KeyboardSlot {
  int? id;
  int x;
  int y;
  UserCard? card;
  AACKeyboard? keyboard;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  PendingAction pendingAction;
  bool isDeleted;

  KeyboardSlot({
    this.id = 0,
    this.card,
    this.keyboard,
    required this.x,
    required this.y,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = PendingAction.NONE,
  });
}
