import '../../../../objectbox.g.dart';
import '../model/aac_keyboard_entity.dart';
import '../model/keyboard_slot_entity.dart';

class AACKeyboardLocalSource {
  final Box<AACKeyboardEntity> keyboardBox;
  final Box<KeyboardSlotEntity> slotBox;

  AACKeyboardLocalSource(this.keyboardBox, this.slotBox);

  Stream<List<AACKeyboardEntity>> watchAllKeyboards() {
    final builder = keyboardBox.query();

    return builder.watch(triggerImmediately: true).map((query) {
      final result = query.find();
      return result;
    });
  }

  int putKeyboard(AACKeyboardEntity keyboard) {
    return keyboardBox.put(keyboard);
  }

  List<AACKeyboardEntity> getAllKeyboards() {
    return keyboardBox.getAll();
  }

  AACKeyboardEntity? getById(int id) {
    return keyboardBox.get(id);
  }

  AACKeyboardEntity? getByRemoteId(String remoteId) {
    return keyboardBox.getByRemoteId(remoteId);
  }

  List<AACKeyboardEntity> getAllPending() {
    final q = keyboardBox
        .query(AACKeyboardEntity_.pendingAction.notEquals(0))
        .build();

    final result = q.find();
    q.close();
    return result;
  }

  void deleteKeyboard(int id, {bool cascade = true}) {
    if (cascade) {
      final q = slotBox.query(KeyboardSlotEntity_.parent.equals(id)).build();
      final slots = q.find();
      q.close();

      for (final s in slots) {
        if (s.id != null) slotBox.remove(s.id!);
      }
    }
    keyboardBox.remove(id);
  }

  int addSlot({
    required int parentKeyboardId,
    required KeyboardSlotEntity slot,
  }) {
    slot.parent.targetId = parentKeyboardId;

    final rid = slot.remoteId;
    if (rid == null || rid.isEmpty) {
      throw StateError('Slot.remoteId must be set before saving.');
    }

    final existing = slotBox
        .query(
          KeyboardSlotEntity_.remoteId.equals(rid) &
              KeyboardSlotEntity_.parent.equals(parentKeyboardId),
        )
        .build()
        .findFirst();

    if (existing != null) {
      slot.id = existing.id;
    }

    return slotBox.put(slot);
  }

  int updateSlot(KeyboardSlotEntity slot, {int? parentKeyboardId}) {
    if (slot.id == null) throw Exception('Slot must have an id');
    if (parentKeyboardId != null) {
      slot.parent.targetId = parentKeyboardId;
    }
    return slotBox.put(slot);
  }

  void deleteSlot(int slotId) {
    slotBox.remove(slotId);
  }

  List<KeyboardSlotEntity> getSlots({int? keyboardId}) {
    if (keyboardId == null) return slotBox.getAll();

    final q = slotBox
        .query(KeyboardSlotEntity_.parent.equals(keyboardId))
        .build();

    final result = q.find();
    q.close();
    return result;
  }

  KeyboardSlotEntity? getSlotByRemoteId(String remoteId) {
    return slotBox.getByRemoteId(remoteId);
  }

  List<KeyboardSlotEntity> getAllPendingSlots() {
    final q = slotBox
        .query(KeyboardSlotEntity_.pendingAction.notEquals(0))
        .build();

    final result = q.find();
    q.close();
    return result;
  }
}
