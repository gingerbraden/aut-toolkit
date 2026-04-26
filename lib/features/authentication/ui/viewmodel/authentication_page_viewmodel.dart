import 'package:aut_toolkit/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/string_util.dart';

final authenticationViewModelProvider =
    NotifierProvider<AuthenticationViewModel, AuthenticationState>(
      AuthenticationViewModel.new,
    );

class AuthenticationViewModel extends Notifier<AuthenticationState> {
  @override
  AuthenticationState build() =>
      AuthenticationState(loading: false, isPasswordValid: true);

  Future<void> logIn(String email, String password) async {
    state = state.copyWith(loading: true, message: null);
    try {
      final result = await ref
          .read(authentificationNotifierProvider.notifier)
          .signIn(email.trim(), password.trim());

      if (result == null) {
        router.go(RouterUtils.HOME);
      } else {
        state = state.copyWith(message: t.invalid_email_password);
      }
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> logInGoogle() async {
    state = state.copyWith(loading: true, message: null);
    await ref.read(authentificationNotifierProvider.notifier).signInGoogle();
    state = state.copyWith(loading: false);

    router.go(RouterUtils.HOME);
  }

  Future<void> signUp(
    String email,
    String password,
    String passwordRepeat,
  ) async {
    state = state.copyWith(loading: true, message: null);
    try {
      if (email.trim().isEmpty ||
          password.trim().isEmpty ||
          passwordRepeat.trim().isEmpty) {
        state = state.copyWith(message: t.no_sign_in_details);
        return;
      }
      if (password != passwordRepeat) {
        state = state.copyWith(message: t.passwords_dont_match);
        return;
      }
      if (!StringUtils().isMailValid(email.trim())) {
        state = state.copyWith(message: t.invalid_mail);
        return;
      }
      if (password.trim().length < 6) {
        state = state.copyWith(message: t.invalid_password);
        return;
      }

      final error = await ref
          .read(authentificationNotifierProvider.notifier)
          .signUp(email.trim(), password.trim());

      if (error != null) {
        state = state.copyWith(message: error);
      } else {
        state = state.copyWith(message: t.registration_succesful);
      }
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  void changeLocale(String localeName) {
    LocaleSettings.setLocaleRaw(localeName);
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void resetPassword(String email) {
    ref.read(authentificationNotifierProvider.notifier).resetPassword(email);
  }

  void toggleIsPasswordValid(bool valid) =>
      state = state.copyWith(isPasswordValid: valid);
}

class AuthenticationState {
  final bool loading;
  final String? message;
  final bool isPasswordValid;

  AuthenticationState({
    required this.loading,
    this.message,
    required this.isPasswordValid,
  });

  AuthenticationState copyWith({
    bool? loading,
    String? message,
    bool? isPasswordValid,
  }) {
    return AuthenticationState(
      loading: loading ?? this.loading,
      message: message,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}
