import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/animated_background.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_dashboard_header.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_progress_circle.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_section_title.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: scheme.background,
      body: AnimatedEcoBackground(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -80,
              child: _OnboardingCircle(
                diameter: 220,
                color: scheme.primary.withValues(alpha:0.13),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -40,
              child: _OnboardingCircle(
                diameter: 140,
                color: scheme.tertiaryContainer.withValues(alpha:0.12),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16, bottom: 12),
                child: profileAsync.when(
                  data: (profile) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EcoDashboardHeader(currentLevel: profile.niveau),
                      const SizedBox(height: 22),
                      Center(child: EcoProgressCircle(xp: profile.xp)),
                      const SizedBox(height: 13),
                      const SizedBox(height: 28),
                      EcoSectionTitle(title: 'Welcome to EcoBlock', icon: Icons.eco),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          "Let's get started! Complete your profile and discover your first quests.",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurface.withValues(alpha:0.7),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Add onboarding steps or actions here
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Start my adventure'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          onPressed: () {
                            // TODO: Navigate to main dashboard or next onboarding step
                          },
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Profile error')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  const _OnboardingCircle({required this.diameter, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          radius: 0.9,
        ),
      ),
    );
  }
}
