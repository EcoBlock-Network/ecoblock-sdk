
import 'package:ecoblock_mobile/features/profile/presentation/pages/block_history_page.dart';
import 'package:ecoblock_mobile/services/rust_bridge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/animated_background.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_dashboard_header.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_progress_circle.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_section_title.dart';
import '../providers/profile_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/badge_list_provider.dart';
import '../providers/loot_provider.dart';
import '../widgets/profile_widgets.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final statsAsync = ref.watch(statsProvider);
    final badgesAsync = ref.watch(badgeListProvider);
    final lootAsync = ref.watch(lootProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.background,
      body: AnimatedEcoBackground(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -80,
              child: _ProfileCircle(
                diameter: 220,
                color: scheme.primary.withOpacity(0.13),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -40,
              child: _ProfileCircle(
                diameter: 140,
                color: scheme.tertiaryContainer.withOpacity(0.12),
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
                      const SizedBox(height: 28),
                      // Section Statistiques
                      EcoSectionTitle(title: 'Statistiques', icon: Icons.bar_chart),
                      statsAsync.when(
                        data: (stats) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: StatGrid(stats: stats),
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => const Text('Erreur stats'),
                      ),
                      const SizedBox(height: 22),
                      // Section Badges
                      EcoSectionTitle(title: 'Badges', icon: Icons.emoji_events),
                      badgesAsync.when(
                        data: (badges) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: BadgeList(badges: badges),
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => const Text('Erreur badges'),
                      ),
                      const SizedBox(height: 22),
                      EcoSectionTitle(title: 'Loots', icon: Icons.card_giftcard),
                      lootAsync.when(
                        data: (loot) => loot.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 13),
                                child: LootList(loot: loot),
                              )
                            : const Center(child: Text('Aucun loot débloqué', style: TextStyle(color: Colors.grey))),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => const Text('Erreur loots'),
                      ),
                      const SizedBox(height: 28),
                      EcoSectionTitle(title: 'Activité', icon: Icons.history),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const BlockHistoryPage()),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: scheme.primary.withOpacity(0.15),
                                    child: Icon(Icons.history, color: scheme.primary),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Historique des blocs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        Text('Voir vos contributions au réseau mesh', style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const Center(child: Text('Erreur profil')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  const _ProfileCircle({required this.diameter, required this.color});
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
