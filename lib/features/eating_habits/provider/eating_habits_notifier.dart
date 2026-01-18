import 'dart:async';

import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../core/services/sync_manager.dart';
import '../../../main.dart';
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

final eatingHabitRemoteSourceProvider = Provider<EatingHabitRemoteSource>((
  ref,
) {
  return EatingHabitRemoteSource();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final eatingHabitLocalSourceProvider = Provider<EatingHabitLocalSource>((ref) {
  final box = ref.watch(eatingHabitBoxProvider);
  return EatingHabitLocalSource(box);
});

final eatingHabitRepositoryProvider = Provider<EatingHabitRepository>((ref) {
  return RepoService().eatingHabitRepository;
});

final eatingHabitsProvider =
    StateNotifierProvider<EatingHabitsNotifier, List<EatingHabit>>((ref) {
      final repo = ref.watch(eatingHabitRepositoryProvider);
      return EatingHabitsNotifier(repo);
    });

class EatingHabitsNotifier extends StateNotifier<List<EatingHabit>> {
  final EatingHabitRepository _repo;
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  EatingHabitsNotifier(this._repo) : super([]) {
    _sub = _repo.watchAll().listen((data) {
      state = data;
    });
  }

  void loadHabits() {
    state = _repo.getAllHabits();
  }

  void addHabit(EatingHabit habit) {
    _repo.saveHabit(habit);
  }

  void deleteHabit(EatingHabit habit) {
    _repo.deleteHabit(habit);
  }
}
