import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/model/good_habit.dart';

class GoodHabitEdit extends ConsumerStatefulWidget {
  final GoodHabit habit;
  final bool isNew;
  const GoodHabitEdit({super.key, required this.habit, required this.isNew});

  @override
  ConsumerState<GoodHabitEdit> createState() => _GoodHabitEditState();
}

class _GoodHabitEditState extends ConsumerState<GoodHabitEdit> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
