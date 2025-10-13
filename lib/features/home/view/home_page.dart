import 'package:aut_toolkit/features/home/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/strings.g.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool isLoading = false;
  int _selectedIndex = 0;

  // Example pages for each tab
  final List<Widget> _pages = [
    const Center(child: Text('Dashboard')),
    const Center(child: Text('Search')),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Translations.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: Translations.of(context).kid_mode_button,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: Translations.of(context).settings,
          ),
        ],
      ),
    );
  }
}
