import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class EcoProgressCircle extends StatelessWidget {
  final int? xp;
  final int? xpBase;
  final int? level;
  final double? progress;
  final double size;

  const EcoProgressCircle({
    this.xp,
    this.xpBase,
    this.level,
    this.progress,
    this.size = 140,
    Key? key,
  }) : super(key: key);

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

    // Détermination du niveau/progression
    int displayLevel;
    double displayProgress;
    int xpCurrent = 0, xpNeeded = 0;

    if (xp != null) {
      final info = levelAndProgressFromXP(xp!);
      displayLevel = info['level'];
      displayProgress = info['progress'];
      xpCurrent = info['xpCurrent'];
      xpNeeded = info['xpNeeded'];
    } else {
      displayLevel = level ?? 1;
      displayProgress = progress ?? 0.0;
      xpCurrent = ((displayProgress) * xpForLevel(displayLevel)).round();
      xpNeeded = xpForLevel(displayLevel);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: size + 10,
              height: size + 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.11),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha:0.12),
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
            tween: Tween(begin: 0, end: displayProgress),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, val, _) {
              return CircularProgressIndicator(
                value: val,
                strokeWidth: 14,
                backgroundColor: scheme.surface.withValues(alpha:0.14),
                valueColor: AlwaysStoppedAnimation(scheme.primary),
              );
            },
          ),
        ),
        // Icone, niveau et XP progress
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: size * 0.32, color: scheme.primary),
            const SizedBox(height: 8),
            Text(tr(context, 'level.display', {'level': displayLevel.toString()}),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: scheme.primary,
                  letterSpacing: -0.3,
                )),
            const SizedBox(height: 3),
            Text(
              tr(context, 'xp.progress', {'current': xpCurrent.toString(), 'needed': xpNeeded.toString()}),
              style: TextStyle(
                fontSize: 12.2,
                color: scheme.primary.withValues(alpha:0.63),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}