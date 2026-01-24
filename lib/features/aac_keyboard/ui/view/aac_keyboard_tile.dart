import 'package:aut_toolkit/features/aac_keyboard/ui/view/aac_keyboard_keyboard_tile.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/card_util.dart';
import '../../domain/model/keyboad_slot.dart';
import 'aac_keyboard_image_tile.dart';

class AACKeyboardTile extends StatelessWidget {
  final KeyboardSlot? slot;

  const AACKeyboardTile({
    super.key,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: slot?.card != null
          ? CardUtil.getColorForWordCat(slot!.card!.wordCategory!)
          : slot?.keyboard != null
          ? Colors.blue.shade50
          : null,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: slot?.keyboard != null
              ? KeyboardTileContent(
            name: slot!.keyboard!.name,
          )
              : slot?.card != null
              ? CardTileContent(card: slot!.card!)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
