import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/services/tts_service.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userCardDetailViewModelProvider =
    NotifierProvider<UserCardDetailViewModel, void>(
      UserCardDetailViewModel.new,
    );

class UserCardDetailViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<void> confirmDelete(BuildContext context, UserCard card) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.really_delete_object),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.yes),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final container = ProviderScope.containerOf(context);
      container.read(cardsProvider.notifier).deleteCard(card);
      router.pop();
    }
  }

  Future<void> speak(String text) async {
    await TtsService.speak(text);
  }
}
