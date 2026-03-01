import 'package:aut_toolkit/core/services/syncable_repository.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/model/aac_keyboard_mappers.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/source/aac_keyboard_local_source.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/source/aac_keyboard_remote_source.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/repository/aac_keyboard_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../core/model/sync_entity.dart';
import '../../../core/services/sync_manager.dart';
import 'model/aac_keyboard_entity.dart';
import 'model/keyboard_slot_entity.dart';

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

  final _uuid = const Uuid();

  @override
  void saveSlot(KeyboardSlot slot, int parentKeyboardId) {
    slot.remoteId ??= _uuid.v4();

    if (slot.id == 0) {
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
    final entity = slot.toEntity(parentKeyboard: _localSource.getById(parentKeyboardId));
    if (entity.id == 0) return;
    entity.isDeleted = true;
    entity.pendingAction = PendingAction.DELETE.index;
    entity.isSynced = false;
    entity.updatedAt = DateTime.now();
    _localSource.addSlot(parentKeyboardId: parentKeyboardId, slot: entity);
    _markKeyboardDirty(parentKeyboardId);

    final nestedKeyboard = slot.keyboard;
    if (nestedKeyboard != null) {
      deleteKeyboard(nestedKeyboard);
    }

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
      final localKeyboards = _localSource.getAllKeyboardsForUser(userId);

      final remoteKeyboardIds = <String>{};

      for (final remoteKb in remoteKeyboards) {
        final remoteKbId = remoteKb.remoteId;
        if (remoteKbId == null) continue;

        remoteKeyboardIds.add(remoteKbId);

        final localKb = _localSource.getByRemoteId(remoteKbId);

        final baseRemoteEntity = remoteKb.toEntity();

        baseRemoteEntity.id = localKb?.id ?? 0;

        final localHasPending =
            localKb != null &&
            localKb.pendingAction != PendingAction.NONE.index;

        final localIsNewer =
            localKb?.updatedAt != null &&
            localKb!.updatedAt.isAfter(baseRemoteEntity.updatedAt);

        final AACKeyboardEntity keyboardToSave;
        if (localHasPending && localIsNewer) {
          keyboardToSave = localKb;
          keyboardToSave.remoteId = baseRemoteEntity.remoteId;
          keyboardToSave.isSynced = false;
        } else {
          keyboardToSave = baseRemoteEntity;
          keyboardToSave.pendingAction = PendingAction.NONE.index;
          keyboardToSave.isSynced = true;
          keyboardToSave.isDeleted = false;
        }

        _localSource.putKeyboard(keyboardToSave);
      }

      for (final remoteKb in remoteKeyboards) {
        final remoteKbId = remoteKb.remoteId;
        if (remoteKbId == null) continue;

        final keyboardToSave = _localSource.getByRemoteId(remoteKbId);
        if (keyboardToSave == null) continue;

        final remoteSlots = remoteKb.slots
            .where((s) => s.isDeleted != true)
            .toList();

        final remoteSlotIds = remoteSlots
            .map((s) => s.remoteId)
            .whereType<String>()
            .toSet();

        keyboardToSave.slots.clear();

        for (final remoteSlot in remoteSlots) {
          final rid = remoteSlot.remoteId;
          if (rid == null) continue;

          final localSlot = _localSource.getSlotByRemoteId(rid);

          final remoteSlotEntity = remoteSlot.toEntity(
            parentKeyboard: keyboardToSave,
          );
          remoteSlotEntity.id = localSlot?.id ?? 0;

          final localSlotHasPending =
              localSlot != null &&
              localSlot.pendingAction != PendingAction.NONE.index;

          final localSlotIsNewer =
              localSlot?.updatedAt != null &&
              localSlot!.updatedAt.isAfter(remoteSlotEntity.updatedAt);

          final KeyboardSlotEntity slotToSave;
          if (localSlotHasPending && localSlotIsNewer) {
            slotToSave = localSlot;
            slotToSave.remoteId = remoteSlotEntity.remoteId;
            slotToSave.isSynced = false;
          } else {
            slotToSave = remoteSlotEntity;
            slotToSave.pendingAction = PendingAction.NONE.index;
            slotToSave.isSynced = true;
            slotToSave.isDeleted = false;
          }

          keyboardToSave.slots.add(slotToSave);
          _localSource.updateSlot(slotToSave);
        }

        _localSource.putKeyboard(keyboardToSave);

        final kbId = keyboardToSave.id;
        if (kbId != null && kbId != 0) {
          final localSlots = _localSource.getSlots(keyboardId: kbId);

          for (final localSlot in localSlots) {
            final localRid = localSlot.remoteId;
            if (localRid == null) continue;

            final localPending =
                localSlot.pendingAction != PendingAction.NONE.index;

            if (!localPending && !remoteSlotIds.contains(localRid)) {
              _localSource.deleteSlot(localSlot.id!);
            }
          }
        }
      }

      for (final localKb in localKeyboards) {
        final rid = localKb.remoteId;
        if (rid == null) continue;

        final localPending = localKb.pendingAction != PendingAction.NONE.index;

        if (!localPending && !remoteKeyboardIds.contains(rid)) {
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

          final deletedSlots = kb.slots.where((s) => s.isDeleted == true).toList();
          for (final slot in deletedSlots) {
            if (slot.id != null) _localSource.deleteSlot(slot.id!);
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


  }

  @override
  Stream<List<AACKeyboard>> watchAll() {
    return _localSource.watchAllKeyboards().map(
      (entities) => entities.map((e) => e.toModel()).toList(),
    );
  }
}
