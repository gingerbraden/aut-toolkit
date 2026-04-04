import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';
import 'package:aut_toolkit/features/aac_keyboard/provider/aac_keyboard_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/model/sync_entity.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../i18n/strings.g.dart';
import '../../../card_management/domain/model/user_card.dart';
import '../../domain/model/aac_keyboard.dart';

class AACKeyboardState {
  final AACKeyboard? currentKeyboard;
  final List<AACKeyboard> keyboardStack;

  final int rows;
  final int columns;

  final List<UserCard> pressedCards;

  final bool locked;
  final bool isLoading;

  final KeyboardInputMode inputMode;
  final String typedText;

  final bool useColor;

  AACKeyboardState({
    required this.currentKeyboard,
    required this.keyboardStack,
    required this.rows,
    required this.columns,
    required this.pressedCards,
    required this.useColor,
    this.locked = true,
    this.isLoading = true,

    this.inputMode = KeyboardInputMode.aacGrid,
    this.typedText = '',
  });

  AACKeyboardState copyWith({
    AACKeyboard? currentKeyboard,
    List<AACKeyboard>? keyboardStack,
    int? rows,
    int? columns,
    List<UserCard>? pressedCards,
    bool? locked,
    bool? isLoading,
    bool? useColor,
    KeyboardInputMode? inputMode,
    String? typedText,
  }) {
    return AACKeyboardState(
      currentKeyboard: currentKeyboard ?? this.currentKeyboard,
      keyboardStack: keyboardStack ?? this.keyboardStack,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      pressedCards: pressedCards ?? this.pressedCards,
      locked: locked ?? this.locked,
      isLoading: isLoading ?? this.isLoading,
      useColor: useColor ?? this.useColor,
      inputMode: inputMode ?? this.inputMode,
      typedText: typedText ?? this.typedText,
    );
  }
}

enum KeyboardInputMode { aacGrid, qwerty }

enum _Diacritic { acute, caron }

class AACKeyboardViewModel extends StateNotifier<AACKeyboardState> {
  final Ref ref;

  AACKeyboardViewModel(
    this.ref, {
    required int initialRows,
    required int initialColumns,
  }) : super(
         AACKeyboardState(
           currentKeyboard: null,
           keyboardStack: [],
           rows: initialRows,
           columns: initialColumns,
           pressedCards: [],
           inputMode: KeyboardInputMode.aacGrid,
           typedText: '',
           useColor: true
         ),
       ) {
    Future.microtask(_ensureKeyboardLoaded);
  }

  Future<void> _ensureKeyboardLoaded() async {
    state = state.copyWith(isLoading: true);

    final prefs = await SharedPreferences.getInstance();

    final useColorFromPrefs = prefs.getBool('useColor');

    final userId = FirebaseService().currentUser!.uid;
    final existing = await ref
        .read(aacKeyboardsProvider.notifier)
        .getSelectedKeyboardForUser(userId);

    if (existing != null) {
      state = state.copyWith(
        currentKeyboard: existing,
        isLoading: false,
        rows: existing.rows,
        columns: existing.cols,
        useColor: useColorFromPrefs ?? true
      );
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('aac_keyboards').doc();

    final created = AACKeyboard(
      id: 0,
      userId: userId,
      name: "Klavesnica main",
      slots: const [],
      updatedAt: DateTime.now(),
      isInternal: false,
      remoteId: docRef.id,
      isSelected: true,
      rows: 5,
      cols: 5,
    );

    final id = ref.read(aacKeyboardsProvider.notifier).addKeyboard(created);

    final saved = ref.read(aacKeyboardsProvider.notifier).getKeyboard(id);

    state = state.copyWith(currentKeyboard: saved, isLoading: false);
  }

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
      keyboardStack: [...state.keyboardStack, state.currentKeyboard!],
      currentKeyboard: keyboard,
    );
  }

  bool get canGoBack => state.keyboardStack.isNotEmpty;

  void goBack() {
    if (!canGoBack) return;

    final stack = List<AACKeyboard>.from(state.keyboardStack);
    final previous = stack.removeLast();

    state = state.copyWith(currentKeyboard: previous, keyboardStack: stack);
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

  Future<void> updateGridSize({required int rows, required int columns}) async {
    final kb = state.currentKeyboard;
    if (kb == null) return;

    final updatedKb = kb.copyWith(
      rows: rows,
      cols: columns,
      updatedAt: DateTime.now(),
      isSynced: false,
      pendingAction: PendingAction.UPDATE,
    );

    state = state.copyWith(
      rows: rows,
      columns: columns,
      currentKeyboard: updatedKb,
    );
    _bubbleCurrentKeyboardUpStack();
    ref.read(aacKeyboardsProvider.notifier).updateKeyboard(updatedKb);
  }

  KeyboardSlot? slotAt(int x, int y) {
    try {
      return state.currentKeyboard!.slots.firstWhere(
        (s) => s.x == x && s.y == y,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> updateUseColor({required bool useColor}) async {
    state = state.copyWith(
      useColor: useColor,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('useColor', useColor);
  }

  Future<void> assignCardToPosition({
    required int x,
    required int y,
    required UserCard card,
  }) async {
    KeyboardSlot? updatedSlot;

    final updatedSlots = state.currentKeyboard!.slots.map((s) {
      if (s.x == x && s.y == y) {
        final newSlot = KeyboardSlot(
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
        updatedSlot = newSlot;
        return newSlot;
      }
      return s;
    }).toList();

    final exists = state.currentKeyboard!.slots.any(
      (s) => s.x == x && s.y == y,
    );

    if (!exists) {
      final uuid = const Uuid();

      final newSlot = KeyboardSlot(
        x: x,
        y: y,
        card: card,
        keyboard: null,
        updatedAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
        pendingAction: PendingAction.CREATE,
        remoteId: uuid.v4(),
      );
      updatedSlot = newSlot;
      updatedSlots.add(newSlot);
    }

    final updatedKeyboard = state.currentKeyboard!.copyWith(
      slots: updatedSlots,
    );

    state = state.copyWith(currentKeyboard: updatedKeyboard);
    _bubbleCurrentKeyboardUpStack();
    ref
        .read(aacKeyboardsProvider.notifier)
        .updateSlot(updatedSlot!, state.currentKeyboard!.id!);

    final kbId = state.currentKeyboard!.id!;
    final refreshed = ref.read(aacKeyboardsProvider.notifier).getKeyboard(kbId);
    if (refreshed != null) {
      state = state.copyWith(currentKeyboard: refreshed);
      _bubbleCurrentKeyboardUpStack();
    }
  }

  Future<void> assignFolderToPosition({
    required int x,
    required int y,
    required String name,
    required UserCard coverCard,
  }) async {
    final docRefKeyb = FirebaseFirestore.instance
        .collection('aac_keyboards')
        .doc();

    final folderDraft = AACKeyboard(
      id: 0,
      userId: FirebaseService().currentUser!.uid,
      name: name,
      slots: const [],
      updatedAt: DateTime.now(),
      isInternal: true,
      remoteId: docRefKeyb.id,
      isSelected: false,
      rows: 5,
      cols: 5,
    );

    final folderId = ref
        .read(aacKeyboardsProvider.notifier)
        .addKeyboard(folderDraft);
    final folderSaved = ref
        .read(aacKeyboardsProvider.notifier)
        .getKeyboard(folderId);

    if (folderSaved == null) {
      throw StateError('Folder keyboard was not persisted (id=$folderId).');
    }

    KeyboardSlot? updatedSlot;

    final updatedSlots = state.currentKeyboard!.slots.map((s) {
      if (s.x == x && s.y == y) {
        final newSlot = KeyboardSlot(
          id: s.id,
          x: s.x,
          y: s.y,
          card: coverCard,
          keyboard: folderSaved,
          remoteId: s.remoteId,
          updatedAt: DateTime.now(),
          isSynced: false,
          isDeleted: false,
          pendingAction: PendingAction.UPDATE,
        );
        updatedSlot = newSlot;
        return newSlot;
      }
      return s;
    }).toList();

    const uuid = Uuid();

    final exists = state.currentKeyboard!.slots.any(
      (s) => s.x == x && s.y == y,
    );
    if (!exists) {
      final newSlot = KeyboardSlot(
        x: x,
        y: y,
        card: coverCard,
        keyboard: folderSaved,
        updatedAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
        pendingAction: PendingAction.CREATE,
        remoteId: uuid.v4(),
      );
      updatedSlot = newSlot;
      updatedSlots.add(newSlot);
    }

    final updatedKeyboard = state.currentKeyboard!.copyWith(
      slots: updatedSlots,
    );

    state = state.copyWith(currentKeyboard: updatedKeyboard);
    _bubbleCurrentKeyboardUpStack();

    ref
        .read(aacKeyboardsProvider.notifier)
        .updateSlot(updatedSlot!, state.currentKeyboard!.id!);

    final kbId = state.currentKeyboard!.id!;
    final refreshed = ref.read(aacKeyboardsProvider.notifier).getKeyboard(kbId);
    if (refreshed != null) {
      state = state.copyWith(currentKeyboard: refreshed);
      _bubbleCurrentKeyboardUpStack();
    }
  }

  void deleteSlot({required int x, required int y}) {
    final updatedSlots = List<KeyboardSlot>.from(state.currentKeyboard!.slots);

    final slotToDelete = updatedSlots.cast<KeyboardSlot?>().firstWhere(
      (s) => s!.x == x && s.y == y,
      orElse: () => null,
    );

    if (slotToDelete == null) return;

    updatedSlots.remove(slotToDelete);

    final updatedKeyboard = state.currentKeyboard!.copyWith(
      slots: List.of(updatedSlots),
    );

    state = state.copyWith(currentKeyboard: updatedKeyboard);
    _bubbleCurrentKeyboardUpStack();
    ref
        .read(aacKeyboardsProvider.notifier)
        .deleteSlot(slotToDelete, state.currentKeyboard!.id!);
  }

  Future<void> deleteAllSlotsRecursively() async {
    final currentKb = state.currentKeyboard;
    if (currentKb == null) return;

    await _deleteNested(currentKb);

    state = state.copyWith(
      currentKeyboard: currentKb.copyWith(slots: []),
    );
    _bubbleCurrentKeyboardUpStack();
  }

  Future<void> _deleteNested(AACKeyboard kb) async {
    for (final slot in kb.slots) {
      if (slot.keyboard != null) {
        await _deleteNested(slot.keyboard!);
      }
      ref.read(aacKeyboardsProvider.notifier).deleteSlot(slot, kb.id!);
    }
  }

  bool get isLocked => state.locked;

  void setLocked(bool value) {
    state = state.copyWith(locked: value);
  }

  void toggleLocked() {
    state = state.copyWith(locked: !state.locked);
  }

  void _bubbleCurrentKeyboardUpStack() {
    if (state.keyboardStack.isEmpty) return;

    var child = state.currentKeyboard;
    final stack = List<AACKeyboard>.from(state.keyboardStack);

    for (int i = stack.length - 1; i >= 0; i--) {
      final parent = stack[i];

      final newSlots = parent.slots.map((s) {
        final kb = s.keyboard;
        if (kb != null && kb.remoteId == child!.remoteId) {
          return s.copyWith(
            keyboard: child,
            updatedAt: DateTime.now(),
            isSynced: false,
            pendingAction: PendingAction.UPDATE,
          );
        }
        return s;
      }).toList();

      final updatedParent = parent.copyWith(slots: newSlots);
      stack[i] = updatedParent;

      child = updatedParent;
    }

    state = state.copyWith(keyboardStack: stack);
  }

  void switchKb() {
    state = state.copyWith(
      inputMode: state.inputMode == KeyboardInputMode.qwerty
          ? KeyboardInputMode.aacGrid
          : KeyboardInputMode.qwerty,
    );
  }

  void toggleInputMode() {
    state = state.copyWith(
      inputMode: state.inputMode == KeyboardInputMode.aacGrid
          ? KeyboardInputMode.qwerty
          : KeyboardInputMode.aacGrid,
    );
  }

  void typeText(String text) {
    if (text.isEmpty) return;
    state = state.copyWith(typedText: state.typedText + text);
  }

  void backspaceTyped() {
    final s = state.typedText;
    if (s.isEmpty) return;
    state = state.copyWith(typedText: s.substring(0, s.length - 1));
  }

  void clearTyped() {
    if (state.typedText.isEmpty) return;
    state = state.copyWith(typedText: '');
  }

  void speakTyped() {
    final text = state.typedText.trim();
    if (text.isEmpty) return;
    TtsService.speak(text);
  }

  void applyAcute() => _applyDiacritic(_Diacritic.acute);

  void applyCaron() => _applyDiacritic(_Diacritic.caron);

  void _applyDiacritic(_Diacritic d) {
    final text = state.typedText;
    if (text.isEmpty) {
      state = state.copyWith(typedText: d == _Diacritic.acute ? '´' : 'ˇ');
      return;
    }

    final chars = text.characters;
    final last = chars.last;

    final mapped = switch (d) {
      _Diacritic.acute => _acuteMap[last],
      _Diacritic.caron => _caronMap[last],
    };

    if (mapped == null) {
      return;
    }

    final prefix = chars.take(chars.length - 1).toString();
    state = state.copyWith(typedText: prefix + mapped);
  }

  static const Map<String, String> _acuteMap = {
    'a': 'á',
    'A': 'Á',
    'e': 'é',
    'E': 'É',
    'i': 'í',
    'I': 'Í',
    'o': 'ó',
    'O': 'Ó',
    'u': 'ú',
    'U': 'Ú',
    'y': 'ý',
    'Y': 'Ý',
    'r': 'ŕ',
    'R': 'Ŕ',
    'l': 'ĺ',
    'L': 'Ĺ',
  };

  static const Map<String, String> _caronMap = {
    'c': 'č',
    'C': 'Č',
    's': 'š',
    'S': 'Š',
    'z': 'ž',
    'Z': 'Ž',
    'd': 'ď',
    'D': 'Ď',
    't': 'ť',
    'T': 'Ť',
    'n': 'ň',
    'N': 'Ň',
    'l': 'ľ',
    'L': 'Ľ',
  };
}

final aacMainKeyboardProvider =
    StateNotifierProvider<AACKeyboardViewModel, AACKeyboardState>((ref) {
      return AACKeyboardViewModel(ref, initialRows: 4, initialColumns: 4);
    });
