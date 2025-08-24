import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class EcoProgressCircle extends StatelessWidget {
  final int? xp;
  final int? level;
  final double? progress;
  final double size;

  const EcoProgressCircle({super.key, this.xp, this.level, this.progress, this.size = 140});

  int xpForLevel(int lvl) => 120 + 60 * (lvl - 1);

  Map<String, dynamic> levelAndProgressFromXP(int xp) {
    int level = 1;
    int total = 0;
    while (xp >= total + xpForLevel(level)) {
      total += xpForLevel(level);
      level++;
    }
    int xpCurrent = xp - total;
    int xpNeeded = xpForLevel(level);
    double progress = xpNeeded == 0 ? 0 : xpCurrent / xpNeeded;
    return {
      'level': level,
      'progress': progress,
      'xpCurrent': xpCurrent,
      'xpNeeded': xpNeeded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Determine display level/progress
    late final int displayLevel;
    late final double displayProgress;
    int xpCurrent = 0, xpNeeded = 0;

    if (xp != null) {
      final info = levelAndProgressFromXP(xp!);
      displayLevel = info['level'] as int;
      displayProgress = info['progress'] as double;
      xpCurrent = info['xpCurrent'] as int;
      xpNeeded = info['xpNeeded'] as int;
    } else {
      displayLevel = level ?? 1;
      displayProgress = progress ?? 0.0;
      xpCurrent = (displayProgress * xpForLevel(displayLevel)).round();
      xpNeeded = xpForLevel(displayLevel);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: size + 10,
              height: size + 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: displayProgress),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, val, _) {
              return CircularProgressIndicator(
                value: val,
                strokeWidth: 14,
                backgroundColor: scheme.surface.withValues(alpha: 0.14),
                valueColor: AlwaysStoppedAnimation(scheme.primary),
              );
            },
          ),
        ),
        // Icon, level and XP progress
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: size * 0.28, color: scheme.primary),
            const SizedBox(height: 6),
            Text(
              tr(context, 'level.display', {'level': displayLevel.toString()}),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              tr(context, 'xp.progress', {'current': xpCurrent.toString(), 'needed': xpNeeded.toString()}),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.primary.withValues(alpha: 0.68), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}