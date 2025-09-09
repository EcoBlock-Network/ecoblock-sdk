import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/core/ux/motion.dart';

class EcoProgressPill extends StatelessWidget {
  final double progress; // 0..1
  final Color badgeColor;
  final bool showGlow;
  final bool small;
  final Animation<double>? pulseAnim;
  final bool reduceMotion;

  const EcoProgressPill({super.key, required this.progress, required this.badgeColor, this.showGlow = false, this.small = false, this.pulseAnim, this.reduceMotion = false});

  @override
  Widget build(BuildContext context) {
    final barHeight = small ? 28.0 : 34.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            height: barHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.04),
              borderRadius: BorderRadius.circular(barHeight / 2),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                width: constraints.maxWidth * value,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [badgeColor, badgeColor.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(barHeight / 2),
                  boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))],
                ),
              );
            },
          ),
          if (showGlow)
            Positioned(
              left: 0,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: AppMotion.short,
                  opacity: showGlow ? 0.9 : 0.0,
                  child: Container(
                    width: constraints.maxWidth * progress,
                    height: barHeight,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [badgeColor.withOpacity(0.14), Colors.transparent], radius: 0.9),
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 8,
            child: pulseAnim == null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Row(
                      children: [
                        Text('${(progress * 100).round()}%', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w800, fontSize: small ? 12 : 14)),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_upward, size: small ? 12 : 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)),
                      ],
                    ),
                  )
                : ScaleTransition(
                    scale: pulseAnim!,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.03)),
                      ),
                      child: Row(
                        children: [
                          Text('${(progress * 100).round()}%', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w800, fontSize: small ? 12 : 14)),
                          const SizedBox(width: 6),
                          Icon(Icons.arrow_upward, size: small ? 12 : 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
