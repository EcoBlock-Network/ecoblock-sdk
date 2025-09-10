import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';

class JoinEcoBlockPage extends StatelessWidget {
  const JoinEcoBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: EcoPageBackground(
        child: const SizedBox.shrink(),
      ),
    );
  }
}
