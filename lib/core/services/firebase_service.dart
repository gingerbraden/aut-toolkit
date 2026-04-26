import 'package:aut_toolkit/core/services/objectbox.dart';
import 'package:aut_toolkit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../i18n/strings.g.dart';

enum SignInMethod { google, email, none }

/// Service wrapper for Firebase features.
///
/// Mainly used for the authentication methods in the Auth screen, but also
/// used for accessing the FirebaseAuth instance for getting the current user data.
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

  /// Method used to recursively delete all user's subcollections
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

  SignInMethod checkSignInProvider() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return SignInMethod.none;
    }

    List<UserInfo> providerData = user.providerData;

    bool signedInWithGoogle = providerData.any(
      (p) => p.providerId == 'google.com',
    );
    bool signedInWithEmailPassword = providerData.any(
      (p) => p.providerId == 'password',
    );

    if (signedInWithGoogle) return SignInMethod.google;
    if (signedInWithEmailPassword) return SignInMethod.email;
    return SignInMethod.none;
  }

  Future<void> reauthenticateWithGoogle() async {
    final user = FirebaseAuth.instance.currentUser;

    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user!.reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateUser(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        rethrow;
      }
    }
  }
}
