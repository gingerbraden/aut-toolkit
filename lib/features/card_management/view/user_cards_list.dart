import 'dart:io';

import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/square_items_list.dart';

class UserCardsList extends ConsumerStatefulWidget {
  const UserCardsList({super.key});

  @override
  ConsumerState<UserCardsList> createState() => _UserCardsListState();
}

class _UserCardsListState extends ConsumerState<UserCardsList> {

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardsProvider);
    return SquareItemsList<UserCard>(
      title: t.cards,
      items: cards,
      searchKey: (item) => item.names[LocaleSettings.currentLocale.languageCode]!,
      itemBuilder: (item) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Card(
          elevation: 0,
          child: Center(child: Padding(
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
                          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(item.names[LocaleSettings.currentLocale.languageCode]!, style: Theme.of(context).textTheme.titleLarge,),
                ),
              ],
            ),
          )),
        ),
      ),
      onTap: (item) => router.push(RouterUtils.getCardDetailPath(), extra: item),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
            router.push(RouterUtils.getNewCardPath(), extra: UserCard(userId: FirebaseAuth.instance.currentUser!.uid, localImgPath: "", names: <String, String>{}));
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
