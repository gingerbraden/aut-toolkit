import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../i18n/strings.g.dart';
import '../viewmodel/authentication_page_viewmodel.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends ConsumerState<AuthenticationPage> {
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signInPasswordRepeatController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(authenticationViewModelProvider.notifier);

    ref.listen<AuthenticationState>(authenticationViewModelProvider, (previous, next) {
      if (next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
          ),
        );
        if (t.registration_succesful == next.message) {
          Navigator.of(context).pop();
        }
        viewModel.clearMessage();
      }
    });

    return Scaffold(
      appBar: AppBar(actions: [_languagePopup(viewModel)]),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.BASE_APP_UI_PADDING,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ..._initialText(),
                ..._logInArea(viewModel),
                const Padding(padding: EdgeInsets.all(20.0), child: Divider()),
                ..._noAccountArea(viewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _languagePopup(AuthenticationViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: PopupMenuButton<AppLocale>(
        onSelected: (locale) => viewModel.changeLocale(locale.name),
        itemBuilder: (BuildContext context) => AppLocale.values
            .map(
              (locale) => PopupMenuItem<AppLocale>(
                value: locale,
                child: Text(locale.name.toUpperCase()),
              ),
            )
            .toList(),
        icon: const Icon(Icons.language),
      ),
    );
  }

  List<Widget> _initialText() => [
    Padding(
      padding: const EdgeInsets.all(25.0),
      child: Text(t.good_day, style: Theme.of(context).textTheme.displayLarge),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 45.0),
      child: Text(
        t.sign_in,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    ),
  ];

  List<Widget> _logInArea(AuthenticationViewModel viewModel) => [
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
        decoration: InputDecoration(labelText: t.password),
      ),
    ),
    const SizedBox(height: 25),
    Consumer(
      builder: (context, ref, _) {
        final isLoading = ref.watch(authenticationViewModelProvider).loading;
        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () => viewModel.logIn(
                  loginEmailController.text,
                  loginPasswordController.text,
                ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(t.log_in_button),
        );
      },
    ),
  ];

  List<Widget> _noAccountArea(AuthenticationViewModel viewModel) => [
    Text(
      t.no_account,
      style: Theme.of(context).textTheme.titleSmall,
      textAlign: TextAlign.center,
    ),
    TextButton(
      onPressed: () => _showSignUpDialog(viewModel),
      child: Text(t.create_account),
    ),
  ];

  void _showSignUpDialog(AuthenticationViewModel viewModel) {
    final isLoading = ref.watch(authenticationViewModelProvider).loading;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              decoration: InputDecoration(labelText: t.password),
            ),
            TextField(
              controller: signInPasswordRepeatController,
              obscureText: true,
              decoration: InputDecoration(labelText: t.password_again),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              signInPasswordController.clear();
              signInPasswordRepeatController.clear();
              signInEmailController.clear();
              Navigator.of(context).pop();
            },
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () => viewModel.signUp(
                    signInEmailController.text,
                    signInPasswordController.text,
                    signInPasswordRepeatController.text,
                  ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(t.sign_in_button),
          ),
        ],
      ),
    );
  }
}
