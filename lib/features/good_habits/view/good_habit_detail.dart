import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/widgets/description_detail.dart';
import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/features/good_habits/domain/model/good_habit.dart';
import 'package:aut_toolkit/features/good_habits/provider/good_habits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../i18n/strings.g.dart';

class GoodHabitDetail extends ConsumerStatefulWidget {
  final GoodHabit habit;
  const GoodHabitDetail({super.key, required this.habit});

  @override
  ConsumerState<GoodHabitDetail> createState() => _GoodHabitDetailState();
}

class _GoodHabitDetailState extends ConsumerState<GoodHabitDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
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
                  _occuringIcon(),
                  const Divider(height: 32),
                  ..._dates(),
                  const Divider(height: 32),
                  DescriptionDetail(description: widget.habit.description)
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getGoodHabitDetailEditPath(),
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
      builder: (context) =>
          AlertDialog(
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
      ref.read(goodHabitsProvider.notifier).deleteHabit(widget.habit);
      router.pop();
    }
  }

  Widget _habitName() {
    return Text(
      widget.habit.name,
      style: Theme
          .of(
        context,
      )
          .textTheme
          .headlineLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _occuringIcon() {
    return Row(
      children: [
        OccuringIcon(isOccuringFlag: widget.habit.isOcuringFlag),
        const SizedBox(width: 8),
        Text(
          widget.habit.isOcuringFlag ? t.occuring : t.not_occuring,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
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
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
              const SizedBox(width: 6),
              Text(
                DateUtil.returnDateInStringFormat(widget.habit.from),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
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
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
              const SizedBox(width: 6),
              Text(
                widget.habit.to != null ? DateUtil.returnDateInStringFormat(
                    widget.habit.to) : t.not_set,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
              ),
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    ];
  }
}
