import 'package:aut_toolkit/features/home/view/home_page.dart';
import 'package:aut_toolkit/features/settings/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/locale_change_notifier.dart';
import '../../../i18n/strings.g.dart';

class HomeNavigation extends ConsumerStatefulWidget {
  const HomeNavigation({super.key});

  @override
  ConsumerState<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends ConsumerState<HomeNavigation> {
  bool isLoading = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeChangeNotifierProvider);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: t.home),
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
