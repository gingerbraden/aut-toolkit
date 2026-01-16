import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/aac_keyboard.dart';
import '../viewmodel/aac_keyboard_controller.dart';
import 'aac_keyboard_grid.dart';
import 'aac_keyboard_pressed_bar.dart';
import 'aac_keyboard_settings.dart';

class AACKeyboardMain extends ConsumerWidget {
  final AACKeyboard keyboard;

  const AACKeyboardMain({super.key, required this.keyboard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aacKeyboardProvider(keyboard));
    final vm = ref.read(aacKeyboardProvider(keyboard).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.currentKeyboard.name),
        actions: [
          GridSettingsMenu(
            rows: state.rows,
            columns: state.columns,
            onChanged: (r, c) =>
                vm.updateGridSize(rows: r, columns: c),
          ),
        ],
      ),
      body: Column(
        children: [
          PressedBar(
            pressedCards: state.pressedCards,
            onClear: vm.clearPressedCards,
          ),
          Expanded(
            child: KeyboardGrid(
              rows: state.rows,
              columns: state.columns,
              slotBuilder: vm.slotAt,
              onSlotPressed: vm.onSlotPressed,
              onAssignCard: (x, y, card) {
                vm.assignCardToPosition(x: x, y: y, card: card);
              },
            ),
          ),
        ],
      ),
    );
  }
}
