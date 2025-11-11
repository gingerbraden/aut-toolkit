import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/widgets/description_detail.dart';
import 'package:aut_toolkit/core/widgets/square_image_filled_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/router_utils.dart';
import '../../../../core/widgets/divider/sized_box_divider.dart';
import '../../../../core/widgets/icon/eating_icon.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/model/eating_habit.dart';
import '../viewmodel/eating_habit_detail_viewmodel.dart';

class EatingHabitDetail extends ConsumerWidget {
  final EatingHabit habit;

  const EatingHabitDetail({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(eatingHabitDetailViewModelProvider(habit));

    return Scaffold(
      appBar: AppBar(
        title: Text(t.detail),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async => _confirmDelete(context, ref, viewModel),
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
                _eatingIcon(context, viewModel),
                const Divider(height: 32),
                _dates(context, viewModel),
                const Divider(height: 32),
                DescriptionDetail(description: viewModel.description),
                const Divider(height: 32),
                if (viewModel.imageFilePath!.isNotEmpty)
                  SquareImageFilledWidth(
                    imageFilePath: viewModel.imageFilePath,
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getEatingHabitDetailEditPath(),
            extra: viewModel,
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _habitName(BuildContext context, EatingHabit viewModel) {
    return Text(
      viewModel.name,
      style: Theme.of(
        context,
      ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _eatingIcon(BuildContext context, EatingHabit viewModel) {
    return Row(
      children: [
        EatingIcon(isEatingFlag: viewModel.isEatingFlag),
        const SizedBox(width: 8),
        Text(
          viewModel.isEatingFlag ? t.is_eating : t.is_not_eating,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _dates(BuildContext context, EatingHabit viewModel) {
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

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    EatingHabit viewModel,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${t.delete} ${viewModel.name}?"),
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
      ref
          .read(eatingHabitDetailViewModelProvider(viewModel).notifier)
          .deleteHabit(ref);
      router.pop();
    }
  }
}
