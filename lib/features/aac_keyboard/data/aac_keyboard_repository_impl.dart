import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/model/aac_keyboard_mappers.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/source/aac_keyboard_local_source.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/source/aac_keyboard_remote_source.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/repository/aac_keyboard_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';
import 'model/keyboard_slot_remote_entity.dart';

class AACKeyboardRepositoryImpl
    implements AACKeyboardRepository, SyncableRepository {
  final AACKeyboardLocalSource _localSource;
  final AACKeyboardRemoteSource _remoteSource;
  final SyncManager _syncManager;

  AACKeyboardRepositoryImpl(
    this._localSource,
    this._remoteSource,
    this._syncManager,
  ) {
    _syncManager.processors.add(processPending);
    _syncManager.addProcessor(fetchRemote);
  }

  @override
  List<AACKeyboard> getAllKeyboards() {
    return _localSource.getAllKeyboards().map((e) => e.toModel()).toList();
  }

  @override
  void saveKeyboard(AACKeyboard keyboard) {
    final now = DateTime.now();
    if (keyboard.id == 0 || keyboard.remoteId == null) {
      keyboard.pendingAction = PendingAction.CREATE;
      keyboard.isSynced = false;
    } else {
      keyboard.pendingAction = PendingAction.UPDATE;
      keyboard.isSynced = false;
    }
    keyboard.updatedAt = now;

    _localSource.putKeyboard(keyboard.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteKeyboard(AACKeyboard keyboard) {
    final entity = keyboard.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();

    _localSource.putKeyboard(entity);
    _syncManager.processOnce();
  }

  @override
  void saveSlot(KeyboardSlot slot) {
    if (slot.id == 0 || slot.remoteId == null) {
      slot.pendingAction = PendingAction.CREATE;
      slot.isSynced = false;
    } else {
      slot.pendingAction = PendingAction.UPDATE;
      slot.isSynced = false;
    }
    slot.updatedAt = DateTime.now();
    _localSource.addSlot(slot.toEntity());
    _syncManager.processOnce();
  }

  @override
  void deleteSlot(KeyboardSlot slot) {
    final entity = slot.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();
    _localSource.addSlot(entity);

    _syncManager.processOnce();
  }

  @override
  List<KeyboardSlot> getAllSlots(AACKeyboard keyboard) {
    final slots = _localSource.getSlots(keyboardId: keyboard.id);
    return slots.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> fetchRemote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final allSlots = await _remoteSource.getSlots(userId: userId);

      final Map<String, List<KeyboardSlotRemoteEntity>> slotsByKeyboard = {};
      for (final slot in allSlots) {
        if (slot.keyboard == null) continue;
        slotsByKeyboard.putIfAbsent(slot.keyboard!, () => []).add(slot);
      }

      final remoteKeyboards = await _remoteSource.getAllKeyboards(
        userId: userId,
      );
      final localKeyboards = _localSource.getAllKeyboards();

      final remoteKeyboardIds = <String>{};

      for (final remoteKb in remoteKeyboards) {
        remoteKeyboardIds.add(remoteKb.remoteId!);

        final localKb = _localSource.getByRemoteId(remoteKb.remoteId!);

        final kbEntity = remoteKb.toEntity();
        kbEntity.id = localKb?.id ?? 0;

        if (localKb != null &&
            localKb.pendingAction != PendingAction.NONE.index) {
          kbEntity.pendingAction = localKb.pendingAction;
          kbEntity.isSynced = localKb.isSynced;
        }

        final remoteSlots = slotsByKeyboard[remoteKb.remoteId!] ?? [];

        kbEntity.slots.clear();
        for (final slotRemote in remoteSlots) {
          final localSlot = _localSource.getSlotByRemoteId(
            slotRemote.remoteId!,
          );

          final slotEntity = slotRemote.toEntity();
          slotEntity.id = localSlot?.id ?? 0;

          if (localSlot != null &&
              localSlot.pendingAction != PendingAction.NONE.index) {
            slotEntity.pendingAction = localSlot.pendingAction;
            slotEntity.isSynced = localSlot.isSynced;
          }

          slotEntity.keyboard.target = kbEntity;

          kbEntity.slots.add(slotEntity);

          _localSource.updateSlot(slotEntity);
        }

        _localSource.putKeyboard(kbEntity);

        final localSlots = _localSource.getSlots(keyboardId: kbEntity.id);
        for (final localSlot in localSlots) {
          if (localSlot.remoteId != null &&
              !remoteSlots.any((s) => s.remoteId! == localSlot.remoteId)) {
            _localSource.deleteSlot(localSlot.id!);
          }
        }
      }

      for (final localKb in localKeyboards) {
        if (localKb.remoteId != null &&
            !remoteKeyboardIds.contains(localKb.remoteId)) {
          _localSource.deleteKeyboard(localKb.id!);
        }
      }
    } catch (e) {
      print('Error fetching remote keyboards and slots: $e');
    }
  }

  @override
  Future<void> processPending() async {
    final pendingKeyboards = _localSource.getAllPending();
    for (final kb in pendingKeyboards) {
      try {
        final action = PendingAction.values[kb.pendingAction];

        if (action == PendingAction.CREATE) {
          kb.pendingAction = PendingAction.NONE.index;
          await _remoteSource.createKeyboard(kb.toRemote());
          kb.isSynced = true;
          _localSource.putKeyboard(kb);
        } else if (action == PendingAction.UPDATE) {
          if (kb.remoteId == null) {
            kb.pendingAction = PendingAction.NONE.index;
            await _remoteSource.createKeyboard(kb.toRemote());
            kb.isSynced = true;
            _localSource.putKeyboard(kb);
          } else {
            kb.pendingAction = PendingAction.NONE.index;
            await _remoteSource.updateKeyboard(kb.toRemote());
            kb.isSynced = true;
            _localSource.putKeyboard(kb);
          }
        } else if (action == PendingAction.DELETE) {
          if (kb.remoteId != null) {
            await _remoteSource.deleteKeyboard(kb.toRemote());
          }
          _localSource.deleteKeyboard(kb.id!);
        }
      } catch (_) {
        continue;
      }
    }

    final pendingSlots = _localSource.getAllPendingSlots();
    for (final slot in pendingSlots) {
      try {
        final action = PendingAction.values[slot.pendingAction];

        if (action == PendingAction.CREATE) {
          slot.pendingAction = PendingAction.NONE.index;
          await _remoteSource.createSlot(slot.toRemote());
          slot.isSynced = true;
          _localSource.updateSlot(slot);
        } else if (action == PendingAction.UPDATE) {
          if (slot.remoteId == null) {
            slot.pendingAction = PendingAction.NONE.index;
            await _remoteSource.createSlot(slot.toRemote());
            slot.isSynced = true;
            _localSource.updateSlot(slot);
          } else {
            slot.pendingAction = PendingAction.NONE.index;
            await _remoteSource.updateSlot(slot.toRemote());
            slot.isSynced = true;
            _localSource.updateSlot(slot);
          }
        } else if (action == PendingAction.DELETE) {
          if (slot.remoteId != null) {
            await _remoteSource.deleteSlot(slot.toRemote());
          }
          _localSource.deleteSlot(slot.id!);
        }
      } catch (_) {
        continue;
      }
    }
  }

  @override
  Stream<List<AACKeyboard>> watchAll() {
    return _localSource.watchAllKeyboards().map(
      (entities) => entities.map((e) => e.toModel()).toList(),
    );
  }
}
