import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class OnboardingFeatures extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const OnboardingFeatures({super.key, this.onNext, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr(context, 'onboarding.hint'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            _FeatureCard(
              icon: Icons.security,
              title: tr(context, 'onboarding.step.create_node'),
              subtitle: tr(context, 'onboarding.join.subtitle'),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.group,
              title: tr(context, 'onboarding.step.find_neighbors'),
              subtitle: tr(context, 'onboarding.hint'),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.sync_alt,
              title: tr(context, 'onboarding.step.participate'),
              subtitle: tr(context, 'onboarding.privacy'),
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
  boxShadow: [BoxShadow(color: scheme.onSurface.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: scheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(fontSize: 14, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
