import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/features/challenging_behaviour/domain/model/challenging_behaviour_diary_entry.dart';
import 'package:aut_toolkit/features/challenging_behaviour/provider/challenging_behaviour_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengingBehaviourDiaryEntryDetailViewModel extends Notifier<void> {
  late BuildContext context;

  @override
  void build() {}

  void init(BuildContext ctx) => context = ctx;

  Future<void> deleteEntry({
    required WidgetRef ref,
    required ChallengingBehaviourDiaryEntry entry,
  }) async {
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
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(challengingBehavioursProvider.notifier).deleteDiaryEntry(entry);
      router.pop();
    }
  }
}

final challengingBehaviourDiaryEntryDetailViewModelProvider =
    NotifierProvider<ChallengingBehaviourDiaryEntryDetailViewModel, void>(
      ChallengingBehaviourDiaryEntryDetailViewModel.new,
    );
