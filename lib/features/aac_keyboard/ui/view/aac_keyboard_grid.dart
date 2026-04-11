import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/ui/view/aac_keyboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../i18n/strings.g.dart';
import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/keyboad_slot.dart';
import '../viewmodel/aac_keyboard_viewmodel.dart';

class KeyboardGrid extends ConsumerStatefulWidget {
  final int rows;
  final int columns;
  final AACKeyboard keyboard;
  final KeyboardSlot? Function(int x, int y) slotBuilder;
  final void Function(KeyboardSlot slot) onSlotPressed;
  final void Function(int x, int y, UserCard card)? onAssignCard;
  final void Function(int x, int y)? onDelete;
  final void Function(int x, int y, String folderName, UserCard coverCard)?
  onCreateFolder;

  const KeyboardGrid({
    super.key,
    required this.rows,
    required this.columns,
    required this.slotBuilder,
    required this.onSlotPressed,
    this.onAssignCard,
    this.onDelete,
    this.onCreateFolder,
    required this.keyboard,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyboardGridState();
}

enum _TileDialogAction { addCard, addFolder, deleteCard }

class _KeyboardGridState extends ConsumerState<KeyboardGrid> {
  Future<void> _handleTap({
    required BuildContext context,
    required bool locked,
    required int x,
    required int y,
    required KeyboardSlot? slot,
  }) async {
    final hasCard = slot?.card != null;
    final hasFolder = slot?.keyboard != null;

    if (locked) {
      if (slot == null) return;
      widget.onSlotPressed(slot);
      return;
    }

    if (hasFolder) {
      widget.onSlotPressed(slot!);
      return;
    }

    if (hasCard) {
      await _showAddDialog(context: context, x: x, y: y, showDelete: true);
      return;
    }

    await _showAddDialog(context: context, x: x, y: y, showDelete: false);
  }

  Future<void> _handleLongPress({
    required BuildContext context,
    required bool locked,
    required int x,
    required int y,
    required KeyboardSlot? slot,
  }) async {
    if (locked) return;

    final hasFolder = slot?.keyboard != null;
    if (hasFolder) {
      await _showAddDialog(context: context, x: x, y: y, showDelete: true);
    }
  }

  Future<void> _showAddDialog({
    required BuildContext context,
    required int x,
    required int y,
    required bool showDelete,
  }) async {
    final action = await showDialog<_TileDialogAction>(
      context: context,
      builder: (_) => _AddCardOrFolderDialog(showDelete: showDelete),
    );

    if (!mounted || action == null) return;

    switch (action) {
      case _TileDialogAction.addCard:
        context.push(
          RouterUtils.getAACKeyboardCardPickerPath(),
          extra: <String, dynamic>{
            'onSelected': (UserCard selected) {
              widget.onAssignCard?.call(x, y, selected);
            },
          },
        );
        return;

      case _TileDialogAction.addFolder:
        final folderName = await _promptFolderName(context);
        if (!mounted || folderName == null) return;

        context.push(
          RouterUtils.getAACKeyboardCardPickerPath(),
          extra: <String, dynamic>{
            'onSelected': (UserCard selected) {
              widget.onCreateFolder?.call(x, y, folderName, selected);
            },
          },
        );
        return;
      case _TileDialogAction.deleteCard:
        widget.onDelete?.call(x, y);
        return;
    }
  }

  Future<String?> _promptFolderName(BuildContext context) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.folder_name),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(hintText: t.folder_name_hint),
          onSubmitted: (_) => Navigator.of(context).pop(controller.text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(t.choose_cover_and_save),
          ),
        ],
      ),
    );

    final name = result?.trim();
    if (name == null || name.isEmpty) return null;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aacMainKeyboardProvider);

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
                    onTap: () => _handleTap(
                      context: context,
                      locked: state.locked,
                      x: x,
                      y: y,
                      slot: slot,
                    ),
                    onLongPress: () => _handleLongPress(
                      context: context,
                      locked: state.locked,
                      x: x,
                      y: y,
                      slot: slot,
                    ),
                    child: Ink(child: AACKeyboardTile(slot: slot, useColor: state.useColor, isLocked: state.locked,)),
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

class _AddCardOrFolderDialog extends StatelessWidget {
  final bool showDelete;

  const _AddCardOrFolderDialog({required this.showDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth;
            final spacing = 16.0;
            final buttonWidth = (contentWidth - spacing) / 2;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: buttonWidth,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: _BigSquareAction(
                              icon: Icons.style,
                              label: t.add_card,
                              onTap: () => Navigator.of(
                                context,
                              ).pop(_TileDialogAction.addCard),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          width: buttonWidth,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: _BigSquareAction(
                              icon: Icons.folder,
                              label: t.add_folder,
                              onTap: () => Navigator.of(
                                context,
                              ).pop(_TileDialogAction.addFolder),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (showDelete) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: Text(t.delete),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(_TileDialogAction.deleteCard),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(t.cancel),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BigSquareAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BigSquareAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
            color: scheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: Icon(icon, size: 44)),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
