import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class OnboardingFinish extends StatelessWidget {
  final VoidCallback? onBack;

  const OnboardingFinish({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tr(context, 'onboarding.welcome'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(tr(context, 'onboarding.privacy'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
