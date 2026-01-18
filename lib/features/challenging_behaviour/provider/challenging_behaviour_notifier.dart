import 'dart:async';

import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_remote_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/repository/challenging_behaviour_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/sync_manager.dart';
import '../../eating_habits/provider/eating_habits_notifier.dart';
import '../data/model/challenging_behaviour_diary_entry_entity.dart';
import '../data/model/challenging_behaviour_entity.dart';

final challengingBehaviourBoxProvider =
    Provider<Box<ChallengingBehaviourEntity>>((ref) {
      final obx = ref.watch(objectBoxProvider);
      return obx.challengingBehaviourBox;
    });

final challengingBehaviourDiaryEntryBoxProvider =
    Provider<Box<ChallengingBehaviourDiaryEntryEntity>>((ref) {
      final obx = ref.watch(objectBoxProvider);
      return obx.challengingBehaviourDiaryEntryBox;
    });

final challengingBehaviourRemoteSourceProvider =
    Provider<ChallengingBehaviourRemoteSource>((ref) {
      return ChallengingBehaviourRemoteSource();
    });

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final challengingBehaviourLocalSourceProvider =
    Provider<ChallengingBehaviourLocalSource>((ref) {
      final behaviourBox = ref.watch(challengingBehaviourBoxProvider);
      final diaryBox = ref.watch(challengingBehaviourDiaryEntryBoxProvider);
      return ChallengingBehaviourLocalSource(behaviourBox, diaryBox);
    });

final challengingBehaviourRepositoryProvider =
    Provider<ChallengingBehaviourRepository>((ref) {
      return RepoService().challengingBehaviourRepository;
    });

final challengingBehavioursProvider =
    StateNotifierProvider<
      ChallengingBehavioursNotifier,
      List<ChallengingBehaviour>
    >((ref) {
      final repo = ref.watch(challengingBehaviourRepositoryProvider);
      return ChallengingBehavioursNotifier(repo);
    });

class ChallengingBehavioursNotifier
    extends StateNotifier<List<ChallengingBehaviour>> {
  final ChallengingBehaviourRepository _repo;
  late final StreamSubscription _sub;

  ChallengingBehavioursNotifier(this._repo) : super([]) {
    _sub = _repo.watchAll().listen((data) {
      state = data;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void addBehaviour(ChallengingBehaviour cb) {
    _repo.saveCb(cb);
  }

  void deleteBehaviour(ChallengingBehaviour cb) {
    _repo.deleteCb(cb);
  }

  void addDiaryEntry(int cbId, ChallengingBehaviourDiaryEntry entry) {
    _repo.addDe(cbId, entry);
  }

  void deleteDiaryEntry(ChallengingBehaviourDiaryEntry entry) {
    _repo.deleteDe(entry);
  }
}
