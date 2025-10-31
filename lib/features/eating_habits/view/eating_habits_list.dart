import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/filterable_list.dart';
import 'package:aut_toolkit/features/eating_habits/domain/model/eating_habit.dart';
import 'package:aut_toolkit/features/eating_habits/provider/eating_habits_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';

import '../../../core/widgets/icon/eating_icon.dart';
import '../../selected_person/provider/selected_person_notifier.dart';

class EatingHabitsList extends ConsumerWidget {
  const EatingHabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(eatingHabitsProvider);

    return FilterableList<EatingHabit>(
      title: t.eating_habits,
      items: habits.where((h) => h.selectedPersonId==ref.watch(selectedPersonsProvider.notifier).getSelected().id!).toList(),
      searchKey: (habit) => habit.name,
      itemBuilder: (habit) => Card(
        margin: EdgeInsetsGeometry.directional(bottom: 8),
        elevation: 0,
        child: ListTile(
          title: Text(habit.name),
          subtitle: Text('${t.from} ${DateUtil.returnDateInStringFormat(habit.from)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              EatingIcon(isEatingFlag: habit.isEatingFlag),
              OccuringIcon(
                isOccuringFlag: DateUtil.isTodayBetweenTwoDates(habit.from, habit.to),
              ),
            ],
          ),
          onTap: () => router.push(
            RouterUtils.getEatingHabitDetailPath(),
            extra: habit,
          ),
        ),
      ),
      filters: [
        FilterOption(
          code: AppConstants.IS_EATING,
          label: AppConstants.getLabel(AppConstants.IS_EATING),
          predicate: (h) => h.isEatingFlag,
          icon: EatingIcon(isEatingFlag: true),
        ),
        FilterOption(
          code: AppConstants.IS_NOT_EATING,
          label: AppConstants.getLabel(AppConstants.IS_NOT_EATING),
          predicate: (h) => !h.isEatingFlag,
          icon: EatingIcon(isEatingFlag: false),
        ),
        FilterOption(
          code: AppConstants.IS_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_ACTIVE),
          predicate: (h) => DateUtil.isTodayBetweenTwoDates(h.from, h.to),
          icon: OccuringIcon(isOccuringFlag: true),
        ),
        FilterOption(
          code: AppConstants.IS_NOT_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_NOT_ACTIVE),
          predicate: (h) => !DateUtil.isTodayBetweenTwoDates(h.from, h.to),
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
      onTap: (habit) => router.push(
        RouterUtils.getEatingHabitDetailPath(),
        extra: habit,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getNewEatingHabitPath(),
            extra: EatingHabit(
              from: DateTime.now(),
              to: null,
              isEatingFlag: true,
              name: '',
              description: '',
              userId: FirebaseService().currentUser!.uid,
              selectedPersonId: ref.watch(selectedPersonsProvider.notifier).getSelected().id!
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
