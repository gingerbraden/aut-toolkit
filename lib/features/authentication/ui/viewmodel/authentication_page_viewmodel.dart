import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/router_utils.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/string_util.dart';

class AuthenticationViewModel extends Notifier<bool> {
  late BuildContext context;

  void init(BuildContext ctx, WidgetRef r) {
    context = ctx;
  }

  Future<void> logIn(String email, String password) async {
    state = true;
    try {
      final result = await ref
          .read(authentificationNotifierProvider.notifier)
          .signIn(email.trim(), password.trim());

      if (result == null) {
        router.go(RouterUtils.HOME);
      } else {
        _showSnackBar(t.invalid_email_password);
      }
    } finally {
      state = false;
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String passwordRepeat,
  ) async {
    state = true;
    try {
      if (email.trim().isEmpty ||
          password.trim().isEmpty ||
          passwordRepeat.trim().isEmpty) {
        _showSnackBar(t.no_sign_in_details);
        return;
      }
      if (password.trim() != passwordRepeat.trim()) {
        _showSnackBar(t.passwords_dont_match);
        return;
      }
      if (!StringUtils().isMailValid(email.trim())) {
        _showSnackBar(t.invalid_mail);
        return;
      }
      if (password.trim().length < 6) {
        _showSnackBar(t.invalid_password);
        return;
      }

      await ref
          .read(authentificationNotifierProvider.notifier)
          .signUp(email.trim(), password.trim());

      Navigator.of(context).pop();
    } finally {
      state = false;
    }
  }

  void changeLocale(String localeName) {
    LocaleSettings.setLocaleRaw(localeName);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, showCloseIcon: true));
  }

  @override
  bool build() {
    return false;
  }
}

final authenticationViewModelProvider =
    NotifierProvider<AuthenticationViewModel, bool>(
      AuthenticationViewModel.new,
    );
