import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/good_habit.dart';
import '../../provider/good_habits_notifier.dart';

final goodHabitDetailProvider = NotifierProvider.autoDispose
    .family<GoodHabitDetailViewModel, GoodHabit, GoodHabit>(
      GoodHabitDetailViewModel.new,
    );

class GoodHabitDetailViewModel extends Notifier<GoodHabit> {
  final GoodHabit _habit;

  GoodHabitDetailViewModel(this._habit);

  @override
  GoodHabit build() => _habit;

  void deleteHabit(WidgetRef ref) {
    ref.read(goodHabitsProvider.notifier).deleteHabit(_habit);
  }
}
