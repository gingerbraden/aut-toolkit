import 'package:aut_toolkit/features/aac_keyboard/data/model/aac_keyboard_entity.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/model/aac_keyboard_remote_entity.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/model/keyboard_slot_entity.dart';
import 'package:aut_toolkit/features/aac_keyboard/data/model/keyboard_slot_remote_entity.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/domain/model/keyboad_slot.dart';
import 'package:aut_toolkit/features/card_management/data/model/card_mappers.dart';
import 'package:aut_toolkit/features/card_management/data/model/user_card_entity.dart';
import 'package:aut_toolkit/main.dart';

import '../../../../core/model/sync_entity.dart';

extension AACKeyboardEntityMapper on AACKeyboardEntity {
  AACKeyboard toModel() {
    final slotModels = slots.map((s) => s.toModel()).toList();

    return AACKeyboard(
      id: id,
      userId: userId,
      name: name,
      slots: slotModels,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId,
      isInternal: isInternal,
      isSelected: isSelected,
      rows: rows,
      cols: cols,
    );
  }
}

extension KeyboardSlotEntityMapper on KeyboardSlotEntity {
  KeyboardSlot toModel() {
    final model = KeyboardSlot(
      id: id,
      x: x,
      y: y,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId,
    );

    final c = card.target;
    if (c != null) {
      model.card = c.toModel();
    }

    final kb = keyboard.target;
    if (kb != null) {
      model.keyboard = AACKeyboard(
        id: kb.id,
        userId: kb.userId,
        name: kb.name,
        slots: const [],
        updatedAt: kb.updatedAt,
        isDeleted: kb.isDeleted,
        isSynced: kb.isSynced,
        pendingAction: PendingAction.values[kb.pendingAction],
        remoteId: kb.remoteId,
        isInternal: kb.isInternal,
        isSelected: kb.isSelected,
        rows: kb.rows,
        cols: kb.cols,
      );
    }

    return model;
  }
}

extension AacKeyboardMapper on AACKeyboard {
  AACKeyboardEntity toEntity() {
    final entity = AACKeyboardEntity(
      id: id,
      userId: userId,
      name: name,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: pendingAction.index,
      remoteId: remoteId,
      isInternal: isInternal,
      isSelected: isSelected,
      rows: rows,
      cols: cols,
    );

    final slotEntities = slots
        .map((s) => s.toEntity(parentKeyboard: entity))
        .toList();

    entity.slots
      ..clear()
      ..addAll(slotEntities);

    return entity;
  }
}

extension KeyboardSlotMapper on KeyboardSlot {
  KeyboardSlotEntity toEntity({AACKeyboardEntity? parentKeyboard}) {
    final entity = KeyboardSlotEntity(
      id: id,
      x: x,
      y: y,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: pendingAction.index,
      remoteId: remoteId,
    );

    if (card != null) {
      entity.card.targetId = card!.id;
    } else {
      entity.card.target = null;
    }

    if (keyboard != null) {
      entity.keyboard.targetId = keyboard!.id;
    } else {
      entity.keyboard.target = null;
    }

    if (parentKeyboard != null) {
      entity.parent.target = parentKeyboard;
    }

    return entity;
  }
}

extension AACKeyboardEntityToRemote on AACKeyboardEntity {
  AACKeyboardRemoteEntity toRemote() {
    return AACKeyboardRemoteEntity(
        localId: id ?? 0,
        userId: userId,
        name: name,
        slots: slots.map((e) => e.toRemote()).toList(),
        updatedAt: updatedAt,
        isInternal: isInternal,
        isSelected: isSelected,
        rows: rows,
        cols: cols,
      )
      ..remoteId = remoteId
      ..isDeleted = isDeleted
      ..isSynced = true
      ..pendingAction = PendingAction.NONE;
  }
}

extension KeyboardSlotEntityToRemoteMapper on KeyboardSlotEntity {
  KeyboardSlotRemoteEntity toRemote() {
    return KeyboardSlotRemoteEntity(
        id: id ?? 0,
        remoteId: remoteId,
        x: x,
        y: y,
        card: card.target?.remoteId,
        keyboard: keyboard.target?.remoteId,
        updatedAt: updatedAt,
      )
      ..isDeleted = isDeleted
      ..isSynced = true
      ..pendingAction = PendingAction.NONE;
  }
}

extension AACKeyboardRemoteToEntity on AACKeyboardRemoteEntity {
  AACKeyboardEntity toEntity() {
    final entity = AACKeyboardEntity(
      userId: userId,
      name: name,
      updatedAt: updatedAt,
      isInternal: isInternal,
      isSelected: isSelected,
      rows: rows,
      cols: cols,
    );

    final slotEntities = (slots)
        .where((s) => s.isDeleted != true)
        .map((s) => s.toEntity(parentKeyboard: entity))
        .toList();

    entity.slots
      ..clear()
      ..addAll(slotEntities);

    entity.remoteId = remoteId;
    entity.isDeleted = isDeleted;
    entity.isSynced = true;
    entity.pendingAction = PendingAction.NONE.index;

    return entity;
  }
}

extension KeyboardSlotRemoteToEntity on KeyboardSlotRemoteEntity {
  KeyboardSlotEntity toEntity({AACKeyboardEntity? parentKeyboard}) {
    final entity = KeyboardSlotEntity(
      x: x,
      y: y,
      updatedAt: updatedAt,
      remoteId: remoteId,
      id: 0,
    );

    if (card != null && card!.isNotEmpty) {
      entity.card.target = objectbox.cardBox.getByRemoteId(card!);
    } else {
      entity.card.target = null;
    }

    if (keyboard != null && keyboard!.isNotEmpty) {
      entity.keyboard.target = objectbox.aacKeyboardBox.getByRemoteId(
        keyboard!,
      );
    } else {
      entity.keyboard.target = null;
    }

    if (parentKeyboard != null) {
      entity.parent.target = parentKeyboard;
    }

    entity.isDeleted = isDeleted;
    entity.isSynced = true;
    entity.pendingAction = PendingAction.NONE.index;

    return entity;
  }
}
