import 'dart:io';

import 'package:aut_toolkit/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/core/widgets/square_items_list.dart';
import 'package:aut_toolkit/features/card_management/domain/model/user_card.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/card_printing_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/widgets/pdf_generating_dialog.dart';
import '../viewmodel/user_cards_list_viewmodel.dart';

class UserCardsList extends ConsumerWidget {
  const UserCardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(filteredUserCardsProvider);
    final viewModel = ref.watch(userCardsListViewModelProvider.notifier);
    ref.watch(userCardsListViewModelProvider);

    final isSelectionMode = viewModel.isSelectionMode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setCards(cards);
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (pop, result) {
        viewModel.clearSelection();
      },
      child: SquareItemsList<UserCard>(
        title: t.cards,
        items: cards,
        searchKey: (item) =>
            item.names[LocaleSettings.currentLocale.languageCode] ?? '',
        itemBuilder: (item) {
          final isSelected = viewModel.isSelected(item);

          return GestureDetector(
            onLongPress: () {
              viewModel.startSelection(item);
            },
            onTap: () {
              if (isSelectionMode) {
                viewModel.toggleSelection(item);
              } else {
                router.push(RouterUtils.getCardDetailPath(), extra: item);
              }
            },
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.15)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
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
                                item.names[LocaleSettings
                                        .currentLocale
                                        .languageCode] ??
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

                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: AnimatedScale(
                      scale: isSelected ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        onTap: (item) =>
            router.push(RouterUtils.getCardDetailPath(), extra: item),
        floatingActionButton: isSelectionMode
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "cancelSelection",
                    backgroundColor: Colors.redAccent,
                    onPressed: () {
                      viewModel.clearSelection();
                    },
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 12),

                  if (viewModel.selectedIds.length != cards.length)
                    FloatingActionButton(
                      heroTag: "selectAll",
                      onPressed: () {
                        if (viewModel.selectedIds.length == cards.length) {
                          viewModel.clearSelection();
                        } else {
                          viewModel.selectAll(cards);
                        }
                      },
                      child: Icon(
                        viewModel.selectedIds.length == cards.length
                            ? Icons.remove_done
                            : Icons.select_all,
                      ),
                    ),
                  if (viewModel.selectedIds.length != cards.length)
                    const SizedBox(width: 12),

                  FloatingActionButton(
                    heroTag: "printSelection",
                    onPressed: () async {
                      final cardsPerRow = await _showCardsPerRowDialog(context);
                      if (cardsPerRow == null) return;

                      await PdfGeneratingWaitingDialog.show(
                        context,
                        message: t.preparing_pdf,
                      );

                      try {
                        await CardPrintingService()
                            .generateAndShareSelectedCardsPdf(
                              viewModel.selectedCards,
                              cardsPerRow: cardsPerRow,
                            );
                      } finally {
                        PdfGeneratingWaitingDialog.hide(context);
                        viewModel.clearSelection();
                      }
                    },
                    child: const Icon(Icons.picture_as_pdf),
                  ),
                ],
              )
            : FloatingActionButton(
                onPressed: () {
                  final userId = FirebaseService().currentUser?.uid;
                  if (userId == null) return;

                  final docRef = FirebaseFirestore.instance
                      .collection('user_cards')
                      .doc();

                  router.push(
                    RouterUtils.getNewCardPath(),
                    extra: UserCard(
                      userId: userId,
                      localImgPath: "",
                      names: <String, String>{},
                      updatedAt: DateTime.now(),
                      remoteImgPath: "",
                      remoteId: docRef.id,
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  Future<int?> _showCardsPerRowDialog(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.choose_layout),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.two_large),
                onTap: () => Navigator.pop(context, 2),
              ),
              ListTile(
                title: Text(t.four_medium),
                onTap: () => Navigator.pop(context, 4),
              ),
              ListTile(
                title: Text(t.six_small),
                onTap: () => Navigator.pop(context, 6),
              ),
            ],
          ),
        );
      },
    );
  }
}
