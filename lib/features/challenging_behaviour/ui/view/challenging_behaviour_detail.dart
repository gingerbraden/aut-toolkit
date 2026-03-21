import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/date_util.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/description_detail.dart';
import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/core/widgets/icon/occuring_icon.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_transport.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/challenging_behaviour_detail_viewmodel.dart';
import 'challenging_behaviour_diary_qr_scanner.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(challengingBehaviourDetailViewModelProvider.notifier)
          .init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(
      challengingBehaviourDetailViewModelProvider.notifier,
    );

    final cb = ref.watch(
      challengingBehavioursProvider.select(
        (state) => state.firstWhere((element) => element.id == widget.cbdef.id),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.detail),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => viewModel.deleteBehaviour(ref: ref, cb: cb),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.BASE_APP_UI_PADDING,
        ),
        child: Column(
          children: [
            Card(
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
                    DescriptionDetail(description: cb.description),
                  ],
                ),
              ),
            ),
            const Divider(height: 32),
            _addEntryButton(cb, viewModel),
            const SizedBoxDivider(),
            _addEntryFromQRButton(cb, viewModel),
            const SizedBoxDivider(),
            _diaryEntries(cb),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(RouterUtils.getChallengingBehaviourEditPath(), extra: cb);
        },
        child: const Icon(Icons.edit),
      ),
    );
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
          Icon(Icons.date_range),
          const SizedBox(width: 6),
          Text(t.from, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: 6),
          Text(
            DateUtil.returnDateInStringFormat(cb.from),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ];
  }

  Widget _addEntryButton(
    ChallengingBehaviour cb,
    ChallengingBehaviourDetailViewModel vm,
  ) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => vm.newDiaryEntry(cb),
        icon: const Icon(Icons.add),
        label: Text(t.add_new_entry),
      ),
    );
  }

  Widget _addEntryFromQRButton(
    ChallengingBehaviour cb,
    ChallengingBehaviourDetailViewModel vm,
  ) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final scannedEntry =
              await Navigator.push<ChallengingBehaviourDiaryEntry>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChallengingBehaviourDiaryQrScanner(),
                ),
              );

          if (scannedEntry != null) {
            vm.newDiaryEntryFromQR(cb, scannedEntry);
          }
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: Text(t.add_entry_from_QR),
      ),
    );
  }

  Widget _diaryEntries(ChallengingBehaviour cb) {
    if (cb.diaryEntries.isEmpty) return Center(child: Text(t.no_entries));

    return ListView.builder(
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
            trailing: Text('${de.duration} ${t.minute(n: de.duration)}'),
          ),
        );
      },
    );
  }
}
