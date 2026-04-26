import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/router_utils.dart';
import '../../../../core/widgets/description_detail.dart';
import '../../../../core/widgets/divider/sized_box_divider.dart';
import '../../../../core/widgets/icon/occuring_icon.dart';
import '../../../../i18n/strings.g.dart';
import '../viewmodel/good_habit_detail_viewmodel.dart';


class GoodHabitDetail extends ConsumerWidget {
  final GoodHabit habit;

  const GoodHabitDetail({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(goodHabitDetailProvider(habit));

    return Scaffold(
      appBar: AppBar(
        title: Text(t.detail),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.BASE_APP_UI_PADDING),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _habitName(context, viewModel),
                const SizedBoxDivider(),
                _occuringIcon(context, viewModel),
                const Divider(height: 32),
                _dates(context, viewModel),
                const Divider(height: 32),
                DescriptionDetail(description: viewModel.description),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getGoodHabitDetailEditPath(),
            extra: viewModel,
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _habitName(BuildContext context, GoodHabit viewModel) {
    return Text(
      viewModel.name,
      style: Theme.of(
        context,
      ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _occuringIcon(BuildContext context, GoodHabit viewModel) {
    return Row(
      children: [
        OccuringIcon(isOccuringFlag: viewModel.isOcuringFlag),
        const SizedBox(width: 8),
        Text(
          viewModel.isOcuringFlag ? t.occuring : t.not_occuring,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _dates(BuildContext context, GoodHabit viewModel) {
    return Row(
      children: [
        Row(
          children: [
            const Icon(Icons.date_range),
            const SizedBox(width: 8),
            Text(t.from, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(width: 6),
            Text(
              DateUtil.returnDateInStringFormat(viewModel.from),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.date_range),
            const SizedBox(width: 8),
            Text(t.to, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(width: 6),
            Text(
              viewModel.to != null
                  ? DateUtil.returnDateInStringFormat(viewModel.to!)
                  : t.not_set,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${t.delete} ${habit.name}?"),
        content: Text(t.cant_undo_action),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(goodHabitDetailProvider(habit).notifier).deleteHabit(ref);
      router.pop();
    }
  }
}
