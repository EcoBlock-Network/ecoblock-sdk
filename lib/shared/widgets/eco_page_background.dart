import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/shared/widgets/animated_background.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

class EcoPageBackground extends StatelessWidget {
  final Widget child;
  final double topLeftDiameter;
  final Color? topLeftColor;
  final double bottomRightDiameter;
  final Color? bottomRightColor;

  const EcoPageBackground({
    required this.child,
    this.topLeftDiameter = 220,
    this.topLeftColor,
    this.bottomRightDiameter = 140,
    this.bottomRightColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final tlFallback = isDark
    ? AppColors.darkGlass.withValues(alpha: 0.12)
    : scheme.primary.withValues(alpha: 0.13);
  final brFallback = isDark
    ? AppColors.darkSurface.withValues(alpha: 0.10)
    : scheme.tertiaryContainer.withValues(alpha: 0.12);

  final tlColor = topLeftColor ?? tlFallback;
  final brColor = bottomRightColor ?? brFallback;

    return AnimatedEcoBackground(
      child: Stack(
        children: [
          Positioned(
            top: -70,
            left: -80,
            child: _BackgroundCircle(diameter: topLeftDiameter, color: tlColor),
          ),
          Positioned(
            bottom: -50,
            right: -40,
            child: _BackgroundCircle(
              diameter: bottomRightDiameter,
              color: brColor,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  const _BackgroundCircle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, AppColors.transparent],
          radius: 0.9,
        ),
      ),
    );
  }
}
