import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/eating_icon.dart';
import '../../../core/widgets/sized_box_divider.dart';
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
              Text(
                t.notes,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBoxDivider(),
              Text(
                widget.habit.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
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
        title: Text("${t.really_delete_object}${widget.habit.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.yes, style: TextStyle(color: Colors.red)),
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
          // --- From group ---
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

          const Spacer(flex: 1), // pushes next group toward center a bit

          // --- To group ---
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

          const Spacer(flex: 1), // optional: keeps right padding consistent
        ],
      ),
    ];
  }


}
