import 'dart:async';

import 'package:aut_toolkit/core/services/repo_service.dart';
import 'package:aut_toolkit/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/objectbox.dart';
import '../../../core/services/sync_manager.dart';
import '../../../main.dart';
import '../data/model/aac_keyboard_entity.dart';
import '../data/model/keyboard_slot_entity.dart';
import '../data/source/aac_keyboard_local_source.dart';
import '../data/source/aac_keyboard_remote_source.dart';
import '../domain/model/aac_keyboard.dart';
import '../domain/model/keyboad_slot.dart';
import '../domain/repository/aac_keyboard_repository.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  return objectbox;
});

final aacKeyboardBoxProvider = Provider<Box<AACKeyboardEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.aacKeyboardBox;
});

final keyboardSlotBoxProvider = Provider<Box<KeyboardSlotEntity>>((ref) {
  final obx = ref.watch(objectBoxProvider);
  return obx.keyboardSlotBox;
});

final aacKeyboardRemoteSourceProvider = Provider<AACKeyboardRemoteSource>((
  ref,
) {
  return AACKeyboardRemoteSource();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final sm = SyncManager();
  ref.onDispose(() => sm.dispose());
  return sm;
});

final aacKeyboardLocalSourceProvider = Provider<AACKeyboardLocalSource>((ref) {
  final kbBox = ref.watch(aacKeyboardBoxProvider);
  final slotBox = ref.watch(keyboardSlotBoxProvider);
  return AACKeyboardLocalSource(kbBox, slotBox);
});

final aacKeyboardRepositoryProvider = Provider<AACKeyboardRepository>((ref) {
  return RepoService().aacKeyboardRepositoryImpl;
});

final aacKeyboardsProvider =
    StateNotifierProvider<AACKeyboardsNotifier, List<AACKeyboard>>((ref) {
      final repo = ref.watch(aacKeyboardRepositoryProvider);
      return AACKeyboardsNotifier(repo);
    });

class AACKeyboardsNotifier extends StateNotifier<List<AACKeyboard>> {
  final AACKeyboardRepository _repo;
  late final StreamSubscription _sub;

  AACKeyboardsNotifier(this._repo) : super([]) {
    _sub = _repo.watchAll().listen((data) {
      state = data;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void addKeyboard(AACKeyboard kb) {
    _repo.saveKeyboard(kb);
  }

  void updateKeyboard(AACKeyboard kb) {
    _repo.saveKeyboard(kb);
  }

  void deleteKeyboard(AACKeyboard kb) {
    _repo.deleteKeyboard(kb);
  }

  void updateSlot(KeyboardSlot slot) {
    _repo.saveSlot(slot);
  }

  void deleteSlot(KeyboardSlot slot) {
    _repo.deleteSlot(slot);
  }

  List<KeyboardSlot> getSlots(AACKeyboard keyboard) {
    return _repo.getAllSlots(keyboard);
  }
}
