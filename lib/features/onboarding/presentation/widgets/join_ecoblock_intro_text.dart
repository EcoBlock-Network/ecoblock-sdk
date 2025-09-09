import 'package:flutter/cupertino.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

class JoinEcoBlockIntroText extends StatelessWidget {
  const JoinEcoBlockIntroText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '🌍 Bienvenue dans EcoBlock',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.greenStrong,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Associez votre appareil au réseau pour devenir un nœud actif. Aucun compte requis.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 18,
            color: AppColors.greenStrong,
          ),
        ),
      ],
    );
  }
}
