import 'dart:ui';
import 'package:flutter/material.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/scan/presentation/pages/scan_page.dart';
import 'features/messaging/presentation/pages/messaging_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/community/presentation/pages/community_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

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

  static const _navBarIcons = [
    Icons.dashboard_rounded,
    Icons.radar_rounded,
    Icons.account_circle_rounded,
    Icons.groups_rounded,
    Icons.message_rounded,
    Icons.settings_rounded,
  ];
  static const _navLabels = [
    'Home',
    'Scan',
    'Profile',
    'Community',
    'Messages',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body:  _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 13, right: 13, bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: scheme.primary.withValues(alpha:0.08), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha:0.10),
                    blurRadius: 22,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navBarIcons.length, (i) {
                  final selected = i == _selectedIndex;
                  return Flexible(
                    fit: FlexFit.tight,
                    child: _EcoNavBarItem(
                      icon: _navBarIcons[i],
                      label: _navLabels[i],
                      selected: selected,
                      onTap: () => _onItemTapped(i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EcoNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _EcoNavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: selected ? 8 : 12),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    scheme.primary.withValues(alpha:0.12),
                    scheme.primaryContainer.withValues(alpha:0.32),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha:0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              )
            : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            Icon(
              icon,
              size: selected ? 32 : 26,
              color: selected
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha:0.5),
              shadows: selected
                  ? [Shadow(color: scheme.primary.withValues(alpha:0.21), blurRadius: 8)]
                  : [],
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: selected ? 13.7 : 11.7,
                color: selected
                    ? scheme.primary
                    : scheme.onSurface.withValues(alpha:0.48),
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: selected ? 0.05 : 0.02,
                shadows: selected
                    ? [Shadow(color: scheme.primary.withValues(alpha:0.10), blurRadius: 5)]
                    : [],
              ),
              child: Text(label),
            ),
          ],
            ),
          ),
        ),
    );
  }
}