import 'package:objectbox/objectbox.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_entity.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_entity.dart';

import '../../../../objectbox.g.dart';

class ChallengingBehaviourLocalSource {
  final Box<ChallengingBehaviourEntity> challengingBehaviourBox;
  final Box<ChallengingBehaviourDiaryEntryEntity> challengingBehaviourDiaryEntryBox;

  ChallengingBehaviourLocalSource(
      this.challengingBehaviourBox,
      this.challengingBehaviourDiaryEntryBox,
      );

  Stream<List<ChallengingBehaviourEntity>> watchAllBehaviours() {
    final builder = challengingBehaviourBox.query();

    return builder
        .watch(triggerImmediately: true)
        .map((query) {
      final result = query.find();
      return result;
    });
  }

  int putBehaviour(ChallengingBehaviourEntity behaviour) {
    return challengingBehaviourBox.put(behaviour);
  }

  List<ChallengingBehaviourEntity> getAllBehaviours() {
    return challengingBehaviourBox.getAll();
  }

  void deleteBehaviour(int id, {bool cascade = true}) {
    if (cascade) {
      final behaviour = challengingBehaviourBox.get(id);
      if (behaviour != null) {
        for (final entry in behaviour.diaryEntries) {
          challengingBehaviourDiaryEntryBox.remove(entry.id!);
        }
      }
    }
    challengingBehaviourBox.remove(id);
  }

  int addDiaryEntry(int behaviourId, ChallengingBehaviourDiaryEntryEntity entry) {
    final behaviour = challengingBehaviourBox.get(behaviourId);
    if (behaviour == null) throw Exception('Behaviour not found');

    entry.challengingBehaviour.target = behaviour;
    final entryId = challengingBehaviourDiaryEntryBox.put(entry);
    behaviour.diaryEntries.add(entry);
    challengingBehaviourBox.put(behaviour);
    return entryId;
  }

  List<ChallengingBehaviourDiaryEntryEntity> getDiaryEntries({int? behaviourId}) {
    if (behaviourId == null) {
      return challengingBehaviourDiaryEntryBox.getAll();
    } else {
      final behaviour = challengingBehaviourBox.get(behaviourId);
      return behaviour?.diaryEntries.toList() ?? [];
    }
  }

  int updateDiaryEntry(ChallengingBehaviourDiaryEntryEntity entry) {
    if (entry.id == null) throw Exception('Entry must have an id');
    return challengingBehaviourDiaryEntryBox.put(entry);
  }

  void deleteDiaryEntry(int id) {
    challengingBehaviourDiaryEntryBox.remove(id);
  }

  List<ChallengingBehaviourEntity> getAllPending() {
    final q = challengingBehaviourBox.query(
      ChallengingBehaviourEntity_.pendingAction.notEquals(0),
    ).build();
    final result = q.find();
    q.close();
    return result;
  }

  ChallengingBehaviourEntity? getById(int id) => challengingBehaviourBox.get(id);

  ChallengingBehaviourEntity? getByRemoteId(String id) => challengingBehaviourBox.getByRemoteId(id);



}
