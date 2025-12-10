import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../core/services/sync_manager.dart';
import '../../../main.dart';
import '../../eating_habits/data/eating_habit_repository_impl.dart';
import '../../eating_habits/data/model/eating_habit_entity.dart';
import '../../eating_habits/data/source/eating_habit_local_source.dart';
import '../../eating_habits/data/source/eating_habit_remote_source.dart';
import '../../eating_habits/domain/model/eating_habit.dart';
import '../../eating_habits/domain/repository/eating_habit_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final eatingHabitBoxProvider = Provider<Box<EatingHabitEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.eatingHabitEntityBox;
});

final eatingHabitRemoteSourceProvider = Provider<EatingHabitRemoteSource>((ref) {
  return EatingHabitRemoteSource();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  sm.start();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final eatingHabitLocalSourceProvider = Provider<EatingHabitLocalSource>((ref) {
  final box = ref.watch(eatingHabitBoxProvider);
  return EatingHabitLocalSource(box);
});

final eatingHabitRepositoryProvider = Provider<EatingHabitRepository>((ref) {
  final local = ref.watch(eatingHabitLocalSourceProvider);
  final remote = ref.watch(eatingHabitRemoteSourceProvider);
  final sync = ref.watch(syncManagerProvider);
  return EatingHabitRepositoryImpl(local, remote, sync);
});

final eatingHabitsProvider =
StateNotifierProvider<EatingHabitsNotifier, List<EatingHabit>>((ref) {
  final repo = ref.watch(eatingHabitRepositoryProvider);
  return EatingHabitsNotifier(repo);
});

class EatingHabitsNotifier extends StateNotifier<List<EatingHabit>> {
  final EatingHabitRepository _repo;

  EatingHabitsNotifier(this._repo) : super([]) {
    loadHabits();
  }

  void loadHabits() {
    state = _repo.getAllHabits();
  }

  void addHabit(EatingHabit habit) {
    _repo.saveHabit(habit);
    loadHabits();
  }

  void deleteHabit(EatingHabit habit) {
    _repo.deleteHabit(habit);
    loadHabits();
  }
}
