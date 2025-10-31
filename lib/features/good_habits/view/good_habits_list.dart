import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/filterable_list.dart';
import 'package:aut_toolkit/features/good_habits/provider/good_habits_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/icon/occuring_icon.dart';
import '../domain/model/good_habit.dart';

class GoodHabitsList extends ConsumerWidget {
  const GoodHabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(goodHabitsProvider);

    return FilterableList<GoodHabit>(
      title: t.good_habits,
      items: habits,
      searchKey: (habit) => habit.name,
      itemBuilder: (habit) => Card(
        margin: EdgeInsetsGeometry.directional(bottom: 8),
        elevation: 0,
        child: ListTile(
          title: Text(habit.name),
          subtitle: Text(
            '${t.from} ${DateUtil.returnDateInStringFormat(habit.from)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [OccuringIcon(isOccuringFlag: habit.isOcuringFlag)],
          ),
          onTap: () =>
              router.push(RouterUtils.getEatingHabitDetailPath(), extra: habit),
        ),
      ),
      filters: [
        FilterOption(
          code: AppConstants.IS_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_ACTIVE),
          predicate: (h) => h.isOcuringFlag,
          icon: OccuringIcon(isOccuringFlag: true),
        ),
        FilterOption(
          code: AppConstants.IS_NOT_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_NOT_ACTIVE),
          predicate: (h) => !h.isOcuringFlag,
          icon: OccuringIcon(isOccuringFlag: false),
        ),
      ],
      sorts: [
        SortOption(
          code: AppConstants.NAME_ASC,
          label: AppConstants.getLabel(AppConstants.NAME_ASC),
          comparator: (a, b) => a.name.compareTo(b.name),
        ),
        SortOption(
          code: AppConstants.NAME_DESC,
          label: AppConstants.getLabel(AppConstants.NAME_DESC),
          comparator: (a, b) => b.name.compareTo(a.name),
        ),
        SortOption(
          code: AppConstants.DATE_ASC,
          label: AppConstants.getLabel(AppConstants.DATE_ASC),
          comparator: (a, b) => a.from.compareTo(b.from),
        ),
        SortOption(
          code: AppConstants.DATE_DESC,
          label: AppConstants.getLabel(AppConstants.DATE_DESC),
          comparator: (a, b) => b.from.compareTo(a.from),
        ),
      ],
      onTap: (habit) =>
          router.push(RouterUtils.getGoodHabitDetailPath(), extra: habit),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getNewGoodHabitPath(),
            extra: GoodHabit(
              from: DateTime.now(),
              isOcuringFlag: true,
              name: '',
              description: '',
              userId: FirebaseService().currentUser!.uid,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
