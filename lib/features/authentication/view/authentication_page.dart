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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AppLocale _selectedLocale = AppLocale.sk;

  @override
  Widget build(BuildContext context) {
    // LocaleSettings.setLocaleRaw(AppLocale.sk.name);


    return Scaffold(
      appBar: AppBar(
        // title: Text("Authentication"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DropdownButton<AppLocale>(
              value: _selectedLocale,
              underline: const SizedBox(),
              // remove default underline
              icon: const Icon(Icons.language, color: Colors.black),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              // text color
              items: AppLocale.values.map((locale) {
                return DropdownMenuItem(
                  value: locale,
                  child: Text(
                    locale.name.toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (locale) {
                if (locale != null) {
                  setState(() {
                    _selectedLocale = locale;
                    LocaleSettings.setLocaleRaw(locale.name);
                  });
                }
              },
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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: Translations
                        .of(context)
                        .password,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String? result = await ref
                        .read(authentificationNotifierProvider.notifier)
                        .signIn(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
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
    TextEditingController _mailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordRepeatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _mailController,
                decoration: InputDecoration(labelText: "E-mail"),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: Translations
                      .of(context)
                      .password,
                ),
              ),
              TextField(
                controller: _passwordRepeatController,
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
                if ((_passwordController.text
                    .trim()
                    .isEmpty ||
                    _passwordRepeatController.text
                        .trim()
                        .isEmpty) ||
                    _mailController.text
                        .trim()
                        .isEmpty) {
                  ScaffoldMessengerUtils().showSnackBar(context, Translations
                      .of(context)
                      .no_sign_in_details);
                } else if (_passwordController.text.trim() !=
                    _passwordRepeatController.text.trim()) {
                  ScaffoldMessengerUtils().showSnackBar(context, Translations
                      .of(context)
                      .passwords_dont_match);
                } else if (!StringUtils().isMailValid(
                  _mailController.text.trim(),
                )) {
                  ScaffoldMessengerUtils().showSnackBar(context, Translations
                      .of(context)
                      .invalid_mail);
                } else if (_passwordController.text
                    .trim()
                    .length < 6) {
                  ScaffoldMessengerUtils().showSnackBar(context, Translations
                      .of(context)
                      .invalid_password);
                } else {
                  ref
                      .read(authentificationNotifierProvider.notifier)
                      .signUp(
                    _mailController.text.trim(),
                        _passwordController.text.trim(),
                  );
                  Navigator.of(context).pop();
                }
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
}
