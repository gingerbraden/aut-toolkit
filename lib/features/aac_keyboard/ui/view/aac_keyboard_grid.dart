import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/aac_keyboard/ui/view/aac_keyboard_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/keyboad_slot.dart';

class KeyboardGrid extends StatelessWidget {
  final int rows;
  final int columns;
  final KeyboardSlot? Function(int x, int y) slotBuilder;
  final void Function(KeyboardSlot slot) onSlotPressed;
  final void Function(int x, int y, UserCard card)? onAssignCard;

  const KeyboardGrid({
    super.key,
    required this.rows,
    required this.columns,
    required this.slotBuilder,
    required this.onSlotPressed,
    this.onAssignCard,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        final x = index % columns;
        final y = index ~/ columns;

        final slot = slotBuilder(x, y);

        return GestureDetector(
          onTap: slot != null ? () => onSlotPressed(slot) : null,
          onLongPress: () {
            context.push(
              RouterUtils.getAACKeyboardCardPickerPath(),
              extra: <String, dynamic>{
                'onSelected': (UserCard selected) {
                  onAssignCard?.call(x, y, selected);
                },
              },
            );
          },
          child: AACKeyboardTile(slot: slot),
        );
      },
    );
  }
}
