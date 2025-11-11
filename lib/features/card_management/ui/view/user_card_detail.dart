import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/divider/sized_box_divider.dart';
import 'package:aut_toolkit/core/widgets/square_image_filled_width.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/user_card_detail_viewmodel.dart';

class UserCardDetail extends ConsumerWidget {
  const UserCardDetail({super.key, required this.card});

  final UserCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(userCardDetailViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.detail),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => viewModel.confirmDelete(context, card),
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
}
