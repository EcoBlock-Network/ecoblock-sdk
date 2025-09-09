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
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final stopMid = 0.53 + 0.06 * (_controller.value - 0.5);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final midColorA = isDark
      ? Theme.of(context).colorScheme.background.withValues(alpha: 0.06)
      : Theme.of(context).colorScheme.background.withValues(alpha: 0.06);
    final midColorB = isDark
      ? Theme.of(context).colorScheme.background.withValues(alpha: 0.02)
      : Theme.of(context).colorScheme.background.withValues(alpha: 0.02);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.primaryContainer,
                midColorA,
                midColorB,
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