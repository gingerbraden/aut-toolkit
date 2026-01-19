import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/model/sync_entity.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../i18n/strings.g.dart';
import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/aac_keyboard.dart';

class AACKeyboardState {
  final AACKeyboard currentKeyboard;
  final List<AACKeyboard> keyboardStack;

  final int rows;
  final int columns;

  final List<KeyboardSlot> slots;
  final List<UserCard> pressedCards;

  final bool locked;

  AACKeyboardState({
    required this.currentKeyboard,
    required this.keyboardStack,
    required this.rows,
    required this.columns,
    required this.slots,
    required this.pressedCards,
    this.locked = true,
  });

  AACKeyboardState copyWith({
    AACKeyboard? currentKeyboard,
    List<AACKeyboard>? keyboardStack,
    int? rows,
    int? columns,
    List<KeyboardSlot>? slots,
    List<UserCard>? pressedCards,
    bool? locked,
  }) {
    return AACKeyboardState(
      currentKeyboard: currentKeyboard ?? this.currentKeyboard,
      keyboardStack: keyboardStack ?? this.keyboardStack,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      slots: slots ?? this.slots,
      pressedCards: pressedCards ?? this.pressedCards,
      locked: locked ?? this.locked,
    );
  }
}

class AACKeyboardViewModel extends StateNotifier<AACKeyboardState> {
  AACKeyboardViewModel({
    required AACKeyboard rootKeyboard,
    required int initialRows,
    required int initialColumns,
  }) : super(
         AACKeyboardState(
           currentKeyboard: rootKeyboard,
           keyboardStack: [],
           rows: initialRows,
           columns: initialColumns,
           slots: rootKeyboard.slots,
           pressedCards: [],
         ),
       );

  void onSlotPressed(KeyboardSlot slot) {
    if (slot.keyboard != null) {
      _openNestedKeyboard(slot.keyboard!);
      return;
    }

    final card = slot.card;
    if (card == null) return;

    final updated = List<UserCard>.from(state.pressedCards)..add(card);
    state = state.copyWith(pressedCards: updated);

    final textToSpeak =
        card.names[LocaleSettings.currentLocale.languageCode] ??
        card.names.values.firstOrNull ??
        '';

    if (textToSpeak.isNotEmpty) {
      TtsService.speak(textToSpeak);
    }
  }

  void onPressedBarPressed() {
    var textToSpeak = "";

    for (UserCard uc in state.pressedCards) {
      textToSpeak +=
          uc.names[LocaleSettings.currentLocale.languageCode] ??
          uc.names.values.firstOrNull ??
          '';
      textToSpeak += " ";
    }

    if (textToSpeak.isNotEmpty) {
      TtsService.speak(textToSpeak);
    }
  }

  void _openNestedKeyboard(AACKeyboard keyboard) {
    state = state.copyWith(
      keyboardStack: [...state.keyboardStack, state.currentKeyboard],
      currentKeyboard: keyboard,
      slots: keyboard.slots,
    );
  }

  bool get canGoBack => state.keyboardStack.isNotEmpty;

  void goBack() {
    if (!canGoBack) return;

    final stack = List<AACKeyboard>.from(state.keyboardStack);
    final previous = stack.removeLast();

    state = state.copyWith(
      currentKeyboard: previous,
      keyboardStack: stack,
      slots: previous.slots,
    );
  }

  void clearPressedCards() {
    state = state.copyWith(pressedCards: []);
  }

  void clearLastCard() {
    if (state.pressedCards.isNotEmpty) {
      state = state.copyWith(
        pressedCards: state.pressedCards.sublist(
          0,
          state.pressedCards.length - 1,
        ),
      );
    }
  }

  void updateGridSize({required int rows, required int columns}) {
    state = state.copyWith(rows: rows, columns: columns);
  }

  KeyboardSlot? slotAt(int x, int y) {
    try {
      return state.slots.firstWhere((s) => s.x == x && s.y == y);
    } catch (_) {
      return null;
    }
  }

  void assignCardToPosition({
    required int x,
    required int y,
    required UserCard card,
  }) {
    final updatedSlots = state.slots.map((s) {
      if (s.x == x && s.y == y) {
        return KeyboardSlot(
          id: s.id,
          x: s.x,
          y: s.y,
          card: card,
          keyboard: null,
          remoteId: s.remoteId,
          updatedAt: DateTime.now(),
          isSynced: false,
          isDeleted: false,
          pendingAction: PendingAction.UPDATE,
        );
      }
      return s;
    }).toList();

    final exists = state.slots.any((s) => s.x == x && s.y == y);
    if (!exists) {
      updatedSlots.add(
        KeyboardSlot(
          x: x,
          y: y,
          card: card,
          keyboard: null,
          updatedAt: DateTime.now(),
          isSynced: false,
          isDeleted: false,
          pendingAction: PendingAction.CREATE,
        ),
      );
    }

    state = state.copyWith(slots: updatedSlots);
  }

  bool get isLocked => state.locked;

  void setLocked(bool value) {
    state = state.copyWith(locked: value);
  }

  void toggleLocked() {
    state = state.copyWith(locked: !state.locked);
  }
}

final aacKeyboardProvider =
    StateNotifierProvider.family<
      AACKeyboardViewModel,
      AACKeyboardState,
      AACKeyboard
    >((ref, rootKeyboard) {
      return AACKeyboardViewModel(
        rootKeyboard: rootKeyboard,
        initialRows: 4,
        initialColumns: 4,
      );
    });
