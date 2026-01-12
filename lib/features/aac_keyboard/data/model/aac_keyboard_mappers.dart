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
    final model = AACKeyboard(
      id: id,
      userId: userId,
      name: name,
      slots: slotModels,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId,
    );
    return model;
  }
}

extension KeyboardSlotEntityMapper on KeyboardSlotEntity {
  KeyboardSlot toModel() {
    final model = KeyboardSlot(
      x: x,
      y: y,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: PendingAction.values[pendingAction],
      remoteId: remoteId,
    );
    if (card.target != null) {
      model.card = card.target!.toModel();
    }
    if (keyboard.target != null) {
      model.keyboard = keyboard.target!.toModel();
    }
    return model;
  }
}

extension AacKeyboardMapper on AACKeyboard {
  AACKeyboardEntity toEntity() {
    final entity = AACKeyboardEntity(
      userId: userId,
      name: name,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
      pendingAction: pendingAction.index,
      remoteId: remoteId,
    );

    final slotsEntities = slots.map((e) => e.toEntity()).toList();

    entity.slots
      ..clear()
      ..addAll(slotsEntities);

    return entity;
  }
}

extension KeyboardSlotMapper on KeyboardSlot {
  KeyboardSlotEntity toEntity() {
    final entity = KeyboardSlotEntity(
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
    return entity;
  }
}

extension AACKeyboardEntityToRemote on AACKeyboardEntity {
  AACKeyboardRemoteEntity toRemote() {
    return AACKeyboardRemoteEntity(
        localId: id!,
        slots: slots.map((e) => e.remoteId!).toList(),
        userId: userId,
        name: name,
        updatedAt: updatedAt,
      )
      ..isDeleted = isDeleted
      ..isSynced = isSynced
      ..pendingAction = PendingAction.values[pendingAction]
      ..remoteId = remoteId;
  }
}

extension KeyboardSlotEntityToRemoteMapper on KeyboardSlotEntity {
  KeyboardSlotRemoteEntity toRemote() {
    return KeyboardSlotRemoteEntity(
        keyboard: keyboard.target?.remoteId,
        card: card.target?.remoteId,
        x: x,
        y: y,
        updatedAt: updatedAt,
      )
      ..isDeleted = isDeleted
      ..isSynced = isSynced
      ..pendingAction = PendingAction.values[pendingAction]
      ..remoteId = remoteId;
  }
}

extension AACKeyboardRemoteToEntity on AACKeyboardRemoteEntity {
  AACKeyboardEntity toEntity() {
    final entity = AACKeyboardEntity(
      userId: userId,
      name: name,
      updatedAt: updatedAt,
    );

    entity.slots
      ..clear()
      ..addAll(
        slots
            .map(
              (remoteId) => objectbox.keyboardSlotBox.getByRemoteId(remoteId),
            )
            .whereType<KeyboardSlotEntity>()
            .toList(),
      );

    entity.isDeleted = isDeleted;
    entity.isSynced = isSynced;
    entity.pendingAction = pendingAction.index;
    entity.remoteId = remoteId;

    return entity;
  }
}

extension KeyboardSlotRemoteToEntity on KeyboardSlotRemoteEntity {
  KeyboardSlotEntity toEntity() {
    final entity = KeyboardSlotEntity(x: x, y: y, updatedAt: updatedAt);

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

    entity.isDeleted = isDeleted;
    entity.isSynced = isSynced;
    entity.pendingAction = pendingAction.index;
    entity.remoteId = remoteId;

    return entity;
  }
}
