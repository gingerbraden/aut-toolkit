import 'package:aut_toolkit/features/visual_supports/visual_lists/data/model/visual_list_entity.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/visual_list_repository_impl.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/model/visual_list.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/services/objectbox.dart';
import '../../../../main.dart';
import '../domain/repository/visual_list_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final visualListBoxProvider = Provider<Box<VisualListEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.visualListBox;
});

final visualListLocalSourceProvider = Provider<VisualListLocalSource>((ref) {
  final box = ref.watch(visualListBoxProvider);
  return VisualListLocalSource(box);
});

final visualListRepositoryProvider = Provider<VisualListRepository>((ref) {
  final localSource = ref.watch(visualListLocalSourceProvider);
  return VisualListRepositoryImpl(localSource);
});

final visualSchedulesProvider =
    StateNotifierProvider.family<
      VisualSchedulesNotifier,
      List<VisualList>,
      String
    >((ref, userId) {
      final repo = ref.watch(visualListRepositoryProvider);
      return VisualSchedulesNotifier(repo, userId);
    });

class VisualSchedulesNotifier extends StateNotifier<List<VisualList>> {
  final VisualListRepository _repo;
  final String _userId;

  VisualSchedulesNotifier(this._repo, this._userId) : super([]) {
    loadSchedules();
  }

  void loadSchedules() {
    state = _repo.getAllVisualSchedulesForUserId(_userId);
  }

  void addSchedule(VisualList schedule) {
    _repo.save(schedule);
    loadSchedules();
  }

  void deleteSchedule(VisualList schedule) {
    _repo.delete(schedule);
    loadSchedules();
  }
}

final visualDiagramsProvider =
    StateNotifierProvider.family<
      VisualDiagramsNotifier,
      List<VisualList>,
      String
    >((ref, userId) {
      final repo = ref.watch(visualListRepositoryProvider);
      return VisualDiagramsNotifier(repo, userId);
    });

class VisualDiagramsNotifier extends StateNotifier<List<VisualList>> {
  final VisualListRepository _repo;
  final String _userId;

  VisualDiagramsNotifier(this._repo, this._userId) : super([]) {
    loadDiagrams();
  }

  void loadDiagrams() {
    state = _repo.getAllVisualDiagramsForUserId(_userId);
  }

  void addDiagram(VisualList diagram) {
    _repo.save(diagram);
    loadDiagrams();
  }

  void deleteDiagram(VisualList diagram) {
    _repo.delete(diagram);
    loadDiagrams();
  }
}
