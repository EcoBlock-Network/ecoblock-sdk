import 'package:flutter/material.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/scan/presentation/pages/scan_page.dart';
import 'features/messaging/presentation/pages/messaging_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/community/presentation/pages/community_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    DashboardPage(),
    ScanPage(),
    ProfilePage(),
    CommunityPage(),
    MessagingPage(),
    SettingsPage(),
  ];

  static final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Accueil'),
    BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Scan'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profil'),
    BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Communauté'),
    BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Réglages'),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withOpacity(0.6),
        backgroundColor: scheme.surface,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}