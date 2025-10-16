import 'package:aut_toolkit/app/router.dart';
import 'package:aut_toolkit/core/utils/scaffold_messenger_util.dart';
import 'package:aut_toolkit/core/utils/string_util.dart';
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
        actions: [
          _languagePopup()
        ],
      ),
      // appBar: AppBar(title: const Text('Firebase Auth Service')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ..._initialText(),
                ..._logInArea(),
                Padding(padding: const EdgeInsets.all(20.0), child: Divider()),
                ..._noAccountArea()
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _languagePopup() {
    return Padding(
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
    );
  }

  List<Widget> _initialText() {
    return [
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Text(
          t.good_day,
          style: Theme
              .of(context)
              .textTheme
              .displayLarge,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 45.0),
        child: Text(
          t.sign_in,
          style: Theme
              .of(context)
              .textTheme
              .titleLarge,
          textAlign: TextAlign.center,
        ),
      )
    ];
  }

  List<Widget> _logInArea() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextField(
          controller: loginEmailController,
          decoration: InputDecoration(labelText: t.email),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextField(
          controller: loginPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: t.password,
          ),
        ),
      ),
      const SizedBox(height: 25),
      ElevatedButton(
        onPressed: () async {
          _logIn();
        },
        child: Text(t.log_in_button),
      )
    ];
  }

  List<Widget> _noAccountArea() {
    return [
      Text(
        t.no_account,
        style: Theme
            .of(context)
            .textTheme
            .titleSmall,
        textAlign: TextAlign.center,
      ),
      TextButton(
        onPressed: () => {_showTwoTextFieldDialog(context)},
        child: Text(t.create_account),
      )
    ];
  }

  Future<void> _logIn() async {
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
        context,
        t.invalid_email_password,
      );
    }
  }

  void _showTwoTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.enter_details),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: signInEmailController,
                decoration: InputDecoration(labelText: t.email),
              ),
              TextField(
                controller: signInPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: t.password,
                ),
              ),
              TextField(
                controller: signInPasswordRepeatController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: t.password_again,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(t.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                _signIn();
              },
              child: Text(t.sign_in_button),
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
      ScaffoldMessengerUtils().showSnackBar(
        context,
        t.no_sign_in_details,
      );
    } else if (loginPasswordController.text.trim() !=
        signInPasswordRepeatController.text.trim()) {
      ScaffoldMessengerUtils().showSnackBar(
        context,
        t.passwords_dont_match,
      );
    } else if (!StringUtils().isMailValid(signInEmailController.text.trim())) {
      ScaffoldMessengerUtils().showSnackBar(
        context,
        t.invalid_mail,
      );
    } else if (loginPasswordController.text
        .trim()
        .length < 6) {
      ScaffoldMessengerUtils().showSnackBar(
        context,
        t.invalid_password,
      );
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
