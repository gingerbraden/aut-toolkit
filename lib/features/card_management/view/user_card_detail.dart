import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/widgets/square_image_filled_width.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/features/card_management/provider/card_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/router_utils.dart';
import '../../../core/widgets/divider/sized_box_divider.dart';
import '../../../i18n/strings.g.dart';

class UserCardDetail extends ConsumerStatefulWidget {
  const UserCardDetail({super.key, required this.card});

  final UserCard card;

  @override
  ConsumerState<UserCardDetail> createState() => _UserCardDetailState();
}

class _UserCardDetailState extends ConsumerState<UserCardDetail> {
  @override
  Widget build(BuildContext context) {
    final card = widget.card;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.detail),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(RouterUtils.getEditCardPath(), extra: card);
        },
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    card.names[LocaleSettings.currentLocale.languageCode] ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBoxDivider(),
                  SquareImageFilledWidth(imageFilePath: card.localImgPath),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
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
      ref.read(cardsProvider.notifier).deleteCard(widget.card);
      router.pop();
    }
  }
}
