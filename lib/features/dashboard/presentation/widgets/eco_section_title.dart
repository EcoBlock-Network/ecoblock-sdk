import 'package:flutter/material.dart';


class EcoSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const EcoSectionTitle({required this.title, required this.icon, super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 0, 6),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary.withValues(alpha: 0.92), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }
}
