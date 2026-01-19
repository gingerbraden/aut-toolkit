import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/keyboad_slot.dart';
import 'aac_keyboard_grid_tile.dart';

class PressedBar extends StatefulWidget {
  final List<UserCard> pressedCards;
  final VoidCallback onClear;
  final VoidCallback onClearLast;

  const PressedBar({
    super.key,
    required this.pressedCards,
    required this.onClear,
    required this.onClearLast,
  });

  @override
  State<PressedBar> createState() => _PressedBarState();
}

class _PressedBarState extends State<PressedBar> {
  final _controller = ScrollController();

  @override
  void didUpdateWidget(covariant PressedBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pressedCards.length > oldWidget.pressedCards.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.BASE_APP_UI_PADDING,
      ),
      child: SizedBox(
        height: 130,
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 0,
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  itemCount: widget.pressedCards.length,
                  itemBuilder: (context, index) {
                    final card = widget.pressedCards[index];

                    return IgnorePointer(
                      child: SizedBox(
                        width: 90,
                        child: AACKeyboardTile(
                          slot: KeyboardSlot(
                            x: index,
                            y: 0,
                            card: card,
                            updatedAt: DateTime.now(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onClearLast,
                    icon: const Icon(Icons.backspace),
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                  ),
                  SizedBox(width: AppConstants.BASE_APP_UI_PADDING),
                  IconButton(
                    onPressed: widget.onClear,
                    icon: const Icon(Icons.clear),
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
