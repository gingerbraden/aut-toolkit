import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../core/services/sync_manager.dart';
import '../../../main.dart';
import '../data/good_habit_repository_impl.dart';
import '../data/model/good_habit_entity.dart';
import '../data/source/good_habit_local_source.dart';
import '../data/source/good_habit_remote_source.dart';
import '../domain/repository/good_habit_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final goodHabitBoxProvider = Provider<Box<GoodHabitEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.goodHabitBox;
});

final goodHabitRemoteSourceProvider = Provider<GoodHabitRemoteSource>((ref) {
  return GoodHabitRemoteSource();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  sm.start();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final goodHabitLocalSourceProvider = Provider<GoodHabitLocalSource>((ref) {
  final box = ref.watch(goodHabitBoxProvider);
  return GoodHabitLocalSource(box);
});

final goodHabitRepositoryProvider = Provider<GoodHabitRepository>((ref) {
  final localSource = ref.watch(goodHabitLocalSourceProvider);
  final remote = ref.watch(goodHabitRemoteSourceProvider);
  final sync = ref.watch(syncManagerProvider);
  return GoodHabitRepositoryImpl(localSource, remote, sync);
});

final goodHabitsProvider =
    StateNotifierProvider<GoodHabitsNotifier, List<GoodHabit>>((ref) {
      final repo = ref.watch(goodHabitRepositoryProvider);
      return GoodHabitsNotifier(repo);
    });

class GoodHabitsNotifier extends StateNotifier<List<GoodHabit>> {
  final GoodHabitRepository _repo;

  GoodHabitsNotifier(this._repo) : super([]) {
    loadHabits();
  }

  void loadHabits() {
    state = _repo.getAllHabits();
  }

  void addHabit(GoodHabit habit) {
    _repo.saveHabit(habit);
    loadHabits();
  }

  void deleteHabit(GoodHabit habit) {
    _repo.deleteHabit(habit);
    loadHabits();
  }
}
