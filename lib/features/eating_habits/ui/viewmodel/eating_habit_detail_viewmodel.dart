import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/eating_habit.dart';
import '../../provider/eating_habits_notifier.dart';

final eatingHabitDetailProvider = NotifierProvider.autoDispose
    .family<EatingHabitDetailViewModel, EatingHabit, EatingHabit>(
      EatingHabitDetailViewModel.new,
    );

class EatingHabitDetailViewModel extends Notifier<EatingHabit> {
  final EatingHabit _habit;

  EatingHabitDetailViewModel(this._habit);

  @override
  EatingHabit build() => _habit;

  void deleteHabit(WidgetRef ref) {
    ref.read(eatingHabitsProvider.notifier).deleteHabit(_habit);
  }
}
