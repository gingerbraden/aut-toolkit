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
  int saveKeyboard(AACKeyboard keyboard) {
    final now = DateTime.now();
    if (keyboard.id == 0 || keyboard.remoteId == null) {
      keyboard.pendingAction = PendingAction.CREATE;
      keyboard.isSynced = false;
    } else {
      keyboard.pendingAction = PendingAction.UPDATE;
      keyboard.isSynced = false;
    }
    keyboard.updatedAt = now;

    final id = _localSource.putKeyboard(keyboard.toEntity());
    _syncManager.processOnce();
    return id;
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
  void saveSlot(KeyboardSlot slot, int parentKeyboardId) {
    if (slot.id == 0 || slot.remoteId == null) {
      slot.pendingAction = PendingAction.CREATE;
      slot.isSynced = false;
    } else {
      slot.pendingAction = PendingAction.UPDATE;
      slot.isSynced = false;
    }
    slot.updatedAt = DateTime.now();
    _localSource.addSlot(
      parentKeyboardId: parentKeyboardId,
      slot: slot.toEntity(),
    );
    _markKeyboardDirty(parentKeyboardId);

    _syncManager.processOnce();
  }

  @override
  void deleteSlot(KeyboardSlot slot, int parentKeyboardId) {
    final entity = slot.toEntity();
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();
    _localSource.addSlot(parentKeyboardId: parentKeyboardId, slot: entity);
    _markKeyboardDirty(parentKeyboardId);

    _syncManager.processOnce();
  }

  @override
  List<KeyboardSlot> getAllSlots(AACKeyboard keyboard) {
    final slots = _localSource.getSlots(keyboardId: keyboard.id);
    return slots.map((e) => e.toModel()).toList();
  }

  void _markKeyboardDirty(int parentKeyboardId) {
    final kb = _localSource.getById(parentKeyboardId);
    if (kb == null) return;

    if (kb.pendingAction == PendingAction.NONE.index) {
      kb.pendingAction = PendingAction.UPDATE.index;
    }
    kb.isSynced = false;
    kb.updatedAt = DateTime.now();
    _localSource.putKeyboard(kb);
  }

  @override
  Future<void> fetchRemote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final remoteKeyboards = await _remoteSource.getAllKeyboards(
        userId: userId,
      );
      final localKeyboards = _localSource.getAllKeyboards();

      final remoteKeyboardIds = <String>{};

      for (final remoteKb in remoteKeyboards) {
        final remoteKbId = remoteKb.remoteId;
        if (remoteKbId == null) continue;

        remoteKeyboardIds.add(remoteKbId);

        final localKb = _localSource.getByRemoteId(remoteKbId);

        final kbEntity = remoteKb.toEntity();
        kbEntity.id = localKb?.id ?? 0;

        if (localKb != null &&
            localKb.pendingAction != PendingAction.NONE.index) {
          kbEntity.pendingAction = localKb.pendingAction;
          kbEntity.isSynced = localKb.isSynced;
        }

        final remoteSlots = remoteKb.slots;

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

          kbEntity.slots.add(slotEntity);
          _localSource.updateSlot(slotEntity);
        }

        _localSource.putKeyboard(kbEntity);

        final localSlots = _localSource.getSlots(keyboardId: kbEntity.id);
        for (final localSlot in localSlots) {
          final localSlotId = localSlot.id;
          if (localSlotId != null &&
              !remoteSlots.any((s) => s.id == localSlotId)) {
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
    } catch (e, st) {
      print('Error fetching remote keyboards: $e\n$st');
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

          final newRemoteId = await _remoteSource.createKeyboard(kb.toRemote());
          kb.remoteId = newRemoteId;

          kb.isSynced = true;
          _localSource.putKeyboard(kb);
        } else if (action == PendingAction.UPDATE) {
          kb.pendingAction = PendingAction.NONE.index;

          if (kb.remoteId == null) {
            final newRemoteId = await _remoteSource.createKeyboard(
              kb.toRemote(),
            );
            kb.remoteId = newRemoteId;
          } else {
            await _remoteSource.updateKeyboard(kb.toRemote());
          }

          kb.isSynced = true;
          _localSource.putKeyboard(kb);
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
        final parentKb = slot.keyboard.target;
        if (parentKb == null) continue;

        if (parentKb.pendingAction == PendingAction.NONE.index) {
          parentKb.pendingAction = PendingAction.UPDATE.index;
          parentKb.isSynced = false;
          _localSource.putKeyboard(parentKb);
        }

        slot.pendingAction = PendingAction.NONE.index;
        slot.isSynced = true;
        _localSource.updateSlot(slot);
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
