import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/widgets/description_detail.dart';
import 'package:aut_toolkit/core/widgets/square_image_filled_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../core/widgets/icon/eating_icon.dart';
import '../../../i18n/strings.g.dart';
import '../domain/model/eating_habit.dart';
import '../provider/eating_habits_notifier.dart';

class EatingHabitDetail extends ConsumerStatefulWidget {
  final EatingHabit habit;

  const EatingHabitDetail({super.key, required this.habit});

  @override
  ConsumerState<EatingHabitDetail> createState() => _EatingHabitDetailState();
}

class _EatingHabitDetailState extends ConsumerState<EatingHabitDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.detail),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              _pressDeleteButton();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: AppConstants.BASE_APP_UI_PADDING, right: AppConstants.BASE_APP_UI_PADDING, bottom: AppConstants.BASE_APP_UI_PADDING),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _habitName(),
                  const SizedBoxDivider(),
                  _eatingIcon(),
                  const Divider(height: 32),
                  ..._dates(),
                  const Divider(height: 32),
                  DescriptionDetail(description: widget.habit.description),
                  const Divider(height: 32),
                  widget.habit.imageFilePath != null
                      ? SquareImageFilledWidth(imageFilePath: widget.habit.imageFilePath) : Container()
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getEatingHabitDetailEditPath(),
            extra: widget.habit,
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Future<void> _pressDeleteButton() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${t.delete} ${widget.habit.name}?"),
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
      ref.read(eatingHabitsProvider.notifier).deleteHabit(widget.habit);
      router.pop();
    }
  }

  Widget _habitName() {
    return Text(
      widget.habit.name,
      style: Theme.of(
        context,
      ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _eatingIcon() {
    return Row(
      children: [
        EatingIcon(isEatingFlag: widget.habit.isEatingFlag),
        const SizedBox(width: 8),
        Text(
          widget.habit.isEatingFlag ? t.is_eating : t.is_not_eating,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  List<Widget> _dates() {
    return [
      Row(
        children: [
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBoxDivider(),
              Text(
                t.from,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 6),
              Text(
                DateUtil.returnDateInStringFormat(widget.habit.from),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          const Spacer(flex: 1),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.date_range),
              SizedBoxDivider(),
              Text(
                t.to,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 6),
              Text(
                widget.habit.to != null ? DateUtil.returnDateInStringFormat(widget.habit.to) : t.not_set,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    ];
  }


}
