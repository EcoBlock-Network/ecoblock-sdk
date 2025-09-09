import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

class JoinEcoBlockInfoCard extends StatelessWidget {
  const JoinEcoBlockInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface.withAlpha((0.32 * 255).toInt())
          : Theme.of(context).colorScheme.background.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.black.withAlpha((0.18 * 255).toInt())
                        : AppColors.black.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Text(
                'ℹ️ Un nœud est un appareil qui rejoint le réseau local BLE. Il collecte et relaye des données écologiques anonymement.',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 15,
                  color: AppColors.greenStrong,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
