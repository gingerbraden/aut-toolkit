import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_entity.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';

extension UserEntityMapper on EatingHabitEntity {
  EatingHabit toModel() => EatingHabit(
    id: id,
    from: from,
    to: to,
    isEatingFlag: isEatingFlag,
    name: name,
    description: description,
    userId: userId,
  );
}

extension UserModelMapper on EatingHabit {
  EatingHabitEntity toEntity() => EatingHabitEntity(
    id: id ?? 0,
    from: from,
    to: to,
    isEatingFlag: isEatingFlag,
    name: name,
    description: description,
    userId: userId,
  );
}
