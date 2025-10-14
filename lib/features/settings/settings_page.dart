import 'package:aut_toolkit/features/authentication/provider/authentication_notifier.dart';
import 'package:aut_toolkit/features/settings/app_language_tile.dart';
import 'package:aut_toolkit/features/settings/log_out_tile.dart';
import 'package:aut_toolkit/features/settings/theme_mode_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authentificationNotifierProvider);
    final email = user?.email ?? 'Unknown user';

    return Scaffold(
      appBar: AppBar(title: Text(t.settings), elevation: 0),
      body: ListView(
        children: [
          // User section
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(
              t.signed_in_as,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(email),
          ),

          const Divider(),
          // Log out button
          LogOutTile(),
          const Divider(),
          // Language setting
          AppLanguageTile(),
          const Divider(),
          ThemeModeTile(),
          const Divider()
        ],
      ),
    );
  }
}
