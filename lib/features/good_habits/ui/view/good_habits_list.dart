import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/router_utils.dart';
import '../../../../core/widgets/filterable_list.dart';
import '../../../../core/widgets/icon/occuring_icon.dart';
import '../../../../i18n/strings.g.dart';
import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/good_habit.dart';
import '../viewmodel/good_habits_list_viewmodel.dart';

class GoodHabitsList extends ConsumerWidget {
  const GoodHabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(filteredHabitsProvider);

    return FilterableList<GoodHabit>(
      title: t.good_habits,
      items: habits,
      searchKey: (habit) => habit.name,
      itemBuilder: (habit) => Card(
        margin: const EdgeInsets.only(bottom: 8),
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
              router.push(RouterUtils.getGoodHabitDetailPath(), extra: habit),
        ),
      ),
      filters: [
        FilterOption(
          code: AppConstants.IS_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_ACTIVE),
          predicate: (h) => h.isOcuringFlag,
          icon: const OccuringIcon(isOccuringFlag: true),
        ),
        FilterOption(
          code: AppConstants.IS_NOT_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_NOT_ACTIVE),
          predicate: (h) => !h.isOcuringFlag,
          icon: const OccuringIcon(isOccuringFlag: false),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedPersonId = ref
              .watch(selectedPersonsProvider.notifier)
              .getSelected()
              .id!;
          router.push(
            RouterUtils.getNewGoodHabitPath(),
            extra: GoodHabit(
              from: DateTime.now(),
              to: null,
              isOcuringFlag: true,
              name: '',
              description: '',
              userId: FirebaseService().currentUser!.uid,
              selectedPersonId: selectedPersonId,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
