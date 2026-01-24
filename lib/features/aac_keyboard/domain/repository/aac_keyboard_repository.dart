import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';

abstract class AACKeyboardRepository {
  List<AACKeyboard> getAllKeyboards();

  void deleteKeyboard(AACKeyboard keyboard);

  int saveKeyboard(AACKeyboard keyboard);

  List<KeyboardSlot> getAllSlots(AACKeyboard keyboard);

  void deleteSlot(KeyboardSlot slot, int parentKeyboardId);

  void saveSlot(KeyboardSlot slot, int parentKeyboardId);

  Stream<List<AACKeyboard>> watchAll();
}
