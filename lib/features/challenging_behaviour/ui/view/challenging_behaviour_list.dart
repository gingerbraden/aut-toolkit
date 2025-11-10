import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/services/firebase_service.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/filterable_list.dart';
import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../i18n/strings.g.dart';
import '../../../selected_person/provider/selected_person_notifier.dart';
import '../viewmodel/challenging_behaviour_list_viewmodel.dart';

class ChallengingBehaviourList extends ConsumerWidget {
  const ChallengingBehaviourList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final behaviours = ref.watch(filteredChallengingBehavioursProvider);

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
        comparator: (a, b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ),
      SortOption<ChallengingBehaviour>(
        code: AppConstants.NAME_DESC,
        label: AppConstants.getLabel(AppConstants.NAME_DESC),
        comparator: (a, b) =>
            b.name.toLowerCase().compareTo(a.name.toLowerCase()),
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
      items: behaviours,
      searchKey: (cb) => cb.name,
      itemBuilder: (cb) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        child: ListTile(
          title: Text(cb.name),
          subtitle: Text(
            '${t.from} ${DateUtil.returnDateInStringFormat(cb.from)}',
          ),
          trailing: OccuringIcon(isOccuringFlag: cb.occuring),
        ),
      ),
      filters: filters,
      sorts: sorts,
      onTap: (cb) {
        router.push(RouterUtils.getChallengingBehaviourDetailPath(), extra: cb);
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedPerson = ref
              .watch(selectedPersonsProvider.notifier)
              .getSelected();

          router.push(
            RouterUtils.getNewChallengingBehaviourPath(),
            extra: ChallengingBehaviour(
              name: "",
              from: DateTime.now(),
              description: "",
              diaryEntries: [],
              occuring: true,
              userId: FirebaseService().currentUser!.uid,
              selectedPersonId: selectedPerson.id!,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
