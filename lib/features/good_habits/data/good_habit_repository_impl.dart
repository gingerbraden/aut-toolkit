import 'package:aut_toolkit/features/good_habits/data/model/good_habit_mappers.dart';
import 'package:aut_toolkit/features/good_habits/data/source/good_habit_local_source.dart';
import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';

import '../domain/repository/good_habit_repository.dart';

class GoodHabitRepositoryImpl implements GoodHabitRepository {
  final GoodHabitLocalSource _localSource;

  GoodHabitRepositoryImpl(this._localSource);

  @override
  List<GoodHabit> getAllHabits() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void saveHabit(GoodHabit goodHabit) {
    _localSource.put(goodHabit.toEntity());
  }

  @override
  void deleteHabit(GoodHabit goodHabit) {
    _localSource.remove(goodHabit.id!);
  }

}
