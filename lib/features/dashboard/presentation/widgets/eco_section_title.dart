import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EcoSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const EcoSectionTitle({required this.title, required this.icon, super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 8, 0, 7),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 22),
          const SizedBox(width: 7),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: -0.2,
                ),
          ),
        ],
      ),
    );
  }
}
