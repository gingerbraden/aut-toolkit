import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../card_management/domain/model/user_card.dart';
import '../../domain/model/visual_list.dart';
import '../viewmodel/visual_list_schedule_show_viewmodel.dart';

class VisualListScheduleShow extends ConsumerStatefulWidget {
  final VisualList visualList;

  const VisualListScheduleShow({super.key, required this.visualList});

  @override
  _VisualListScheduleShowState createState() => _VisualListScheduleShowState();
}

class _VisualListScheduleShowState
    extends ConsumerState<VisualListScheduleShow> {
  final ScrollController bottomScrollController = ScrollController();
  final GlobalKey<AnimatedListState> topListKey = GlobalKey();
  final GlobalKey<AnimatedListState> bottomListKey = GlobalKey();

  void _onCheckPressed() {
    final vm = ref.read(visualListScheduleProvider(widget.visualList).notifier);
    final state = ref.read(visualListScheduleProvider(widget.visualList));
    final prevMiddle = state.middleCard;
    final currentTopListLength = state.topList.length;

    if (prevMiddle == null) return;

    if (currentTopListLength > 0) {
      final removedCard = state.topList[0];
      topListKey.currentState!.removeItem(
        0,
        (context, animation) => _buildCard(
          removedCard,
          animation,
          false,
          orderNumber: vm.getOrderNumber(removedCard),
        ),
        duration: const Duration(milliseconds: 300),
      );
    }

    vm.moveMiddleToBottom();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bottomListKey.currentState != null) {
        final newBottomList = ref
            .read(visualListScheduleProvider(widget.visualList))
            .bottomList;
        final newIndex = newBottomList.length - 1;
        bottomListKey.currentState!.insertItem(
          newIndex,
          duration: const Duration(milliseconds: 300),
        );

        Future.delayed(const Duration(milliseconds: 400), () {
          if (bottomScrollController.hasClients) {
            bottomScrollController.animateTo(
              bottomScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  Widget _buildCard(
    UserCard card,
    Animation<double> animation,
    bool isMiddle, {
    int? orderNumber,
    double sizeScale = 0.7,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: _cardWidget(
          card,
          isMiddle,
          orderNumber: orderNumber,
          sizeScale: sizeScale,
        ),
      ),
    );
  }

  Widget _cardWidget(
    UserCard card,
    bool isMiddle, {
    Key? key,
    int? orderNumber,
    double sizeScale = 0.9,
  }) {
    final vm = ref.read(visualListScheduleProvider(widget.visualList).notifier);
    final displayOrder = orderNumber ?? vm.getOrderNumber(card);
    return Card(
      key: key,
      child: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "#$displayOrder",
              style: TextStyle(
                fontSize: isMiddle ? 20 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card.names[LocaleSettings.currentLocale.languageCode] ?? '',
              style: TextStyle(
                fontSize: isMiddle ? 25 * sizeScale : 20 * sizeScale,
                fontWeight: isMiddle ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (card.localImgPath.isNotEmpty)
              SizedBox(
                width: 80 * sizeScale,
                height: 80 * sizeScale,
                child: Image.file(
                  File(card.localImgPath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visualListScheduleProvider(widget.visualList));
    final topList = state.topList;
    final bottomList = state.bottomList;
    final middleCard = state.middleCard;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.visualList.name),
        actions: [
          if (bottomList.length == widget.visualList.steps.length)
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: () async => _resetAnimated(),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.BASE_APP_UI_PADDING),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: AnimatedList(
                key: topListKey,
                scrollDirection: Axis.horizontal,
                initialItemCount: topList.length,
                itemBuilder: (context, index, animation) {
                  return _buildCard(
                    topList[index],
                    animation,
                    false,
                    orderNumber: ref
                        .read(
                          visualListScheduleProvider(
                            widget.visualList,
                          ).notifier,
                        )
                        .getOrderNumber(topList[index]),
                  );
                },
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: bottomList.length != widget.visualList.steps.length
                        ? _cardWidget(
                            middleCard!,
                            true,
                            key: ValueKey('middle-${middleCard.id}'),
                            sizeScale: 1.8,
                          )
                        : Center(
                            key: const ValueKey('done-text'),
                            child: Text(t.done),
                          ),
                  ),
                  const SizedBox(height: 16),
                  if (bottomList.length != widget.visualList.steps.length)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                      onPressed: _onCheckPressed,
                      child: const Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(
              height: 150,
              child: AnimatedList(
                key: bottomListKey,
                scrollDirection: Axis.horizontal,
                controller: bottomScrollController,
                initialItemCount: bottomList.length,
                itemBuilder: (context, index, animation) {
                  return _buildCard(bottomList[index], animation, false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetAnimated() async {
    final vm = ref.read(visualListScheduleProvider(widget.visualList).notifier);

    final currentState = ref.read(
      visualListScheduleProvider(widget.visualList),
    );

    final bottomList = List<UserCard>.from(currentState.bottomList);
    final topList = List<UserCard>.from(currentState.topList);

    for (int i = bottomList.length - 1; i >= 0; i--) {
      final card = bottomList[i];
      bottomListKey.currentState!.removeItem(
        i,
        (context, animation) => _buildCard(card, animation, false),
        duration: const Duration(milliseconds: 200),
      );
      await Future.delayed(const Duration(milliseconds: 80));
    }

    for (int i = topList.length - 1; i >= 0; i--) {
      final card = topList[i];
      topListKey.currentState!.removeItem(
        i,
        (context, animation) => _buildCard(card, animation, false),
        duration: const Duration(milliseconds: 200),
      );
      await Future.delayed(const Duration(milliseconds: 80));
    }

    vm.reset();

    await Future.delayed(const Duration(milliseconds: 50));

    final resetTopList = ref
        .read(visualListScheduleProvider(widget.visualList))
        .topList;

    for (int i = 0; i < resetTopList.length; i++) {
      topListKey.currentState!.insertItem(
        i,
        duration: const Duration(milliseconds: 200),
      );
      await Future.delayed(const Duration(milliseconds: 80));
    }
  }
}
