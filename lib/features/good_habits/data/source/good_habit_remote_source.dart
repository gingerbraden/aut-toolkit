import 'dart:io';
import 'package:aut_toolkit/features/good_habits/data/model/good_habit_remote_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/model/sync_entity.dart';
import '../model/good_habit_entity.dart';

class GoodHabitRemoteSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String collectionPath = 'good_habits';

  GoodHabitRemoteSource({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile(File file, String folder, String filename) async {
    final ref = _storage.ref().child('$folder/$filename');
    final uploadTask = await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> createRemote(GoodHabitRemoteEntity entity, {File? file}) async {
    final docRef = entity.remoteId != null
        ? _firestore.collection(collectionPath).doc(entity.remoteId)
        : _firestore.collection(collectionPath).doc();
    Map<String, dynamic> data = _entityToMap(entity);
    await docRef.set(data);
    return docRef.id;
  }

  Future<void> updateRemote(GoodHabitRemoteEntity entity, {File? file}) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');
    final docRef = _firestore.collection(collectionPath).doc(entity.remoteId.toString());
    final data = _entityToMap(entity);

    await docRef.update(data);
  }

  Future<void> deleteRemote(GoodHabitEntity entity) async {
    if (entity.remoteId == null) {
      return;
    }
    final docRef = _firestore.collection(collectionPath).doc(entity.remoteId.toString());
    await docRef.delete();
  }

  Future<List<GoodHabitRemoteEntity>> getAllRemote({required String userId}) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => mapFromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching remote habits: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(GoodHabitRemoteEntity e) {
    return {
      'localId': e.localId,
      'from': e.from.toIso8601String(),
      'to': e.to?.toIso8601String(),
      'userId': e.userId,
      'name': e.name,
      'description': e.description,
      'isOccuringFlag': e.isOccuringFlag,
      'selectedPersonId': e.selectedPersonId,

      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
    };
  }


  GoodHabitRemoteEntity mapFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snap
      ) {
    final d = snap.data() ?? {};

    return GoodHabitRemoteEntity(
      localId: d['localId'] ?? 0,
      from: DateTime.parse(d['from']),
      to: d['to'] != null ? DateTime.parse(d['to']) : null,
      userId: d['userId'] ?? '',
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      isOccuringFlag: d['isOccuringFlag'] ?? false,
      selectedPersonId: d['selectedPersonId'] ?? 0,

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
