import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            BubblesLayer(progress: _progressCtrl, vsync: this, maxBubbles: 36),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_pulseCtrl, _progressCtrl]),
                    builder: (context, child) {
                      final scale = 0.95 + 0.12 * _pulseCtrl.value;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: LinearGradient(
                              colors: [AppColors.primary.withAlpha((0.28 * 255).toInt()), AppColors.white.withAlpha((0.06 * 255).toInt())],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: AppColors.primary.withAlpha((0.26 * 255).toInt()), width: 1.5),
                            boxShadow: [BoxShadow(color: AppColors.primary.withAlpha((0.18 * 255).toInt()), blurRadius: 24, offset: const Offset(0, 8))],
                          ),
                          child: Stack(alignment: Alignment.center, children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                value: _progressCtrl.value,
                                valueColor: AlwaysStoppedAnimation(AppColors.tertiary),
                                backgroundColor: AppColors.tertiary.withAlpha((0.18 * 255).toInt()),
                              ),
                            ),
                            Icon(Icons.eco, size: 56, color: AppColors.greenStrong),
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

class _Bubble {
  _Bubble({required this.offset, required this.size, required this.delay, required this.duration, required this.curve});
  final Offset offset;
  final double size;
  final Duration delay;
  final Duration duration;
  final Curve curve;
}

class BubblesLayer extends StatefulWidget {
  const BubblesLayer({Key? key, required this.progress, required this.vsync, this.maxBubbles = 8}) : super(key: key);
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
    final dx = (_rand.nextDouble() * 2) - 1;
    final dy = (_rand.nextDouble() * 2) - 1;
    final size = 14 + _rand.nextDouble() * 36;
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
            color: AppColors.white.withAlpha((0.9 * 255).toInt()),
            boxShadow: [BoxShadow(color: AppColors.black.withAlpha((0.06 * 255).toInt()), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Center(
            child: Icon(Icons.eco, size: widget.size * 0.5, color: AppColors.greenStrong),
          ),
        ),
      ),
    );
  }
}
