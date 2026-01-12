import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/model/sync_entity.dart';
import '../model/aac_keyboard_remote_entity.dart';
import '../model/keyboard_slot_remote_entity.dart';

class AACKeyboardRemoteSource {
  final FirebaseFirestore _firestore;
  final String keyboardCollection = 'aac_keyboards';
  final String slotCollection = 'keyboard_slots';

  AACKeyboardRemoteSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createKeyboard(AACKeyboardRemoteEntity entity) async {
    final docRef = entity.remoteId != null
        ? _firestore.collection(keyboardCollection).doc(entity.remoteId)
        : _firestore.collection(keyboardCollection).doc();

    await docRef.set(_keyboardToMap(entity));
    return docRef.id;
  }

  Future<void> updateKeyboard(AACKeyboardRemoteEntity entity) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');
    final docRef = _firestore
        .collection(keyboardCollection)
        .doc(entity.remoteId);

    await docRef.update(_keyboardToMap(entity));
  }

  Future<void> deleteKeyboard(AACKeyboardRemoteEntity entity) async {
    if (entity.remoteId == null) return;
    final docRef = _firestore
        .collection(keyboardCollection)
        .doc(entity.remoteId);
    await docRef.delete();
  }

  Future<List<AACKeyboardRemoteEntity>> getAllKeyboards({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(keyboardCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => _keyboardFromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching keyboards: $e');
      return [];
    }
  }

  Map<String, dynamic> _keyboardToMap(AACKeyboardRemoteEntity e) {
    return {
      'localId': e.localId,
      'userId': e.userId,
      'name': e.name,
      'slots': e.slots,
      'updatedAt': e.updatedAt.toIso8601String(),
      'isDeleted': e.isDeleted,
      'isSynced': e.isSynced,
      'pendingAction': e.pendingAction.index,
    };
  }

  AACKeyboardRemoteEntity _keyboardFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};
    return AACKeyboardRemoteEntity(
        localId: d['localId'] ?? 0,
        slots: List<String>.from(d['slots'] ?? []),
        userId: d['userId'] ?? '',
        name: d['name'] ?? '',
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
      )
      ..remoteId = snap.id
      ..isSynced = true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }

  Future<String> createSlot(KeyboardSlotRemoteEntity entity) async {
    final docRef = entity.remoteId != null
        ? _firestore.collection(slotCollection).doc(entity.remoteId)
        : _firestore.collection(slotCollection).doc();

    await docRef.set(_slotToMap(entity));
    return docRef.id;
  }

  Future<void> updateSlot(KeyboardSlotRemoteEntity entity) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');
    final docRef = _firestore.collection(slotCollection).doc(entity.remoteId);
    await docRef.update(_slotToMap(entity));
  }

  Future<void> deleteSlot(KeyboardSlotRemoteEntity entity) async {
    if (entity.remoteId == null) return;
    final docRef = _firestore.collection(slotCollection).doc(entity.remoteId);
    await docRef.delete();
  }

  Future<List<KeyboardSlotRemoteEntity>> getSlots({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(slotCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) => _slotFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching slots: $e');
      return [];
    }
  }

  Map<String, dynamic> _slotToMap(KeyboardSlotRemoteEntity e) {
    return {
      'id': e.id,
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

  KeyboardSlotRemoteEntity _slotFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};
    return KeyboardSlotRemoteEntity(
        id: d['id'] ?? 0,
        x: d['x'] ?? 0,
        y: d['y'] ?? 0,
        card: d['card'],
        keyboard: d['keyboard'],
        updatedAt: d['updatedAt'] != null
            ? DateTime.parse(d['updatedAt'])
            : DateTime.now(),
      )
      ..remoteId = snap.id
      ..isSynced = true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}
