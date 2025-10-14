import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';

class AppLanguageTile extends StatefulWidget {
  const AppLanguageTile({super.key});

  @override
  State<AppLanguageTile> createState() => _AppLanguageTileState();
}

class _AppLanguageTileState extends State<AppLanguageTile> {
  AppLocale _selectedLocale = LocaleSettings.currentLocale;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(t.change_app_language),
      subtitle: Text(_selectedLocale.name.toUpperCase()),
      onTap: () => _showLanguageDialog(context),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    AppLocale? selected = _selectedLocale;

    final chosenLocale = await showDialog<AppLocale>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.app_language),
          content: RadioGroup<AppLocale>(
            groupValue: selected,
            onChanged: (AppLocale? value) {
              Navigator.of(context).pop(value);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLocale.values.map((locale) {
                return RadioListTile<AppLocale>(
                  title: Text(locale.name.toUpperCase()),
                  value: locale,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.cancel),
            ),
          ],
        );
      },
    );

    if (chosenLocale != null && chosenLocale != _selectedLocale) {
      setState(() {
        _selectedLocale = chosenLocale;
        LocaleSettings.setLocaleRaw(chosenLocale.name);
      });
    }
  }
}
