import 'package:aut_toolkit/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/theme_mode_notifier.dart';

class ThemeModeTile extends ConsumerStatefulWidget {
  const ThemeModeTile({super.key});

  @override
  ConsumerState<ThemeModeTile> createState() => _ThemeModeTileState();
}

class _ThemeModeTileState extends ConsumerState<ThemeModeTile> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeNotifierProvider); // watch provider
    final isDark = themeMode == ThemeMode.dark;

    return ListTile(
      leading: const Icon(Icons.dark_mode_outlined),
      title: Text(t.dark_mode_toggle),
      trailing: Switch(
        value: isDark,
        onChanged: (bool value) {
          final newTheme = value
              ? ThemeMode.dark
              : ThemeMode.light; // correct logic
          ref.read(themeModeNotifierProvider.notifier).changeTheme(newTheme);
        },
      ),
    );
  }
}
