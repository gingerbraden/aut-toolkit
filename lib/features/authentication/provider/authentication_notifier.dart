import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';


class AuthentificationNotifier extends Notifier<User?> {
  final FirebaseService _firebaseService = FirebaseService();

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

  Future<void> signOut() async {
    await _firebaseService.signOut();
    state = null;
  }

  User? getUser() => state;
}

final authentificationNotifierProvider =
    NotifierProvider<AuthentificationNotifier, User?>(() {
      return AuthentificationNotifier();
    });
