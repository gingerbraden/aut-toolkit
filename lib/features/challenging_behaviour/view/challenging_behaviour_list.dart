import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_util.dart';
import '../../../core/widgets/filterable_list.dart';
import '../../../i18n/strings.g.dart';

class ChallengingBehaviourList extends ConsumerWidget {
  const ChallengingBehaviourList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(challengingBehavioursProvider);

    final filters = [
      FilterOption<ChallengingBehaviour>(
        code: AppConstants.IS_ACTIVE,
        label: AppConstants.getLabel(AppConstants.IS_ACTIVE),
        icon: const OccuringIcon(isOccuringFlag: true),
        predicate: (cb) => cb.occuring,
      ),
      FilterOption<ChallengingBehaviour>(
        code: AppConstants.IS_NOT_ACTIVE,
        label: AppConstants.getLabel(AppConstants.IS_NOT_ACTIVE),
        icon: const OccuringIcon(isOccuringFlag: false),
        predicate: (cb) => !cb.occuring,
      ),
    ];

    final sorts = [
      SortOption<ChallengingBehaviour>(
        code: AppConstants.NAME_ASC,
        label: AppConstants.getLabel(AppConstants.NAME_ASC),
        comparator: (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ),
      SortOption<ChallengingBehaviour>(
        code: AppConstants.NAME_DESC,
        label: AppConstants.getLabel(AppConstants.NAME_DESC),
        comparator: (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      ),
      SortOption<ChallengingBehaviour>(
        code: AppConstants.DATE_ASC,
        label: AppConstants.getLabel(AppConstants.DATE_ASC),
        comparator: (a, b) => a.from.compareTo(b.from),
      ),
      SortOption<ChallengingBehaviour>(
        code: AppConstants.DATE_DESC,
        label: AppConstants.getLabel(AppConstants.DATE_DESC),
        comparator: (a, b) => b.from.compareTo(a.from),
      ),
    ];

    return FilterableList<ChallengingBehaviour>(
      title: t.challenging_behaviour,
      items: habits,
      searchKey: (cb) => cb.name,
      itemBuilder: (cb) => Card(
        margin: EdgeInsetsGeometry.directional(bottom: 8),
        elevation: 0,
        child: ListTile(
          title: Text(cb.name),
          subtitle: Text('${t.from} ${DateUtil.returnDateInStringFormat(cb.from)}'),
          trailing: OccuringIcon(isOccuringFlag: cb.occuring),
        ),
      ),
      filters: filters,
      sorts: sorts,
      onTap: (cb) {
        router.push(
          RouterUtils.getChallengingBehaviourDetailPath(),
          extra: cb,
        );
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getNewChallengingBehaviourPath(),
            extra: ChallengingBehaviour(
              name: "",
              from: DateTime.now(),
              description: "",
              diaryEntries: [],
              occuring: true,
              userId: FirebaseService().currentUser!.uid,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
