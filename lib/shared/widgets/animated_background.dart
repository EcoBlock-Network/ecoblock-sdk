import 'package:flutter/material.dart';
// theme tokens not required here; gradient uses Theme.of(context)

class AnimatedEcoBackground extends StatefulWidget {
  final Widget child;
  const AnimatedEcoBackground({required this.child, super.key});

  @override
  State<AnimatedEcoBackground> createState() => _AnimatedEcoBackgroundState();
}

class _AnimatedEcoBackgroundState extends State<AnimatedEcoBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
      final stopMid = 0.53 + 0.06 * (_controller.value - 0.5);
      final midColorA = Theme.of(context).colorScheme.background.withValues(alpha: 0.04);

        return Container(
          // keep background mostly transparent so Scaffold background shows
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                midColorA,
                Colors.transparent,
              ],
              stops: [0.0, stopMid.clamp(0.49, 0.59), 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}