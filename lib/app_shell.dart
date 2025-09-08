import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/messaging/presentation/pages/messaging_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 1;
  bool _showSplash = true;

  static final List<Widget> _pages = [
    DashboardPage(),
    ProfilePage(),
    MessagingPage(),
    SettingsPage(),
  ];

  static const _navBarIcons = [
    Icons.dashboard_rounded,
    Icons.account_circle_rounded,
    Icons.message_rounded,
    Icons.settings_rounded,
  ];
  static const _navLabels = [
    'Home',
    'Profile',
    'News',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    // show splash for 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
          : Scaffold(
              key: const ValueKey('main'),
              extendBody: true,
              body: _pages[_selectedIndex],
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 13, right: 13, bottom: 12 + bottomInset),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      height: 64 + bottomInset,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: scheme.primary.withValues(alpha: 0.08), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.10),
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
    Key? key,
  }) : super(key: key);

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
                      scheme.primary.withValues(alpha: 0.12),
                      scheme.primaryContainer.withValues(alpha: 0.32),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.10),
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
                color: selected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.5),
                shadows: selected ? [Shadow(color: scheme.primary.withValues(alpha: 0.21), blurRadius: 8)] : [],
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: selected ? 13.7 : 11.7,
                  color: selected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.48),
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  letterSpacing: selected ? 0.05 : 0.02,
                  shadows: selected ? [Shadow(color: scheme.primary.withValues(alpha: 0.10), blurRadius: 5)] : [],
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final AnimationController _progressCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _pulseCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) _pulseCtrl.reverse();
      if (s == AnimationStatus.dismissed) _pulseCtrl.forward();
    });
    _pulseCtrl.forward();

    // progress controller: single sweep from 0 -> 1 over 3 seconds
    _progressCtrl.forward();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: EcoPageBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_pulseCtrl, _progressCtrl]),
                builder: (context, child) {
                  final scale = 0.95 + 0.12 * _pulseCtrl.value;
                  // glass-morphism circle
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(
                          colors: [Colors.greenAccent.shade100.withOpacity(0.28), Colors.white.withOpacity(0.06)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.greenAccent.shade100.withOpacity(0.26), width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.green.shade50.withOpacity(0.18), blurRadius: 24, offset: const Offset(0, 8))],
                        // backdrop blur is handled by EcoPageBackground; we keep a soft glass effect
                      ),
                      child: Stack(alignment: Alignment.center, children: [
                        // progress ring (single sweep)
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            value: _progressCtrl.value,
                            valueColor: AlwaysStoppedAnimation(Colors.greenAccent.shade200),
                            backgroundColor: Colors.greenAccent.shade100.withOpacity(0.18),
                          ),
                        ),
                        Icon(Icons.eco, size: 56, color: Colors.green.shade700),
                      ]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              Text('EcoBlock', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}