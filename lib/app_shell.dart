import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/blog/presentation/pages/blog_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'package:ecoblock_mobile/shared/widgets/app_nav_bar.dart';
import 'package:ecoblock_mobile/shared/widgets/splash_screen.dart';
import 'features/onboarding/presentation/pages/join_ecoblock_page.dart';
import 'package:ecoblock_mobile/services/locator.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 1;
  bool _showSplash = true;
  bool _needsJoin = false;

  static final List<Widget> _pages = [
    DashboardPage(),
    ProfilePage(),
    MessagingPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _checkNodeInit();

    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  Future<void> _checkNodeInit() async {
    try {
      final rustSvc = ref.read(rustBridgeServiceProvider);
      final initialized = await rustSvc.nodeIsInitialized();
      if (mounted && !initialized) {
        setState(() => _needsJoin = true);
      }
    } catch (_) {
      if (mounted) setState(() => _needsJoin = true);
    }
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
        : _needsJoin
          ? const JoinEcoBlockPage()
          : Scaffold(
            key: const ValueKey('main'),
            extendBody: true,
            body: _pages[_selectedIndex],
              bottomNavigationBar: AppNavBar(selectedIndex: _selectedIndex, onTap: _onItemTapped),
            ),
    );
  }
}