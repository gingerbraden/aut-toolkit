import 'package:flutter_riverpod/legacy.dart';

import '../../../../card_management/domain/model/user_card.dart';
import '../../../../card_management/provider/card_notifier.dart';
import '../../domain/model/visual_list.dart';

final visualListScheduleProvider =
    StateNotifierProvider.family<
      VisualListScheduleViewModel,
      VisualListScheduleState,
      VisualList
    >((ref, visualList) {
      final allCards = ref.read(cardsProvider);
      final steps = visualList.steps
          .map(
            (card) =>
                allCards.firstWhere((c) => c.id == card.id, orElse: () => card),
          )
          .toList();
      return VisualListScheduleViewModel(steps: steps, allCards: allCards);
    });

class VisualListScheduleViewModel
    extends StateNotifier<VisualListScheduleState> {
  final List<UserCard> allCards;
  final Map<int, int> cardOriginalIndex;
  final List<UserCard> initialSteps;

  VisualListScheduleViewModel({
    required List<UserCard> steps,
    required this.allCards,
  }) : cardOriginalIndex = {
         for (int i = 0; i < steps.length; i++) steps[i].id!: i,
       },
       initialSteps = List<UserCard>.from(steps),
       super(
         VisualListScheduleState(
           middleCard: steps.isNotEmpty ? steps.first : null,
           topList: steps.length > 1 ? steps.sublist(1) : [],
           bottomList: [],
         ),
       );

  void moveMiddleToBottom() {
    final middle = state.middleCard;

    if (middle == null) return;

    final updatedBottom = List<UserCard>.from(state.bottomList)..add(middle);

    final updatedTop = List<UserCard>.from(state.topList);

    final UserCard? newMiddle = updatedTop.isNotEmpty
        ? updatedTop.removeAt(0)
        : null;

    state = state.copyWith(
      topList: updatedTop,
      middleCard: newMiddle,
      bottomList: updatedBottom,
    );
  }

  int getOrderNumber(UserCard card) => cardOriginalIndex[card.id]! + 1;

  void reset() {
    state = VisualListScheduleState(
      middleCard: initialSteps.isNotEmpty ? initialSteps.first : null,
      topList: initialSteps.length > 1 ? initialSteps.sublist(1) : [],
      bottomList: [],
    );
  }
}

class VisualListScheduleState {
  final List<UserCard> topList;
  final List<UserCard> bottomList;
  final UserCard? middleCard;

  VisualListScheduleState({
    required this.topList,
    required this.bottomList,
    required this.middleCard,
  });

  VisualListScheduleState copyWith({
    List<UserCard>? topList,
    List<UserCard>? bottomList,
    UserCard? middleCard,
  }) {
    return VisualListScheduleState(
      topList: topList ?? this.topList,
      bottomList: bottomList ?? this.bottomList,
      middleCard: middleCard ?? this.middleCard,
    );
  }
}
