import 'package:aut_toolkit/features/settings/settings_page.dart';
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
    Center(child: Text(t.home)),
    const Center(child: Text('TODO')),
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
            label: t.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: t.kid_mode_button,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: t.settings,
          ),
        ],
      ),
    );
  }
}
