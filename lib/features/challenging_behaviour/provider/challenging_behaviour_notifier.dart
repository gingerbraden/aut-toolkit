import 'package:aut_toolkit/features/challenging_behaviour/data/challenging_behaviour_repository_impl.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/repository/challenging_behaviour_repository.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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

final challengingBehaviourLocalSourceProvider =
Provider<ChallengingBehaviourLocalSource>((ref) {
  final behaviourBox = ref.watch(challengingBehaviourBoxProvider);
  final diaryBox = ref.watch(challengingBehaviourDiaryEntryBoxProvider);
  return ChallengingBehaviourLocalSource(behaviourBox, diaryBox);
});

final challengingBehaviourRepositoryProvider =
Provider<ChallengingBehaviourRepository>((ref) {
  final localSource = ref.watch(challengingBehaviourLocalSourceProvider);
  return ChallengingBehaviourRepositoryImpl(localSource);
});

final challengingBehavioursProvider =
StateNotifierProvider<ChallengingBehavioursNotifier,
    List<ChallengingBehaviour>>((ref) {
  final repo = ref.watch(challengingBehaviourRepositoryProvider);
  return ChallengingBehavioursNotifier(repo);
});

class ChallengingBehavioursNotifier
    extends StateNotifier<List<ChallengingBehaviour>> {
  final ChallengingBehaviourRepository _repo;

  ChallengingBehavioursNotifier(this._repo) : super([]) {
    loadBehaviours();
  }

  void loadBehaviours() {
    state = _repo.getAllCb();
  }

  void addBehaviour(ChallengingBehaviour cb) {
    _repo.saveCb(cb);
    loadBehaviours();
  }

  void deleteBehaviour(ChallengingBehaviour cb) {
    _repo.deleteCb(cb);
    loadBehaviours();
  }

  void addDiaryEntry(int cbId, ChallengingBehaviourDiaryEntry entry) {
    _repo.addDe(cbId, entry);
    loadBehaviours();
  }

  void deleteDiaryEntry(ChallengingBehaviourDiaryEntry entry) {
    _repo.deleteDe(entry);
    loadBehaviours();
  }

  List<ChallengingBehaviourDiaryEntry> getDiaryEntries(int cbId) {
    return _repo.getAllDe(cbId);
  }
}
