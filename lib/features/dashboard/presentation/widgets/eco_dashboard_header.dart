import 'dart:ui';
import 'package:flutter/material.dart';

class EcoDashboardHeader extends StatelessWidget {
  final int currentLevel;
  const EcoDashboardHeader({required this.currentLevel, super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Row(
        children: [
          // Avatar glass & gradient
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [scheme.primary, scheme.tertiary, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha:0.28),
                  backgroundImage: AssetImage('assets/images/mock_story.png'),
                  radius: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My EcoNode",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Welcome to the EcoBlock mesh",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: scheme.onSurface.withValues(alpha:0.53),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.03,
                      ),
                ),
              ],
            ),
          ),
          // Level badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha:0.95),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha:0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.stars_rounded, color: Colors.yellow.shade200, size: 21),
                const SizedBox(width: 4),
                Text(
                  "Lv. $currentLevel",
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
