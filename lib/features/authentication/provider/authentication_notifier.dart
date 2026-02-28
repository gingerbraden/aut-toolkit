import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/services/firebase_service.dart';

class AuthentificationNotifier extends Notifier<User?> {
  final FirebaseService _firebaseService = FirebaseService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  User? build() {
    return _firebaseService.currentUser;
  }

  Future<String?> signUp(String email, String password) async {
    final error = await _firebaseService.signUp(
      email: email,
      password: password,
    );
    if (error == null) {
      state = _firebaseService.currentUser;
    }
    return error;
  }

  Future<String?> signIn(String email, String password) async {
    final user = await _firebaseService.signIn(
      email: email,
      password: password,
    );
    if (user != null) {
      state = user;
      return null;
    }
    return 'Sign-in failed';
  }

  Future<void> signInGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) return;

      state = firebaseUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    await _googleSignIn.signOut();
    state = null;
  }

  User? getUser() => state;

  Future<String?> deleteAccount() async {
    final result = await _firebaseService.deleteAccount();

    if (result == null) {
      await _googleSignIn.signOut();
      state = null;
    }

    return result;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseService.resetPassword(email);
  }
}

final authentificationNotifierProvider =
    NotifierProvider<AuthentificationNotifier, User?>(() {
      return AuthentificationNotifier();
    });
