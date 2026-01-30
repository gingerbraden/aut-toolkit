import 'dart:async';

import 'package:aut_toolkit/core/constants/app_constants.dart';
import 'package:aut_toolkit/features/aac_keyboard/util/aac_keyboard_print_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../i18n/strings.g.dart';
import '../viewmodel/aac_keyboard_viewmodel.dart';
import 'aac_keyboard_grid.dart';
import 'aac_keyboard_pressed_bar.dart';
import 'aac_keyboard_qwerty.dart';
import 'aac_keyboard_settings.dart';

class AACKeyboardMain extends ConsumerStatefulWidget {
  final VoidCallback goHome;

  const AACKeyboardMain({super.key, required this.goHome});

  @override
  ConsumerState<AACKeyboardMain> createState() => _AACKeyboardMainState();
}

class _AACKeyboardMainState extends ConsumerState<AACKeyboardMain> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _cancelUnlockTimers(context);
    super.dispose();
  }

  Timer? _unlockTimer;
  Timer? _countdownTimer;

  static const int _unlockHoldSeconds = 5;
  int _secondsLeft = _unlockHoldSeconds;

  bool _rightHeld = false;

  void _showCountdownSnackBar(BuildContext context) {
    if (!mounted) return;

    final msg = _secondsLeft == 1 && _secondsLeft >= 1
        ? t.unlocking
        : "${t.hold_to_unlock} $_secondsLeft ${t.second(n: _secondsLeft)}";

    if (_secondsLeft < 1) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(milliseconds: 500),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _hideCountdownSnackBar(BuildContext context) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _cancelUnlockTimers(BuildContext context) {
    _unlockTimer?.cancel();
    _unlockTimer = null;

    _countdownTimer?.cancel();
    _countdownTimer = null;

    _secondsLeft = _unlockHoldSeconds;
  }

  void _startUnlockTimerIfReady(BuildContext context, void Function() unlock) {
    if (!_rightHeld) return;

    _cancelUnlockTimers(context);
    _secondsLeft = _unlockHoldSeconds;

    _showCountdownSnackBar(context);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_rightHeld) {
        _cancelUnlockTimers(context);
        return;
      }

      _secondsLeft = (_secondsLeft - 1).clamp(0, _unlockHoldSeconds);
      _showCountdownSnackBar(context);

      if (_secondsLeft <= 0) {
        t.cancel();
        _countdownTimer = null;
      }
    });

    _unlockTimer = Timer(Duration(seconds: _unlockHoldSeconds), () {
      if (_rightHeld && mounted) {
        HapticFeedback.mediumImpact();
        _hideCountdownSnackBar(context);
        unlock();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aacMainKeyboardProvider);
    final vm = ref.read(aacMainKeyboardProvider.notifier);

    if (state.isLoading || state.currentKeyboard == null)
      return Center(child: CircularProgressIndicator());

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        leading: !state.locked
            ? IconButton(onPressed: widget.goHome, icon: Icon(Icons.arrow_back))
            : null,
        actions: [
          GestureDetector(
            onLongPressStart: (_) {
              if (state.locked) {
                _rightHeld = true;
                _startUnlockTimerIfReady(context, () => vm.toggleLocked());
              }
            },
            onLongPressEnd: (_) {
              _rightHeld = false;
              _cancelUnlockTimers(context);
            },
            child: IconButton(
              icon: state.locked ? Icon(Icons.lock) : Icon(Icons.lock_open),
              onPressed: () {
                if (!state.locked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.locking),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  vm.toggleLocked();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${t.to_unlock_hold} $_secondsLeft ${t.second(n: _unlockHoldSeconds)}",
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),
          if (!state.locked)
            GridSettingsMenu(
              rows: state.rows,
              columns: state.columns,
              onChanged: (r, c) => vm.updateGridSize(rows: r, columns: c),
            ),
          if (!state.locked)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () async {
                final kb = state.currentKeyboard;
                if (kb == null) return;

                await runWithLoading(context, () async {
                  final file = await AACKeyboardPrintUtil.exportToA4PdfRaster(
                    root: kb,
                    theme: Theme.of(context),
                    pixelRatio: 3.5,
                    showTitle: true,
                  );

                  await AACKeyboardPrintUtil.shareWithSharePlus(file);

                  debugPrint('PDF saved: ${file.path}');
                });
              },
            ),
        ],
      ),
      body: !isLandscape
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: AppConstants.BASE_APP_UI_PADDING * 2,
              ),
              child: Column(
                children: [
                  if (state.inputMode == KeyboardInputMode.aacGrid)
                    InkWell(
                      onTap: vm.onPressedBarPressed,
                      child: PressedBar(
                        pressedCards: state.pressedCards,
                        onClear: vm.clearPressedCards,
                        onClearLast: vm.clearLastCard,
                        onSwitchToQwerty: vm.switchKb,
                      ),
                    ),
                  if (state.inputMode == KeyboardInputMode.aacGrid)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppConstants.BASE_APP_UI_PADDING,
                        horizontal: AppConstants.BASE_APP_UI_PADDING * 2,
                      ),
                      child: SizedBox(
                        height: 22,
                        child: state.keyboardStack.isNotEmpty
                            ? Row(
                                children: [
                                  IconButton(
                                    onPressed: vm.goBack,
                                    icon: const Icon(Icons.arrow_back),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Divider(height: 1, thickness: 1),
                                  ),
                                ],
                              )
                            : const Divider(height: 1, thickness: 1),
                      ),
                    ),
                  Expanded(
                    child: state.inputMode == KeyboardInputMode.aacGrid
                        ? KeyboardGrid(
                            rows: state.rows,
                            columns: state.columns,
                            slotBuilder: vm.slotAt,
                            onSlotPressed: vm.onSlotPressed,
                            onAssignCard: (x, y, card) =>
                                vm.assignCardToPosition(x: x, y: y, card: card),
                            onCreateFolder: (x, y, name, coverCard) =>
                                vm.assignFolderToPosition(
                                  x: x,
                                  y: y,
                                  name: name,
                                  coverCard: coverCard,
                                ),
                            onDelete: (x, y) => vm.deleteSlot(x: x, y: y),
                            keyboard: state.currentKeyboard!,
                          )
                        : QwertyKeyboard(
                            typedText: state.typedText,
                            onClose: vm.switchKb,
                            onKey: (k) {
                              switch (k) {
                                case '{backspace}':
                                  vm.backspaceTyped();
                                  return;
                                case '{clear}':
                                  vm.clearTyped();
                                  return;
                                case '{acute}':
                                  vm.applyAcute();
                                  return;
                                case '{caron}':
                                  vm.applyCaron();
                                  return;
                                default:
                                  vm.typeText(k);
                              }
                            },
                            onSpeak: vm.speakTyped,
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<T> runWithLoading<T>(
    BuildContext context,
    Future<T> Function() task,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 260,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 20),
              Text(t.preparing_pdf),
            ],
          ),
        ),
      ),
    );

    try {
      return await task();
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
