import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;

  late final Box<EatingHabitEntity> eatingHabitEntityBox;

  ObjectBox._create(this.store) {
    eatingHabitEntityBox = Box<EatingHabitEntity>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${docsDir.path}/objectbox');
    return ObjectBox._create(store);
  }
}
