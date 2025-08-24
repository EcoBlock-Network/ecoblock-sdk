// removed unused dart:ui import
import 'package:ecoblock_mobile/shared/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/eco_dashboard_header.dart';
import '../widgets/eco_section_title.dart';
import '../widgets/eco_progress_circle.dart';
import '../widgets/eco_daily_quests_list.dart';
import '../widgets/eco_unique_quests_list.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';


final dashboardProgressProvider = StateProvider<double>((ref) => 0.0);


class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: AnimatedEcoBackground(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -80,
              child: _DashboardCircle(
                  diameter: 220,
                  color: scheme.primary.withValues(alpha:0.13),
                ),
            ),
            Positioned(
              bottom: -50,
              right: -40,
              child: _DashboardCircle(
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
                      EcoSectionTitle(title: tr(context, 'daily_quests.title'), icon: Icons.eco),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: EcoDailyQuestsList(),
                      ),
                      const SizedBox(height: 28),
                      EcoSectionTitle(title: tr(context, 'unique_quests.title'), icon: Icons.star),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: EcoUniqueQuestsList(),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'profile.error'))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  const _DashboardCircle({required this.diameter, required this.color});
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

