import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoodHabitDetail extends ConsumerStatefulWidget {
  final GoodHabit habit;
  const GoodHabitDetail({super.key, required this.habit});

  @override
  ConsumerState<GoodHabitDetail> createState() => _GoodHabitDetailState();
}

class _GoodHabitDetailState extends ConsumerState<GoodHabitDetail> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
