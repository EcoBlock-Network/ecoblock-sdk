import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/blog/presentation/pages/messaging_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'features/onboarding/presentation/pages/join_ecoblock_page.dart';
import 'package:ecoblock_mobile/services/locator.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _Bubble {
  _Bubble({required this.offset, required this.size, required this.delay, required this.duration, required this.curve});
  final Offset offset;
  final double size;
  final Duration delay;
  final Duration duration;
  final Curve curve;
}

class BubblesLayer extends StatefulWidget {
  const BubblesLayer({
    Key? key,
    required this.progress,
    required this.vsync,
    this.maxBubbles = 8,
  }) : super(key: key);

  final AnimationController progress;
  final TickerProvider vsync;
  final int maxBubbles;

  @override
  State<BubblesLayer> createState() => _BubblesLayerState();
}

class _BubblesLayerState extends State<BubblesLayer> with TickerProviderStateMixin {
  final List<_Bubble> _bubbles = [];
  final Random _rand = Random();
  late final AnimationController _spawnCtrl;
  final Duration _spawnInterval = const Duration(milliseconds: 220);
  DateTime _lastSpawn = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _spawnCtrl = AnimationController(vsync: widget.vsync, duration: const Duration(milliseconds: 400));
    widget.progress.addListener(_onProgress);
  }

  void _onProgress() {
    final t = widget.progress.value; // 0..1
  final target = (t * widget.maxBubbles).ceil();
    final now = DateTime.now();
    if (_bubbles.length < target && now.difference(_lastSpawn) >= _spawnInterval) {
      _lastSpawn = now;
      _addBubble();
    }
  }

  void _addBubble() {
    if (!mounted) return;
    final dx = (_rand.nextDouble() * 2) - 1; // -1..1
    final dy = (_rand.nextDouble() * 2) - 1;
    final size = 14 + _rand.nextDouble() * 36; // 14..50
    final delay = Duration(milliseconds: (_rand.nextInt(350)));
    final duration = Duration(milliseconds: 700 + _rand.nextInt(700));
    final curve = Curves.easeOutBack;
    final bubble = _Bubble(offset: Offset(dx, dy), size: size, delay: delay, duration: duration, curve: curve);
  if (_bubbles.length >= widget.maxBubbles) return;
  setState(() => _bubbles.add(bubble));
  }

  @override
  void dispose() {
    widget.progress.removeListener(_onProgress);
    _spawnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final media = MediaQuery.of(context);
  final reduced = media.accessibleNavigation;
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cx = constraints.maxWidth / 2;
          final cy = constraints.maxHeight / 2;
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: List.generate(_bubbles.length, (i) {
                final b = _bubbles[i];
                // map relative offset (-1..1) to pixels around the center; keep them mostly around center
                final radiusX = constraints.maxWidth * 0.48;
                final radiusY = constraints.maxHeight * 0.42;
                final x = b.offset.dx * radiusX;
                final y = b.offset.dy * radiusY;
                return Positioned(
                  left: cx + x - b.size / 2,
                  top: cy + y - b.size / 2,
                  child: _BubbleWidget(
                    key: ValueKey(b.hashCode),
                    size: b.size,
                    delay: b.delay,
                    duration: reduced ? const Duration(milliseconds: 120) : b.duration,
                    curve: b.curve,
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class _BubbleWidget extends StatefulWidget {
  const _BubbleWidget({Key? key, required this.size, required this.delay, required this.duration, required this.curve}) : super(key: key);
  final double size;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<_BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<_BubbleWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _scale = CurvedAnimation(parent: _ctrl, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5, curve: Curves.easeOut))),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.6, end: 1.0).animate(_scale),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.9),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Center(
            child: Icon(Icons.eco, size: widget.size * 0.5, color: Colors.green.shade700),
          ),
        ),
      ),
    );
  }
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
    // check if local node exists (async). If not, we'll show JoinEcoBlockPage after splash.
    _checkNodeInit();

    // show splash for 3 seconds
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
      // On error, default to requiring join to be safe.
      if (mounted) setState(() => _needsJoin = true);
    }
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
        : _needsJoin
          ? const JoinEcoBlockPage()
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
        // Use a Stack so the bubbles layer can fill the whole screen behind the centered logo
        child: Stack(
          alignment: Alignment.center,
          children: [
            // fullscreen bubble background
            BubblesLayer(
              progress: _progressCtrl,
              vsync: this,
              maxBubbles: 36,
            ),
            // centered content
            Center(
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
          ],
        ),
      ),
    );
  }
}