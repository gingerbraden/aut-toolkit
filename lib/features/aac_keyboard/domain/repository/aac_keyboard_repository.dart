import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';

abstract class AACKeyboardRepository {
  List<AACKeyboard> getAllKeyboards();

  void deleteKeyboard(AACKeyboard keyboard);

  void saveKeyboard(AACKeyboard keyboard);

  List<KeyboardSlot> getAllSlots(AACKeyboard keyboard);

  void deleteSlot(KeyboardSlot slot);

  void saveSlot(KeyboardSlot slot);

  Stream<List<AACKeyboard>> watchAll();
}
