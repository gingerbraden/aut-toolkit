import 'package:aut_toolkit/features/aac_keyboard/data/model/aac_keyboard_entity.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/model/keyboard_slot_entity.dart';
import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:aut_toolkit/features/good_habits/data/model/good_habit_entity.dart';
import 'package:aut_toolkit/features/selected_person/data/model/selected_person_entity.dart';
import 'package:aut_toolkit/features/visual_supports/first_then_board/data/model/first_then_board_entity.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/model/visual_list_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;

  late final Box<EatingHabitEntity> eatingHabitEntityBox;
  late final Box<ChallengingBehaviourEntity> challengingBehaviourBox;
  late final Box<ChallengingBehaviourDiaryEntryEntity> challengingBehaviourDiaryEntryBox;
  late final Box<GoodHabitEntity> goodHabitBox;
  late final Box<SelectedPersonEntity> selectedPersonBox;
  late final Box<UserCardEntity> cardBox;
  late final Box<FirstThenBoardEntity> firstThenBoardBox;
  late final Box<VisualListEntity> visualListBox;
  late final Box<KeyboardSlotEntity> keyboardSlotBox;
  late final Box<AACKeyboardEntity> aacKeyboardBox;

  ObjectBox._create(this.store) {
    eatingHabitEntityBox = Box<EatingHabitEntity>(store);
    challengingBehaviourBox = Box<ChallengingBehaviourEntity>(store);
    challengingBehaviourDiaryEntryBox = Box<ChallengingBehaviourDiaryEntryEntity>(store);
    goodHabitBox = Box<GoodHabitEntity>(store);
    selectedPersonBox = Box<SelectedPersonEntity>(store);
    cardBox = Box<UserCardEntity>(store);
    firstThenBoardBox = Box<FirstThenBoardEntity>(store);
    visualListBox = Box<VisualListEntity>(store);
    keyboardSlotBox = Box<KeyboardSlotEntity>(store);
    aacKeyboardBox = Box<AACKeyboardEntity>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${docsDir.path}/objectbox');
    return ObjectBox._create(store);
  }
}
