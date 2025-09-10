// removed unused dart:ui import
import 'dart:ui';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/eco_dashboard_header.dart';
import '../widgets/eco_section_title.dart';
import '../widgets/eco_progress_circle.dart';
import '../widgets/eco_daily_quests_list.dart';
import '../widgets/eco_unique_quests_list.dart';
import 'package:ecoblock_mobile/features/quests/presentation/pages/unique_quests_page.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ecoblock_mobile/features/profile/presentation/widgets/node_card.dart';


final dashboardProgressProvider = StateProvider<double>((ref) => 0.0);


class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: scheme.background,
      
      body: EcoPageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: profileAsync.when(
              data: (profile) => LayoutBuilder(builder: (ctx, constraints) {
                final isWide = constraints.maxWidth > 900;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EcoDashboardHeader(currentLevel: profile.niveau),
                    const SizedBox(height: 18),
                    // hero-like node card (simple inline)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: NodeCard(nodeId: profile.userId, addr: profile.pseudonyme, latency: '—', connected: false),
                    ),
                    const SizedBox(height: 18),
                    // styled progress card + responsive layout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: isWide
                          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(child: _ProgressCard(profile: profile)),
                              const SizedBox(width: 16),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                _GlassSection(child: Column(children: [EcoSectionTitle(title: tr(context, 'daily_quests.title'), icon: Icons.eco), const SizedBox(height: 8), EcoDailyQuestsList()]))
                              ])),
                            ])
                          : Column(children: [
                              _ProgressCard(profile: profile),
                              const SizedBox(height: 18),
                              _GlassSection(child: Column(children: [EcoSectionTitle(title: tr(context, 'daily_quests.title'), icon: Icons.eco), const SizedBox(height: 8), Padding(padding: const EdgeInsets.symmetric(horizontal: 13), child: EcoDailyQuestsList())])),
                            ]),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _GlassSection(child: Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            EcoSectionTitle(title: tr(context, 'unique_quests.title'), icon: Icons.star),
                            TextButton(onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => UniqueQuestsPage()));
                            }, child: Text(tr(context, 'see_more'))),
                          ]),
                          const SizedBox(height: 8),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: EcoUniqueQuestsList())
                        ])),
                      ]),
                    ),
                    const SizedBox(height: 36),
                  ],
                );
              }),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(tr(context, 'profile.error'))),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final dynamic profile;
  const _ProgressCard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final xp = profile.xp ?? 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [scheme.surface.withOpacity(0.06), scheme.surface.withOpacity(0.02)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.onSurface.withOpacity(0.06)),
            boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.02), blurRadius: 18, offset: const Offset(0, 10))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text('Progression', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const Spacer(), Text('Objectif mensuel', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))]),
            const SizedBox(height: 12),
            Center(child: EcoProgressCircle(xp: xp, size: 150)),
            const SizedBox(height: 12),
            Row(children: [Expanded(child: Text('XP: $xp', style: Theme.of(context).textTheme.bodyLarge)), ElevatedButton(onPressed: () {}, child: const Text('Voir détails'))]),
          ]),
        ),
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  final Widget child;
  const _GlassSection({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [scheme.surface.withOpacity(0.04), scheme.surface.withOpacity(0.02)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.onSurface.withOpacity(0.06)),
          ),
          child: child,
        ),
      ),
    );
  }
}
