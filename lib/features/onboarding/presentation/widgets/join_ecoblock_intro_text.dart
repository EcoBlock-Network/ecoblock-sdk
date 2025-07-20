import 'package:flutter/cupertino.dart';

class JoinEcoBlockIntroText extends StatelessWidget {
  const JoinEcoBlockIntroText({Key? key}) : super(key: key);

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
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Associez votre appareil au réseau pour devenir un nœud actif. Aucun compte requis.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 18,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }
}
