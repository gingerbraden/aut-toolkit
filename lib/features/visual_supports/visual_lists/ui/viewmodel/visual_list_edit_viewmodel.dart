import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../card_management/domain/model/user_card.dart';
import '../../domain/model/visual_list.dart';
import '../../provider/visual_list_notifier.dart';

final visualListEditViewModelProvider =
    StateNotifierProvider.family<
      VisualListEditViewModel,
      VisualListEditFormState,
      VisualList
    >((ref, list) => VisualListEditViewModel(ref, list));

class VisualListEditFormState {
  final String name;
  final List<UserCard> steps;

  VisualListEditFormState({required this.name, required this.steps});

  VisualListEditFormState copyWith({String? name, List<UserCard>? steps}) =>
      VisualListEditFormState(
        name: name ?? this.name,
        steps: steps ?? this.steps,
      );
}

class VisualListEditViewModel extends StateNotifier<VisualListEditFormState> {
  final Ref ref;
  final VisualList _list;

  VisualListEditViewModel(this.ref, this._list)
    : super(
        VisualListEditFormState(
          name: _list.name,
          steps: List.from(_list.steps),
        ),
      );

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void addStep(UserCard card) {
    final newSteps = List<UserCard>.from(state.steps)..add(card);
    state = state.copyWith(steps: newSteps);
  }

  void updateStep(int index, UserCard card) {
    final newSteps = List<UserCard>.from(state.steps);
    newSteps[index] = card;
    state = state.copyWith(steps: newSteps);
  }

  void reorderSteps(int oldIndex, int newIndex) {
    final newSteps = List<UserCard>.from(state.steps);
    if (newIndex > oldIndex) newIndex--;
    final item = newSteps.removeAt(oldIndex);
    newSteps.insert(newIndex, item);
    state = state.copyWith(steps: newSteps);
  }

  void deleteStep(int index) {
    final newSteps = List<UserCard>.from(state.steps)..removeAt(index);
    state = state.copyWith(steps: newSteps);
  }

  void saveChanges() {
    final updatedList = VisualList(
      id: _list.id,
      userId: _list.userId,
      name: state.name,
      steps: state.steps,
      isVisualSchedule: _list.isVisualSchedule,
      isVisualDiagram: _list.isVisualDiagram,
    );

    if (_list.isVisualDiagram) {
      ref
          .read(visualDiagramsProvider(_list.userId).notifier)
          .addDiagram(updatedList);
    } else {
      ref
          .read(visualSchedulesProvider(_list.userId).notifier)
          .addSchedule(updatedList);
    }
  }
}
