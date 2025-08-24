import 'package:flutter/material.dart';

class EcoHeroAvatar extends StatelessWidget {
  final String image;
  const EcoHeroAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {}, // intentionally empty: improves a11y/tap target
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12), width: 2),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
