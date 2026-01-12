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
      final keyboard = keyboardBox.get(id);
      if (keyboard != null) {
        for (final slot in keyboard.slots) {
          slotBox.remove(slot.id!);
        }
      }
    }
    keyboardBox.remove(id);
  }

  int addSlot(KeyboardSlotEntity slot) {
    final keyboard = keyboardBox.get(slot.keyboard.targetId);
    if (keyboard == null) {
      throw Exception('Keyboard not found');
    }

    slot.keyboard.target = keyboard;

    final slotId = slotBox.put(slot);

    keyboard.slots.add(slot);
    keyboardBox.put(keyboard);

    return slotId;
  }

  int updateSlot(KeyboardSlotEntity slot) {
    if (slot.id == null) {
      throw Exception('Slot must have an id');
    }
    return slotBox.put(slot);
  }

  void deleteSlot(int slotId) {
    slotBox.remove(slotId);
  }

  List<KeyboardSlotEntity> getSlots({int? keyboardId}) {
    if (keyboardId == null) {
      return slotBox.getAll();
    }

    final keyboard = keyboardBox.get(keyboardId);
    return keyboard?.slots.toList() ?? [];
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
