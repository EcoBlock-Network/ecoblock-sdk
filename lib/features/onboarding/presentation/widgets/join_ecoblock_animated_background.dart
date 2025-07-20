import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// TODO: Intégrer Rive ou Lottie si disponible

class JoinEcoBlockAnimatedBackground extends StatelessWidget {
  const JoinEcoBlockAnimatedBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA5D6A7), Color(0xFFB2EBF2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(CupertinoIcons.tree, size: 180, color: Color(0xFF2E7D32).withOpacity(0.15)),
      ),
    );
  }
}
