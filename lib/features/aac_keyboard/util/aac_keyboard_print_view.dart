import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';
import 'package:aut_toolkit/features/aac_keyboard/ui/view/aac_keyboard_tile.dart';
import 'package:flutter/material.dart';

class KeyboardPrintView extends StatelessWidget {
  final AACKeyboard keyboard;
  final bool useColor;
  final bool showTitle;

  const KeyboardPrintView({
    super.key,
    required this.keyboard,
    this.showTitle = true,
    required this.useColor
  });

  KeyboardSlot? _slotAt(int x, int y) {
    try {
      return keyboard.slots.firstWhere((s) => s.x == x && s.y == y);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = keyboard.rows;
    final cols = keyboard.cols;

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (showTitle) ...[
              Text(
                keyboard.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tileW = constraints.maxWidth / cols;
                  final tileH = constraints.maxHeight / rows;

                  return SizedBox.expand(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        childAspectRatio: tileW / tileH,
                      ),
                      itemCount: rows * cols,
                      itemBuilder: (context, index) {
                        final x = index % cols;
                        final y = index ~/ cols;
                        final slot = _slotAt(x, y);

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: SizedBox.expand(
                              child: AACKeyboardTile(slot: slot, useColor: this.useColor,),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
