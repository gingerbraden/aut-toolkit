import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/widgets/square_items_list.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/model/user_card.dart';
import '../viewmodel/user_cards_list_viewmodel.dart';

class UserCardPicker extends ConsumerWidget {
  const UserCardPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>;
    final void Function(UserCard) onSelected = args['onSelected'];

    final cards = ref.watch(filteredUserCardsProvider);

    return SquareItemsList<UserCard>(
      title: t.cards,
      items: cards,
      searchKey: (item) =>
          item.names[LocaleSettings.currentLocale.languageCode] ?? '',
      itemBuilder: (item) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Card(
          elevation: 0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(item.localImgPath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.names[LocaleSettings.currentLocale.languageCode] ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: (item) {
        onSelected(item);
        router.pop(context);
      },
    );
  }
}
