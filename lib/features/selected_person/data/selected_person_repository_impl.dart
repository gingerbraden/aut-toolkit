import 'package:aut_toolkit/features/challenging_behaviour/data/source/challenging_behaviour_local_source.dart';
import 'package:aut_toolkit/features/eating_habits/data/source/eating_habit_local_source.dart';
import 'package:aut_toolkit/features/good_habits/data/source/good_habit_local_source.dart';
import 'package:aut_toolkit/features/selected_person/data/model/selected_person_mappers.dart';
import 'package:aut_toolkit/features/selected_person/data/source/selected_person_local_source.dart';

import '../domain/model/selected_person.dart';
import '../domain/repository/selected_person_repository.dart';

class SelectedPersonRepositoryImpl implements SelectedPersonRepository {
  final SelectedPersonLocalSource _localSource;
  final ChallengingBehaviourLocalSource _challengingBehaviourLocalSource;
  final EatingHabitLocalSource _eatingHabitLocalSource;
  final GoodHabitLocalSource _goodHabitLocalSource;

  SelectedPersonRepositoryImpl(this._localSource, this._challengingBehaviourLocalSource, this._eatingHabitLocalSource, this._goodHabitLocalSource);

  @override
  List<SelectedPerson> getAll() {
    return _localSource.getAll().map((e) => e.toModel()).toList();
  }

  @override
  void save(SelectedPerson sp) {
    // Fetch all stored persons
    final allPersons = _localSource.getAll();

    // Update isSelected for all persons
    for (var person in allPersons) {
      person.isSelected = false;
      _localSource.put(person); // Save the updated person
    }

    // Set the current person as selected and save
    sp.isSelected = true;
    _localSource.put(sp.toEntity());
  }

  @override
  void delete(SelectedPerson sp) {
    _localSource.remove(sp.id!);
    if (_challengingBehaviourLocalSource.getAllBehaviours().isNotEmpty) {
      for (var chb in _challengingBehaviourLocalSource.getAllBehaviours()) {
        if (chb.selectedPersonId == sp.id!) {
          _challengingBehaviourLocalSource.deleteBehaviour(chb.id!);
        }
      }
    }
    if (_eatingHabitLocalSource.getAll().isNotEmpty) {
      for (var eh in _eatingHabitLocalSource.getAll()) {
        if (eh.selectedPersonId == sp.id!) {
          _eatingHabitLocalSource.remove(eh.id);
        }
      }
    }
    if (_goodHabitLocalSource.getAll().isNotEmpty) {
      for (var gh in _goodHabitLocalSource.getAll()) {
        if (gh.selectedPersonId == sp.id!) {
          _goodHabitLocalSource.remove(gh.id);
        }
      }
    }
  }


}
