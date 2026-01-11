import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/model/sync_entity.dart';
import '../model/eating_habit_entity.dart';
import '../model/eating_habit_remote_entity.dart';
class EatingHabitRemoteSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String collectionPath = 'eating_habits';

  EatingHabitRemoteSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile(File file, String folder, String filename) async {
    final ref = _storage.ref().child('$folder/$filename');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteRemoteImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      print("Error deleting image: ${e.code}");
    }
  }

  Future<String> createRemote(EatingHabitRemoteEntity entity) async {
    final docRef = entity.remoteId != null
        ? _firestore.collection(collectionPath).doc(entity.remoteId)
        : _firestore.collection(collectionPath).doc();

    await docRef.set(_entityToMap(entity));
    return docRef.id;
  }

  Future<void> updateRemote(EatingHabitRemoteEntity entity) async {
    if (entity.remoteId == null) throw ArgumentError('remoteId is null');

    final docRef =
    _firestore.collection(collectionPath).doc(entity.remoteId.toString());

    if ((entity.imageFilePath == null || (entity.imageFilePath != null && entity.imageFilePath!.isEmpty)) && entity.remoteImagePath != null && entity.remoteImagePath!.isNotEmpty) {
      await deleteRemoteImage(entity.remoteImagePath!);
    }

    await docRef.update(_entityToMap(entity));
  }

  Future<void> deleteRemote(EatingHabitEntity entity) async {
    if (entity.remoteId == null) return;

    final docRef = _firestore
        .collection(collectionPath)
        .doc(entity.remoteId.toString());

    await docRef.delete();

    if (entity.remoteImgPath != null && entity.remoteImgPath!.isNotEmpty) {
      await deleteRemoteImage(entity.remoteImgPath!);
    }
  }

  Future<List<EatingHabitRemoteEntity>> getAllRemote({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) => mapFromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching remote eating habits: $e');
      return [];
    }
  }

  Map<String, dynamic> _entityToMap(EatingHabitRemoteEntity e) {
    return {
      'localId': e.localId,
      'from': e.from.toIso8601String(),
      'to': e.to?.toIso8601String(),
      'isEatingFlag': e.isEatingFlag,
      'name': e.name,
      'description': e.description,
      'userId': e.userId,
      'selectedPersonId': e.selectedPersonId,
      'imageFilePath': e.imageFilePath,

      'isSynced': e.isSynced,
      'isDeleted': e.isDeleted,
      'pendingAction': e.pendingAction.index,
      'updatedAt': e.updatedAt.toIso8601String(),
      'remoteImgPath': e.remoteImagePath
    };
  }

  EatingHabitRemoteEntity mapFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    final d = snap.data() ?? {};

    return EatingHabitRemoteEntity(
      localId: d['localId'] ?? 0,
      from: DateTime.parse(d['from']),
      to: d['to'] != null ? DateTime.parse(d['to']) : null,
      isEatingFlag: d['isEatingFlag'] ?? false,
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      userId: d['userId'] ?? '',
      selectedPersonId: d['selectedPersonId'] ?? '',
      imageFilePath: d['imageFilePath'],
      updatedAt: d['updatedAt'] != null
          ? DateTime.parse(d['updatedAt'])
          : DateTime.now(),
      remoteImagePath: d['remoteImgPath']
    )
      ..remoteId = snap.id
      ..isSynced = true
      ..isDeleted = d['isDeleted'] ?? false
      ..pendingAction = PendingAction.values[d['pendingAction'] ?? 0];
  }
}

