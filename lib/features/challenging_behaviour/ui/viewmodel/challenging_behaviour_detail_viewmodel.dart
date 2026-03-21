import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/challenging_behaviour/data/model/challenging_behaviour_diary_entry_transport.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengingBehaviourDetailViewModelProvider =
    NotifierProvider<ChallengingBehaviourDetailViewModel, void>(
      ChallengingBehaviourDetailViewModel.new,
    );

class ChallengingBehaviourDetailViewModel extends Notifier<void> {
  late BuildContext context;

  @override
  void build() {}

  void init(BuildContext ctx) => context = ctx;

  Future<void> deleteBehaviour({
    required WidgetRef ref,
    required ChallengingBehaviour cb,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${t.delete} ${cb.name}?"),
        content: Text(t.cant_undo_action),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
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
      ref.read(challengingBehavioursProvider.notifier).deleteBehaviour(cb);
      router.pop();
    }
  }

  void newDiaryEntry(ChallengingBehaviour cb) {
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

  void newDiaryEntryFromQR(
    ChallengingBehaviour cb,
    ChallengingBehaviourDiaryEntry de,
  ) {
    router.push(
      RouterUtils.getNewChallengingBehaviourDiaryEntryPath(),
      extra: ChallengingBehaviourDiaryEntryTransport(
        cbId: cb.id!,
        entry: ChallengingBehaviourDiaryEntry(
          location: de.location,
          date: de.date,
          duration: de.duration,
          circumstances: de.circumstances,
          people: de.people,
          outcome: de.outcome,
          reflection: de.reflection,
        ),
        isNew: true,
      ),
    );
  }
}
