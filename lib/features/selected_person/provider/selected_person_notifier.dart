import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/features/eating_habits/provider/eating_habits_notifier.dart';
import 'package:aut_toolkit/features/good_habits/provider/good_habits_notifier.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../main.dart';
import '../data/model/selected_person_entity.dart';
import '../data/selected_person_repository_impl.dart';
import '../data/source/selected_person_local_source.dart';
import '../domain/model/selected_person.dart';
import '../domain/repository/selected_person_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final selectedPersonBoxProvider = Provider<Box<SelectedPersonEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.selectedPersonBox;
});

final selectedPersonLocalSourceProvider = Provider<SelectedPersonLocalSource>((
  ref,
) {
  final box = ref.watch(selectedPersonBoxProvider);
  return SelectedPersonLocalSource(box);
});

final selectedPersonRepositoryProvider = Provider<SelectedPersonRepository>((
  ref,
) {
  final localSource = ref.watch(selectedPersonLocalSourceProvider);
  final cbls = ref.watch(challengingBehaviourLocalSourceProvider);
  final ehls = ref.watch(eatingHabitLocalSourceProvider);
  final ghls = ref.watch(goodHabitLocalSourceProvider);
  return SelectedPersonRepositoryImpl(localSource, cbls, ehls, ghls);
});

final selectedPersonsProvider =
    StateNotifierProvider<SelectedPersonsNotifier, List<SelectedPerson>>((ref) {
      final repo = ref.watch(selectedPersonRepositoryProvider);
      return SelectedPersonsNotifier(repo);
    });

class SelectedPersonsNotifier extends StateNotifier<List<SelectedPerson>> {
  final SelectedPersonRepository _repo;

  SelectedPersonsNotifier(this._repo) : super([]) {
    load();
  }

  void load() {
    state = _repo.getAll();
  }

  void add(SelectedPerson person) {
    _repo.save(person);
    load();
  }

  void delete(SelectedPerson person) {
    _repo.delete(person);
    load();
  }

  SelectedPerson getSelected() {
    return _repo.getAll().firstWhere((sp) => sp.isSelected);
  }

}
