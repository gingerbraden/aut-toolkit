import 'dart:async';

import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../core/services/sync_manager.dart';
import '../../../main.dart';
import '../data/model/selected_person_entity.dart';
import '../data/source/selected_person_local_source.dart';
import '../data/source/selected_person_remote_source.dart';
import '../domain/model/selected_person.dart';
import '../domain/repository/selected_person_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final selectedPersonBoxProvider = Provider<Box<SelectedPersonEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.selectedPersonBox;
});

final selectedPersonRemoteSourceProvider = Provider<SelectedPersonRemoteSource>(
  (ref) {
    return SelectedPersonRemoteSource();
  },
);

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  ref.onDispose(() => sm.dispose());
  return sm;
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
  return RepoService().selectedPersonRepositoryImpl;
});

final selectedPersonsProvider =
    StateNotifierProvider<SelectedPersonsNotifier, List<SelectedPerson>>((ref) {
      final repo = ref.watch(selectedPersonRepositoryProvider);
      return SelectedPersonsNotifier(repo);
    });

final selectedPersonProvider = Provider<SelectedPerson?>((ref) {
  final persons = ref.watch(selectedPersonsProvider);
  return persons.where((p) => p.isSelected).firstOrNull;
});

class SelectedPersonsNotifier extends StateNotifier<List<SelectedPerson>> {
  final SelectedPersonRepository _repo;
  late final StreamSubscription _sub;

  SelectedPersonsNotifier(this._repo) : super([]) {
    _sub = _repo.watchAll().listen((data) {
      state = data;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void add(SelectedPerson person) {
    _repo.save(person);
  }

  void delete(SelectedPerson person) {
    _repo.delete(person);
  }
}
