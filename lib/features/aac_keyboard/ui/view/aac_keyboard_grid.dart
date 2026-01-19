import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/ui/view/aac_keyboard_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/keyboad_slot.dart';
import '../viewmodel/aac_keyboard_controller.dart';

class KeyboardGrid extends ConsumerStatefulWidget {
  final int rows;
  final int columns;
  final AACKeyboard keyboard;
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
    required this.keyboard,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyboardGridState();
}

class _KeyboardGridState extends ConsumerState<KeyboardGrid> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aacKeyboardProvider(widget.keyboard));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.BASE_APP_UI_PADDING,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileHeight = constraints.maxHeight / widget.rows;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.columns,
              mainAxisExtent: tileHeight,
            ),
            itemCount: widget.rows * widget.columns,
            itemBuilder: (context, index) {
              final x = index % widget.columns;
              final y = index ~/ widget.columns;
              final slot = widget.slotBuilder(x, y);

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (!state.locked) {
                        context.push(
                          RouterUtils.getAACKeyboardCardPickerPath(),
                          extra: <String, dynamic>{
                            'onSelected': (UserCard selected) {
                              widget.onAssignCard?.call(x, y, selected);
                            },
                          },
                        );
                        return;
                      }

                      if (slot != null) {
                        widget.onSlotPressed(slot);
                      }
                    },
                    child: Ink(child: AACKeyboardTile(slot: slot)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
