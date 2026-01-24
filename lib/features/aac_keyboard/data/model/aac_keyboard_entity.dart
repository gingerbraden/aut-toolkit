import '../../../../objectbox.g.dart';
import 'keyboard_slot_entity.dart';

@Entity()
class AACKeyboardEntity {
  @Id()
  int? id;
  String userId;
  String name;
  @Backlink('parent')
  final slots = ToMany<KeyboardSlotEntity>();
  String? remoteId;
  DateTime updatedAt;
  bool isSynced;
  int pendingAction;
  bool isDeleted;
  bool isInternal;
  bool isSelected;

  AACKeyboardEntity({
    this.id = 0,
    required this.userId,
    required this.name,
    this.remoteId,
    required this.updatedAt,
    this.isSynced = true,
    this.isDeleted = false,
    this.pendingAction = 0,
    required this.isInternal,
    required this.isSelected,
  });
}

extension AACKeyboardBoxExtensions on Box<AACKeyboardEntity> {
  AACKeyboardEntity? getByRemoteId(String remoteId) {
    return query(
      AACKeyboardEntity_.remoteId.equals(remoteId),
    ).build().findFirst();
  }
}
