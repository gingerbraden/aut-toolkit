import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/challenging_behaviour.dart';
import '../../provider/challenging_behaviour_notifier.dart';

final filteredChallengingBehavioursProvider =
    Provider<List<ChallengingBehaviour>>((ref) {
      final behaviours = ref.watch(challengingBehavioursProvider);
      final selectedPerson = ref.watch(selectedPersonProvider);
      return behaviours
          .where((cb) => cb.selectedPersonId == selectedPerson.id)
          .toList();
    });

class ChallengingBehaviourListViewModel
    extends Notifier<List<ChallengingBehaviour>> {
  @override
  List<ChallengingBehaviour> build() => [];

  void applyFilter(ChallengingBehaviourFilter filter) {
    switch (filter) {
      case ChallengingBehaviourFilter.occuring:
        state = state.where((cb) => cb.occuring).toList();
        break;
      case ChallengingBehaviourFilter.notOccuring:
        state = state.where((cb) => !cb.occuring).toList();
        break;
      case ChallengingBehaviourFilter.all:
        break;
    }
  }

  void applySort(ChallengingBehaviourSort sort) {
    switch (sort) {
      case ChallengingBehaviourSort.nameAsc:
        state = [...state]..sort((a, b) => a.name.compareTo(b.name));
        break;
      case ChallengingBehaviourSort.nameDesc:
        state = [...state]..sort((a, b) => b.name.compareTo(a.name));
        break;
      case ChallengingBehaviourSort.dateAsc:
        state = [...state]..sort((a, b) => a.from.compareTo(b.from));
        break;
      case ChallengingBehaviourSort.dateDesc:
        state = [...state]..sort((a, b) => b.from.compareTo(a.from));
        break;
    }
  }
}

enum ChallengingBehaviourFilter { all, occuring, notOccuring }

enum ChallengingBehaviourSort { nameAsc, nameDesc, dateAsc, dateDesc }
