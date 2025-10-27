import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_transport.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/widgets/sized_box_divider.dart';
import '../../../i18n/strings.g.dart';
import '../domain/model/challenging_behaviour_diary_entry.dart';

class ChallengingBehaviourDiaryEntryDetail extends ConsumerStatefulWidget {
  final ChallengingBehaviourDiaryEntry entry;
  final int cbId;

  const ChallengingBehaviourDiaryEntryDetail({super.key, required this.entry, required this.cbId});

  @override
  ConsumerState<ChallengingBehaviourDiaryEntryDetail> createState() => _ChallengingBehaviourDiaryEntryDetailState();
}

class _ChallengingBehaviourDiaryEntryDetailState extends ConsumerState<ChallengingBehaviourDiaryEntryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateUtil.returnDateInStringFormat(widget.entry.date)),
        centerTitle: true,
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
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(context, t.location),
            const SizedBoxDivider(),
            Text(widget.entry.location, style: Theme.of(context).textTheme.bodyMedium),
            const Divider(height: 32),

            _sectionTitle(context, t.duration),
            const SizedBoxDivider(),
            Text('${widget.entry.duration} ${t.minute(n: widget.entry.duration)}',
                style: Theme.of(context).textTheme.bodyMedium),
            const Divider(height: 32),

            _sectionTitle(context, t.circumstances),
            const SizedBoxDivider(),
            Text(widget.entry.circumstances, style: Theme.of(context).textTheme.bodyMedium),
            const Divider(height: 32),

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
            const Divider(height: 32),

            _sectionTitle(context, t.outcome),
            const SizedBoxDivider(),
            Text(widget.entry.outcome, style: Theme.of(context).textTheme.bodyMedium),
            const Divider(height: 32),

            _sectionTitle(context, t.reflection),
            const SizedBoxDivider(),
            Text(widget.entry.reflection, style: Theme.of(context).textTheme.bodyMedium),
          ],
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
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Future<void> _pressDeleteButton() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("${t.really_delete_object}${t.entry}?"),
            actions: [
              TextButton(
                onPressed: () => router.pop(false),
                child: Text(t.cancel),
              ),
              TextButton(
                onPressed: () => router.pop(true),
                child: Text(t.yes, style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
    if (confirm == true) {
      ref
          .read(challengingBehavioursProvider.notifier)
          .deleteDiaryEntry(widget.entry);
      router.pop();
    }
  }
}
