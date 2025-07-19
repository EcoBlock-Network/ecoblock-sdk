
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/badge_list_provider.dart';
import '../providers/loot_provider.dart';
import '../widgets/tree_growth_widget.dart';
import '../widgets/profile_widgets.dart';
import 'block_history_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final statsAsync = ref.watch(statsProvider);
    final badgesAsync = ref.watch(badgeListProvider);
    final lootAsync = ref.watch(lootProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                profileAsync.when(
                  data: (profile) => Row(
                    children: [
                      Hero(
                        tag: 'avatar',
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage(profile.avatar),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile.pseudonyme, style: Theme.of(context).textTheme.titleLarge),
                            Text('Mode anonyme', style: TextStyle(color: colorScheme.secondary)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Modifier'),
                      ),
                    ],
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur profil'),
                ),
                SizedBox(height: 24),
                // Tree animation
                statsAsync.when(
                  data: (stats) => TreeGrowthWidget(progression: stats.progression),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur stats'),
                ),
                SizedBox(height: 24),
                // Statistiques
                statsAsync.when(
                  data: (stats) => StatGrid(stats: stats),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur stats'),
                ),
                SizedBox(height: 24),
                // Badges
                badgesAsync.when(
                  data: (badges) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Badges', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 8),
                      BadgeList(badges: badges),
                    ],
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur badges'),
                ),
                SizedBox(height: 24),
                // Loots
                lootAsync.when(
                  data: (loot) => loot.isNotEmpty ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Loots', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 8),
                      LootList(loot: loot),
                    ],
                  ) : SizedBox.shrink(),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur loots'),
                ),
                SizedBox(height: 32),
                // Activité
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Activité', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 12),
                      GestureDetector(
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
                                  backgroundColor: colorScheme.primary.withOpacity(0.15),
                                  child: Icon(Icons.history, color: colorScheme.primary),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Historique des blocs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('Voir vos contributions au réseau mesh', style: TextStyle(color: colorScheme.secondary)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
