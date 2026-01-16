import 'package:flutter/material.dart';

import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/keyboad_slot.dart';
import 'aac_keyboard_grid_tile.dart';

class PressedBar extends StatelessWidget {
  final List<UserCard> pressedCards;
  final VoidCallback onClear;

  const PressedBar({
    super.key,
    required this.pressedCards,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: pressedCards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 0),
              itemBuilder: (context, index) {
                final card = pressedCards[index];

                final slotForDisplay = KeyboardSlot(
                  x: index,
                  y: 0,
                  card: card,
                  updatedAt: DateTime.now(),
                );

                return IgnorePointer(
                  child: SizedBox(
                    width: 90,
                    child: AACKeyboardTile(slot: slotForDisplay),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.backspace),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
