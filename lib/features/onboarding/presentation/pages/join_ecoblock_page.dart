import 'package:ecoblock_mobile/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../../application/controllers/onboarding_controller.dart';

class JoinEcoBlockPage extends ConsumerWidget {
  const JoinEcoBlockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: EcoPageBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo / hero: leaf icon inside a circular surface
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.primary.withValues(alpha: 0.12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.eco,
                          size: 44,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      tr(context, 'onboarding.join.title'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr(context, 'onboarding.join.subtitle'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurface.withValues(alpha: 0.78)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // CTA
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scheme.primary,
                            foregroundColor: scheme.onPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 6,
                          ),
                          onPressed: () async {
                            await controller.associateNode();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
                            }
                          },
                          child: Text(tr(context, 'onboarding.join.cta'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Info card with steps
                    Card(
                      color: scheme.surfaceVariant,
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr(context, 'onboarding.join.how_it_works'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                            const SizedBox(height: 12),
                            _StepRow(label: tr(context, 'onboarding.step.create_node'), xp: 10, scheme: scheme),
                            const SizedBox(height: 8),
                            _StepRow(label: tr(context, 'onboarding.step.find_neighbors'), xp: 20, scheme: scheme),
                            const SizedBox(height: 8),
                            _StepRow(label: tr(context, 'onboarding.step.participate'), xp: 30, scheme: scheme),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    Text(
                      tr(context, 'onboarding.privacy'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.72)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String label;
  final int xp;
  final ColorScheme scheme;

  const _StepRow({required this.label, required this.xp, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.86)))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
    child: Text(tr(context, 'xp.short', {'xp': xp.toString()}), style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
