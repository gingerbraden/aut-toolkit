import 'dart:io';

import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/square_items_list.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/user_cards_list_viewmodel.dart';

class UserCardsList extends ConsumerWidget {
  const UserCardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(filteredUserCardsProvider);
    final viewModel = ref.read(userCardsListViewModelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setCards(cards);
    });

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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(item.localImgPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      item.names[LocaleSettings.currentLocale.languageCode] ??
                          '',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: (item) =>
          router.push(RouterUtils.getCardDetailPath(), extra: item),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) return;
          final docRef = FirebaseFirestore.instance.collection('user_cards') .doc();
          router.push(
            RouterUtils.getNewCardPath(),
            extra: UserCard(
              userId: userId,
              localImgPath: "",
              names: <String, String>{},
              updatedAt: DateTime.now(),
              remoteImgPath: "",
              remoteId: docRef.id
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
