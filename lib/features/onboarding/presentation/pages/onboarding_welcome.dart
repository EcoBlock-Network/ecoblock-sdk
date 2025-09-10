import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class OnboardingWelcome extends StatelessWidget {
  final VoidCallback? onNext;

  const OnboardingWelcome({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 120),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    label: tr(context, 'onboarding.join.title'),
                    header: true,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withOpacity(0.95), Theme.of(context).colorScheme.primaryContainer.withOpacity(0.95)]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 8))],
                      ),
                      child: Center(child: Icon(Icons.eco, size: 64, color: Theme.of(context).colorScheme.onPrimary)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    tr(context, 'onboarding.join.title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'onboarding.join.subtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tr(context, 'onboarding.hint'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
