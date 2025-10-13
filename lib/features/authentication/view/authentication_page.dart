import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/ScaffoldMessengerUtils.dart';
import 'package:aut_toolkit/core/utils/StringUtils.dart';
import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<AuthenticationPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<AuthenticationPage> {
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signInPasswordRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // title: Text("Authentication"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PopupMenuButton<AppLocale>(
              onSelected: (locale) {
                setState(() {
                  LocaleSettings.setLocaleRaw(locale.name);
                });
              },
              itemBuilder: (BuildContext context) =>
                  AppLocale.values.map((locale) {
                    return PopupMenuItem<AppLocale>(
                      value: locale,
                      child: Text(locale.name.toUpperCase()),
                    );
                  }).toList(),
              icon: const Icon(Icons.language),
            ),
          ),
        ],
      ),
      // appBar: AppBar(title: const Text('Firebase Auth Service')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    Translations
                        .of(context)
                        .good_day,
                    style: Theme
                        .of(context)
                        .textTheme
                        .displayLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 45.0),
                  child: Text(
                    Translations
                        .of(context)
                        .sign_in,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: loginEmailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: loginPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: Translations
                          .of(context)
                          .password,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    String? result = await ref
                        .read(authentificationNotifierProvider.notifier)
                        .signIn(
                      loginEmailController.text.trim(),
                      loginPasswordController.text.trim(),
                    );
                    if (result == null) {
                      router.go('/home');
                    } else {
                      ScaffoldMessengerUtils().showSnackBar(
                          context, Translations
                          .of(context)
                          .invalid_email_password);
                    };
                  },
                  child: Text(Translations
                      .of(context)
                      .log_in_button),
                ),
                Padding(padding: const EdgeInsets.all(20.0), child: Divider()),
                Text(
                  Translations
                      .of(context)
                      .no_account,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => {_showTwoTextFieldDialog(context)},
                  child: Text(Translations
                      .of(context)
                      .create_account),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTwoTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: signInEmailController,
                decoration: InputDecoration(labelText: "E-mail"),
              ),
              TextField(
                controller: signInPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: Translations
                      .of(context)
                      .password,
                ),
              ),
              TextField(
                controller: signInPasswordRepeatController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: Translations
                      .of(context)
                      .password_again,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Translations
                  .of(context)
                  .cancel),
            ),
            ElevatedButton(
              onPressed: () {
                _signIn();
              },
              child: Text(Translations
                  .of(context)
                  .sign_in_button),
            ),
          ],
        );
      },
    );
  }

  void _signIn() {
    if ((loginPasswordController.text
        .trim()
        .isEmpty ||
        signInPasswordRepeatController.text
            .trim()
            .isEmpty) ||
        signInEmailController.text
            .trim()
            .isEmpty) {
      ScaffoldMessengerUtils().showSnackBar(context, Translations
          .of(context)
          .no_sign_in_details);
    } else if (loginPasswordController.text.trim() !=
        signInPasswordRepeatController.text.trim()) {
      ScaffoldMessengerUtils().showSnackBar(context, Translations
          .of(context)
          .passwords_dont_match);
    } else if (!StringUtils().isMailValid(
      signInEmailController.text.trim(),
    )) {
      ScaffoldMessengerUtils().showSnackBar(context, Translations
          .of(context)
          .invalid_mail);
    } else if (loginPasswordController.text
        .trim()
        .length < 6) {
      ScaffoldMessengerUtils().showSnackBar(context, Translations
          .of(context)
          .invalid_password);
    } else {
      ref
          .read(authentificationNotifierProvider.notifier)
          .signUp(
        signInEmailController.text.trim(),
        loginPasswordController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

}
