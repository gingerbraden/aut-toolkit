import 'package:aut_toolkit/features/aac_keyboard/data/model/aac_keyboard_entity.dart';

import 'package:objectbox/objectbox.dart';
import '../../../../objectbox.g.dart';
import '../../../card_management/data/model/user_card_entity.dart';

@Entity()
class KeyboardSlotEntity {
  @Id()
  int? id;
  int x;
  int y;
  late ToOne<UserCardEntity> card;
  late ToOne<AACKeyboardEntity> keyboard;

  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;

  KeyboardSlotEntity({
    this.id = 0,
    required this.x,
    required this.y,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
  });
}

extension KeyboardSlotBoxExtensions on Box<KeyboardSlotEntity> {
  KeyboardSlotEntity? getByRemoteId(String remoteId) {
    return query(
      KeyboardSlotEntity_.remoteId.equals(remoteId),
    ).build().findFirst();
  }
}
