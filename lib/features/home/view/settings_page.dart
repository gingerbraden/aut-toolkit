import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../i18n/strings.g.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool isLoading = false;
  AppLocale _selectedLocale = LocaleSettings.currentLocale;

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });

    await ref.read(authentificationNotifierProvider.notifier).signOut();

    setState(() {
      isLoading = false;
    });

    router.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authentificationNotifierProvider);
    final email = user?.email ?? 'Unknown user';

    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context).settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  Translations.of(context).signed_in_as,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: isLoading ? null : _signOut,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 48),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(Translations.of(context).log_out),
              ),
            ),
            Padding(padding: const EdgeInsets.all(25.0), child: Divider()),
            Row(
              children: [
                Text(
                  Translations.of(context).app_language,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<AppLocale>(
                    value: _selectedLocale, // currently selected value
                    onChanged: (AppLocale? locale) {
                      if (locale != null) {
                        setState(() {
                          _selectedLocale = locale;
                          LocaleSettings.setLocaleRaw(locale.name);
                        });
                      }
                    },
                    items: AppLocale.values.map((locale) {
                      return DropdownMenuItem<AppLocale>(
                        value: locale,
                        child: Text(locale.name.toUpperCase()),
                      );
                    }).toList(),

                    isExpanded: false, // keeps dropdown compact
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
