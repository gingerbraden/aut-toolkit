import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_transport.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/challenging_behaviour_diary_entry_detail_viewmodel.dart';

class ChallengingBehaviourDiaryEntryDetail extends ConsumerStatefulWidget {
  final ChallengingBehaviourDiaryEntry entry;
  final int cbId;

  const ChallengingBehaviourDiaryEntryDetail({
    super.key,
    required this.entry,
    required this.cbId,
  });

  @override
  ConsumerState<ChallengingBehaviourDiaryEntryDetail> createState() =>
      _ChallengingBehaviourDiaryEntryDetailState();
}

class _ChallengingBehaviourDiaryEntryDetailState
    extends ConsumerState<ChallengingBehaviourDiaryEntryDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(challengingBehaviourDiaryEntryDetailViewModelProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(
      challengingBehaviourDiaryEntryDetailViewModelProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(DateUtil.returnDateInStringFormat(widget.entry.date)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("${t.delete} ${t.entry}?"),
                  content: Text(t.cant_undo_action),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(t.cancel),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(t.delete),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                viewModel.deleteEntry(
                  ref: ref,
                  entry: widget.entry,
                  cbId: widget.cbId,
                );
                router.pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._basicStringDetail(t.location, widget.entry.location),
                const Divider(height: 32),
                ..._basicStringDetail(
                  t.duration,
                  widget.entry.duration.toString(),
                ),
                const Divider(height: 32),
                ..._basicStringDetail(
                  t.circumstances,
                  widget.entry.circumstances,
                ),
                const Divider(height: 32),
                ..._peoplePresent(),
                const Divider(height: 32),
                ..._basicStringDetail(t.outcome, widget.entry.outcome),
                const Divider(height: 32),
                ..._basicStringDetail(t.reflection, widget.entry.reflection),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getChallengingBehaviourDiaryEntryEditPath(),
            extra: ChallengingBehaviourDiaryEntryTransport(
              cbId: widget.cbId,
              entry: widget.entry,
              isNew: false,
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  List<Widget> _basicStringDetail(String title, String data) {
    return [
      _sectionTitle(context, title),
      const SizedBoxDivider(),
      Text(data, style: Theme.of(context).textTheme.bodyMedium),
    ];
  }

  List<Widget> _peoplePresent() {
    return [
      _sectionTitle(context, t.people_present),
      const SizedBoxDivider(),
      widget.entry.people.isEmpty
          ? Text(t.no_entries)
          : Wrap(
              spacing: 8,
              children: widget.entry.people
                  .map((person) => Chip(label: Text(person)))
                  .toList(),
            ),
    ];
  }
}
