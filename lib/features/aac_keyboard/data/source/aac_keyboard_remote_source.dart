import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/aac_keyboard_remote_entity.dart';
import '../model/keyboard_slot_remote_entity.dart';

class AACKeyboardRemoteSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userKeyboardsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('aac_keyboards');
  }

  AACKeyboardRemoteSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createKeyboard(AACKeyboardRemoteEntity entity) async {
    final uid = entity.userId;
    final docRef = entity.remoteId != null
        ? _userKeyboardsRef(uid).doc(entity.remoteId)
        : _userKeyboardsRef(uid).doc();

    await docRef.set(_keyboardToMap(entity));
    return docRef.id;
  }

  Future<void> updateKeyboard(AACKeyboardRemoteEntity entity) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');

    final docRef = _userKeyboardsRef(entity.userId).doc(entity.remoteId);
    await docRef.update(_keyboardToMap(entity));
  }

  Future<void> deleteKeyboard(AACKeyboardRemoteEntity entity) async {
    if (entity.remoteId == null) return;

    final docRef = _userKeyboardsRef(entity.userId).doc(entity.remoteId);
    await docRef.delete();
  }

  Future<List<AACKeyboardRemoteEntity>> getAllKeyboards({
    required String userId,
  }) async {
    try {
      final snapshot = await _userKeyboardsRef(userId).get();
      return snapshot.docs.map(_keyboardFromSnapshot).toList();
    } catch (e) {
      print('Error fetching keyboards: $e');
      return [];
    }
  }

  Future<List<KeyboardSlotRemoteEntity>> getSlots({
    required String keyboardRemoteId,
    required String userId,
  }) async {
    final snap = await _userKeyboardsRef(userId).doc(keyboardRemoteId).get();
    if (!snap.exists) return [];

    final data = snap.data() ?? {};
    final rawSlots = (data['slots'] as List?) ?? [];
    return rawSlots
        .map((m) => _slotFromMap(Map<String, dynamic>.from(m as Map)))
        .toList();
  }

  Future<void> createSlot({
    required String keyboardRemoteId,
    required String userId,
    required KeyboardSlotRemoteEntity slot,
  }) async {
    final docRef = _userKeyboardsRef(userId).doc(keyboardRemoteId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists)
        throw StateError('Keyboard $keyboardRemoteId does not exist');

      final data = snap.data() ?? {};
      final slotsRaw = (data['slots'] as List?) ?? [];
      final slots = slotsRaw
          .map((m) => Map<String, dynamic>.from(m as Map))
          .toList();

      final int slotId = slot.id!;
      final idx = slots.indexWhere(
        (s) => (s['remoteId'] ?? '') == slot.remoteId,
      );
      final newSlotMap = _slotToMap(slot..id = slotId);

      if (idx == -1) {
        slots.add(newSlotMap);
      } else {
        slots[idx] = newSlotMap;
      }

      tx.update(docRef, {
        'slots': slots,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> updateSlot({
    required String keyboardRemoteId,
    required String userId,
    required KeyboardSlotRemoteEntity slot,
  }) async {
    final docRef = _userKeyboardsRef(userId).doc(keyboardRemoteId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists)
        throw StateError('Keyboard $keyboardRemoteId does not exist');

      final data = snap.data() ?? {};
      final slotsRaw = (data['slots'] as List?) ?? [];
      final slots = slotsRaw
          .map((m) => Map<String, dynamic>.from(m as Map))
          .toList();

      final idx = slots.indexWhere(
        (s) => (s['remoteId'] ?? '') == slot.remoteId,
      );
      if (idx == -1)
        throw StateError('Slot with id=${slot.id} not found in keyboard');

      slots[idx] = _slotToMap(slot);

      tx.update(docRef, {
        'slots': slots,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> deleteSlot({
    required String keyboardRemoteId,
    required String userId,
    required String remoteId,
    bool softDelete = false,
  }) async {
    final docRef = _userKeyboardsRef(userId).doc(keyboardRemoteId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;

      final data = snap.data() ?? {};
      final slotsRaw = (data['slots'] as List?) ?? [];
      final slots = slotsRaw
          .map((m) => Map<String, dynamic>.from(m as Map))
          .toList();

      if (softDelete) {
        final idx = slots.indexWhere((s) => (s['remoteId'] ?? '') == remoteId);
        if (idx != -1) {
          slots[idx]['isDeleted'] = true;
          slots[idx]['pendingAction'] = PendingAction.DELETE.index;
          slots[idx]['updatedAt'] = DateTime.now().toIso8601String();
        }
      } else {
        slots.removeWhere((s) => (s['remoteId'] ?? '') == remoteId);
      }

      tx.update(docRef, {
        'slots': slots,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    });
  }

  Map<String, dynamic> _keyboardToMap(AACKeyboardRemoteEntity e) {
    return {
      'localId': e.localId,
      'userId': e.userId,
      'name': e.name,

      'slots': (e.slots).map(_slotToMap).toList(),

      'updatedAt': e.updatedAt.toIso8601String(),
      'isDeleted': e.isDeleted,
      'isSynced': e.isSynced,
      'pendingAction': e.pendingAction.index,
      'isInternal': e.isInternal,
      'isSelected': e.isSelected,
      'rows': e.rows,
      'cols': e.cols,
    };
  }

  AACKeyboardRemoteEntity _keyboardFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};

    final rawSlots = (d['slots'] as List?) ?? const [];
    final slots = rawSlots
        .map((m) => _slotFromMap(Map<String, dynamic>.from(m as Map)))
        .toList();

    return AACKeyboardRemoteEntity(
        localId: d['localId'] ?? 0,
        userId: d['userId'] ?? '',
        name: d['name'] ?? '',
        slots: slots,
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
        isInternal: d['isInternal'] ?? false,
        isSelected: d['isSelected'] ?? false,
        rows: d['rows'] ?? 5,
        cols: d['cols'] ?? 5,
      )
      ..remoteId = snap.id
      ..isSynced = true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }

  Map<String, dynamic> _slotToMap(KeyboardSlotRemoteEntity e) {
    return {
      'id': e.id,
      'remoteId': e.remoteId,
      'x': e.x,
      'y': e.y,
      'card': e.card,
      'keyboard': e.keyboard,
      'updatedAt': e.updatedAt.toIso8601String(),
      'isDeleted': e.isDeleted,
      'isSynced': e.isSynced,
      'pendingAction': e.pendingAction.index,
    };
  }

  KeyboardSlotRemoteEntity _slotFromMap(Map<String, dynamic> d) {
    return KeyboardSlotRemoteEntity(
        id: d['id'] ?? 0,
        x: d['x'] ?? 0,
        y: d['y'] ?? 0,
        card: d['card'],
        keyboard: d['keyboard'],
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
        remoteId: d['remoteId'],
      )
      ..remoteId = d['remoteId']
      ..isSynced = true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}
