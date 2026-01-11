import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/router_utils.dart';
import '../../../../core/widgets/filterable_list.dart';
import '../../../../core/widgets/icon/eating_icon.dart';
import '../../../../core/widgets/icon/occuring_icon.dart';
import '../../../../i18n/strings.g.dart';
import '../../../selected_person/provider/selected_person_notifier.dart';
import '../../domain/model/eating_habit.dart';
import '../viewmodel/eating_habits_list_viewmodel.dart';

class EatingHabitsList extends ConsumerWidget {
  const EatingHabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(filteredEatingHabitsProvider);

    return FilterableList<EatingHabit>(
      title: t.eating_habits,
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
            children: [
              EatingIcon(isEatingFlag: habit.isEatingFlag),
              OccuringIcon(
                isOccuringFlag: DateUtil.isTodayBetweenTwoDates(
                  habit.from,
                  habit.to,
                ),
              ),
            ],
          ),
          onTap: () =>
              router.push(RouterUtils.getEatingHabitDetailPath(), extra: habit),
        ),
      ),
      filters: [
        FilterOption(
          code: AppConstants.IS_EATING,
          label: AppConstants.getLabel(AppConstants.IS_EATING),
          predicate: (h) => h.isEatingFlag,
          icon: const EatingIcon(isEatingFlag: true),
        ),
        FilterOption(
          code: AppConstants.IS_NOT_EATING,
          label: AppConstants.getLabel(AppConstants.IS_NOT_EATING),
          predicate: (h) => !h.isEatingFlag,
          icon: const EatingIcon(isEatingFlag: false),
        ),
        FilterOption(
          code: AppConstants.IS_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_ACTIVE),
          predicate: (h) => DateUtil.isTodayBetweenTwoDates(h.from, h.to),
          icon: const OccuringIcon(isOccuringFlag: true),
        ),
        FilterOption(
          code: AppConstants.IS_NOT_ACTIVE,
          label: AppConstants.getLabel(AppConstants.IS_NOT_ACTIVE),
          predicate: (h) => !DateUtil.isTodayBetweenTwoDates(h.from, h.to),
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
      onTap: (habit) {
        router.push(RouterUtils.getEatingHabitDetailPath(), extra: habit);

      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedPerson = ref.watch(selectedPersonProvider);
          final selectedPersonId = selectedPerson!.remoteId!;

          final docRef = FirebaseFirestore.instance
              .collection('eating_habits')
              .doc();

          final newHabit = EatingHabit(
            from: DateTime.now(),
            to: null,
            isEatingFlag: true,
            name: '',
            description: '',
            userId: FirebaseService().currentUser!.uid,
            selectedPersonId: selectedPersonId,
            imageFilePath: null, updatedAt: DateTime.now(), remoteId: docRef.id,
          );

          router.push(
            RouterUtils.getNewEatingHabitPath(),
            extra: newHabit,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
