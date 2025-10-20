import 'package:aut_toolkit/features/eating_habits/data/model/eating_habit_mappers.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_local_source.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/domain/repository/eating_habit_repository.dart';

class EatingHabitRepositoryImpl implements EatingHabitRepository {
  final EatingHabitLocalSource _localSource;

  EatingHabitRepositoryImpl(this._localSource);

  @override
  List<EatingHabit> getAllHabits() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveHabit(EatingHabit eatingHabit) {
    _localSource.put(eatingHabit.toEntity());
  }

  @override
  void deleteHabit(EatingHabit eatingHabit) {
    _localSource.remove(eatingHabit.id!);
  }
}
