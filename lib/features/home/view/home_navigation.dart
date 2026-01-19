import 'package:aut_toolkit/features/aac_keyboard/domain/model/aac_keyboard.dart';
import 'package:aut_toolkit/features/aac_keyboard/ui/view/aac_keyboard_main.dart';
import 'package:aut_toolkit/features/home/view/home_page.dart';
import 'package:aut_toolkit/features/settings/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/locale_change_notifier.dart';
import '../../../core/services/firebase_service.dart';
import '../../../i18n/strings.g.dart';

class HomeNavigation extends ConsumerStatefulWidget {
  const HomeNavigation({super.key});

  @override
  ConsumerState<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends ConsumerState<HomeNavigation> {
  bool isLoading = false;
  int _selectedIndex = 0;

  late final AACKeyboard _keyboard;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _keyboard = AACKeyboard(
      userId: FirebaseService().currentUser!.uid,
      name: "=",
      slots: [],
      updatedAt: DateTime.now(),
    );

    _pages = [
      const HomePage(),
      AACKeyboardMain(keyboard: _keyboard, goHome: () => _onItemTapped(0)),
      const SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(localeChangeNotifierProvider);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: isLandscape && _selectedIndex == 1
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: t.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.search),
                  label: t.kid_mode_button,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: t.settings,
                ),
              ],
            ),
    );
  }
}
