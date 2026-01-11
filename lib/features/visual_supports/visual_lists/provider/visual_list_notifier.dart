import 'dart:async';

import 'package:aut_toolkit/features/visual_supports/visual_lists/data/model/visual_list_entity.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_local_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/source/visual_list_remote_source.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/data/visual_list_repository_impl.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/model/visual_list.dart';
import 'package:aut_toolkit/features/visual_supports/visual_lists/domain/repository/visual_list_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/services/objectbox.dart';
import '../../../../core/services/sync_manager.dart';
import '../../../../main.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) => objectbox);

final visualListBoxProvider = Provider<Box<VisualListEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.visualListBox;
});

final visualListLocalSourceProvider = Provider<VisualListLocalSource>((ref) {
  final box = ref.watch(visualListBoxProvider);
  return VisualListLocalSource(box);
});

final visualListRemoteSourceProvider =
Provider<VisualListRemoteSource>((ref) {
  return VisualListRemoteSource();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  sm.start();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final visualListRepositoryProvider =
Provider<VisualListRepository>((ref) {
  final local = ref.watch(visualListLocalSourceProvider);
  final remote = ref.watch(visualListRemoteSourceProvider);
  final sync = ref.watch(syncManagerProvider);
  return VisualListRepositoryImpl(local, remote, sync);
});

final visualSchedulesProvider =
StateNotifierProvider.family<
    VisualSchedulesNotifier,
    List<VisualList>,
    String>((ref, userId) {
  final repo = ref.watch(visualListRepositoryProvider);
  return VisualSchedulesNotifier(repo, userId);
});

class VisualSchedulesNotifier extends StateNotifier<List<VisualList>> {
  final VisualListRepository _repo;
  final String _userId;
  late final StreamSubscription _listSub;
  late final StreamSubscription _cardSub;

  VisualSchedulesNotifier(this._repo, this._userId) : super([]) {
    _listSub = _repo.watchAll().listen((lists) {
      state = lists
          .where((l) =>
      l.userId == _userId && l.isVisualSchedule)
          .toList();
    });

    final cardBox = objectbox.cardBox;
    _cardSub = cardBox.query().watch(triggerImmediately: false).listen((_) {
      final currentBoards = _repo.getAllVisualSchedulesForUserId(_userId);
      state = currentBoards;
    });
  }

  @override
  void dispose() {
    _listSub.cancel();
    _cardSub.cancel();
    super.dispose();
  }

  void addSchedule(VisualList schedule) {
    _repo.save(schedule);
  }

  void deleteSchedule(VisualList schedule) {
    _repo.delete(schedule);
  }
}

final visualDiagramsProvider =
StateNotifierProvider.family<
    VisualDiagramsNotifier,
    List<VisualList>,
    String>((ref, userId) {
  final repo = ref.watch(visualListRepositoryProvider);
  return VisualDiagramsNotifier(repo, userId);
});

class VisualDiagramsNotifier extends StateNotifier<List<VisualList>> {
  final VisualListRepository _repo;
  final String _userId;
  late final StreamSubscription _listSub;
  late final StreamSubscription _cardSub;

  VisualDiagramsNotifier(this._repo, this._userId) : super([]) {
    _listSub = _repo.watchAll().listen((lists) {
      state = lists
          .where((l) =>
      l.userId == _userId && l.isVisualDiagram)
          .toList();
    });

    final cardBox = objectbox.cardBox;
    _cardSub = cardBox.query().watch(triggerImmediately: false).listen((_) {
      final currentBoards = _repo.getAllVisualDiagramsForUserId(_userId);
      state = currentBoards;
    });
  }

  @override
  void dispose() {
    _listSub.cancel();
    _cardSub.cancel();
    super.dispose();
  }

  void addDiagram(VisualList diagram) {
    _repo.save(diagram);
  }

  void deleteDiagram(VisualList diagram) {
    _repo.delete(diagram);
  }
}
