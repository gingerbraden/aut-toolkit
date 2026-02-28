import 'package:aut_toolkit/core/services/objectbox.dart';
import 'package:aut_toolkit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../i18n/strings.g.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") return t.account_with_email_exists;
      return e.message;
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUserSubcollection({
    required String uid,
    required String subcollectionName,
  }) async {
    final subcollectionRef = _firestore.collection(
      'users/$uid/$subcollectionName',
    );

    final snapshot = await subcollectionRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<String?> deleteAccount() async {
    try {
      final user = _auth.currentUser;

      final uid = user!.uid;

      await deleteUserSubcollection(uid: uid, subcollectionName: "user_cards");
      await deleteUserSubcollection(
        uid: uid,
        subcollectionName: "eating_habits",
      );
      await deleteUserSubcollection(
        uid: uid,
        subcollectionName: "challenging_behaviour",
      );
      await deleteUserSubcollection(
        uid: uid,
        subcollectionName: "selected_persons",
      );
      await deleteUserSubcollection(
        uid: uid,
        subcollectionName: "first_then_boards",
      );
      await deleteUserSubcollection(
        uid: uid,
        subcollectionName: "visual_lists",
      );
      await deleteUserSubcollection(
        uid: uid,
        subcollectionName: "aac_keyboards",
      );
      await deleteUserSubcollection(uid: uid, subcollectionName: "good_habits");

      await _firestore.collection('users').doc(uid).delete();

      final storageRef = _storage.ref().child('users/$uid');
      await _deleteFolderRecursive(storageRef);

      await objectbox.wipeAllData();

      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'requires-recent-login';
      }
      return e.message;
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  Future<void> _deleteFolderRecursive(Reference ref) async {
    final ListResult result = await ref.listAll();

    for (var item in result.items) {
      await item.delete();
    }

    for (var prefix in result.prefixes) {
      await _deleteFolderRecursive(prefix);
    }
  }

  Future<void> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }
}
