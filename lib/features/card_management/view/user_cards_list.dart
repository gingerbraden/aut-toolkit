import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/square_items_list.dart';

enum _IconChoice {
  custom,
  arasaac,
}

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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(item.names[LocaleSettings.currentLocale.languageCode]!)),
      ),
      onTap: (item) => print('Tapped: ${item.names[LocaleSettings.currentLocale.languageCode]!}'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<_IconChoice>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(t.create_card),
              content: Text(t.create_card_decision),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, _IconChoice.custom),
                  child: Text(t.from_gallery),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, _IconChoice.arasaac),
                  child: Text(t.arasaac_icons),
                ),
              ],
            ),
          );

          if (result == _IconChoice.arasaac) {
            router.push(RouterUtils.getCardsAddARASAACPath());
          } else if (result == _IconChoice.custom) {
            router.push(RouterUtils.getCardsAddARASAACPath());
          }
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
