import 'package:aut_toolkit/features/good_habits/data/model/good_habit_entity.dart';
import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';

extension UserEntityMapper on GoodHabitEntity {
  GoodHabit toModel() => GoodHabit(
    id: id,
    from: from,
    name: name,
    description: description,
    userId: userId,
    isOcuringFlag: isOccuringFlag,
    selectedPersonId: selectedPersonId,
  );
}

extension UserModelMapper on GoodHabit {
  GoodHabitEntity toEntity() => GoodHabitEntity(
    id: id ?? 0,
    from: from,
    name: name,
    description: description,
    userId: userId,
    isOccuringFlag: isOcuringFlag,
    selectedPersonId: selectedPersonId,
  );
}
