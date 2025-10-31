import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../i18n/strings.g.dart';
import '../data/model/challenging_behaviour_diary_entry_transport.dart';

class ChallengingBehaviourDetail extends ConsumerStatefulWidget {
  final ChallengingBehaviour cbdef;

  const ChallengingBehaviourDetail({super.key, required this.cbdef});

  @override
  ConsumerState<ChallengingBehaviourDetail> createState() =>
      _ChallengingBehaviourDetailState();
}

class _ChallengingBehaviourDetailState
    extends ConsumerState<ChallengingBehaviourDetail> {


  @override
  Widget build(BuildContext context) {

    final cb = ref.watch(challengingBehavioursProvider.select(
          (state) => state.firstWhere((element) => element.id == widget.cbdef.id),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(cb.name),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              _pressDeleteButton(cb);
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
              _habitName(cb),
              const SizedBoxDivider(),
              _occuringIcon(cb),
              const Divider(height: 32),
              ..._dates(cb),
              const Divider(height: 32),
              Text(
                t.notes,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBoxDivider(),
              Text(
                cb.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Divider(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => {
                    _newDiaryEntry(cb)
                },
                  icon: const Icon(Icons.add),
                  label: Text(t.add_new_entry),
                ),
              ),
              SizedBoxDivider(),
              cb.diaryEntries.isEmpty
                  ? Center(child: Text(t.no_entries))
                  : ListView.builder(
                      itemCount: cb.diaryEntries.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final de = cb.diaryEntries[index];
                        return Card(
                          elevation: 0,
                          child: ListTile(
                            onTap: () {
                              router.push(
                                RouterUtils.getChallengingBehaviourDiaryEntryDetailPath(),
                                extra: ChallengingBehaviourDiaryEntryTransport(
                                  cbId: cb.id!,
                                  entry: de,
                                  isNew: false,
                                ),
                              );
                            },
                            title: Text(
                              '${DateUtil.getDayOfWeekString(de.date.weekday)} ${DateUtil.returnDateInStringFormatWithTime(de.date)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${de.duration} ${t.minute(n: de.duration)}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(
            RouterUtils.getChallengingBehaviourEditPath(),
            extra: cb,
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _newDiaryEntry(ChallengingBehaviour cb) {
    router.push(
      RouterUtils.getNewChallengingBehaviourDiaryEntryPath(),
      extra: ChallengingBehaviourDiaryEntryTransport(
        cbId: cb.id!,
        entry: ChallengingBehaviourDiaryEntry(
          location: "",
          date: DateTime.now(),
          duration: 0,
          circumstances: "",
          people: [],
          outcome: "",
          reflection: "",
        ),
        isNew: true,
      ),
    );
  }

  Future<void> _pressDeleteButton(ChallengingBehaviour cb) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${t.really_delete_object}${cb.name}?"),
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
          .deleteBehaviour(cb);
      router.pop();
    }
  }

  Widget _habitName(ChallengingBehaviour cb) {
    return Text(
      cb.name,
      style: Theme.of(
        context,
      ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _occuringIcon(ChallengingBehaviour cb) {
    return Row(
      children: [
        OccuringIcon(isOccuringFlag: cb.occuring),
        const SizedBox(width: 8),
        Text(
          cb.occuring ? t.occuring : t.not_occuring,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  List<Widget> _dates(ChallengingBehaviour cb) {
    return [
      Row(
        children: [
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBoxDivider(),
              Text(t.from, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(width: 6),
              Text(
                DateUtil.returnDateInStringFormat(cb.from),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          const Spacer(flex: 1),
          const Spacer(flex: 1),
        ],
      ),
    ];
  }
}
