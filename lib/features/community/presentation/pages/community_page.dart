import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/community/presentation/providers/community_providers.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/daily_quests_widget.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/leaderboard_list.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/community_tree_widget.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/mesh_map_widget.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/community_rewards_widget.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/upcoming_quests_widget.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/reaction_bar.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';


class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // theme scheme not used directly here
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'community.title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, ref, _) {
            final dailyQuestsAsync = ref.watch(dailyQuestsProvider);
            final leaderboardAsync = ref.watch(leaderboardProvider);
            final treeAsync = ref.watch(communityTreeProvider);
            final meshAsync = ref.watch(meshMapProvider);
            final rewardsAsync = ref.watch(communityRewardsProvider);
            final upcomingAsync = ref.watch(upcomingQuestsProvider);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Daily Quests
                dailyQuestsAsync.when(
                  data: (quests) => DailyQuestsWidget(quests: quests),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'community.loading_challenges'))), 
                ),
                const SizedBox(height: 24),
                // Section 2: Leaderboard
                leaderboardAsync.when(
                  data: (entries) {
                    // Simule l'utilisateur courant (ex: id = '7')
                    const currentUserId = '7';
                    final userIndex = entries.indexWhere((e) => e.id == currentUserId);
                    final userEntry = userIndex != -1 ? entries[userIndex] : null;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(tr(context, 'community.leaderboard.title'), style: Theme.of(context).textTheme.titleMedium),
                        LeaderboardList(entries: entries),
                        const SizedBox(height: 8),
                        if (userEntry != null)
                            Text(tr(context, 'community.rank', {'rank': (userIndex + 1).toString(), 'pseudo': userEntry.pseudo}), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        if (userEntry == null)
                            Text(tr(context, 'community.not_in_top_10'), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'community.error_leaderboard'))), 
                ),
                const SizedBox(height: 24),
                // Section 3: Community Tree
                treeAsync.when(
                  data: (tree) => CommunityTreeWidget(tree: tree),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'community.error_tree'))), 
                ),
                const SizedBox(height: 24),
                // Section 4: Mesh Map
                meshAsync.when(
                  data: (mesh) => MeshMapWidget(meshMap: mesh),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'community.error_mesh_map'))), 
                ),
                const SizedBox(height: 24),
                // Section 5: Community Rewards
                rewardsAsync.when(
                  data: (rewards) => treeAsync.maybeWhen(
                    data: (tree) => CommunityRewardsWidget(rewards: rewards, currentScore: tree.growthScore),
                    orElse: () => Container(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'community.error_rewards'))), 
                ),
                const SizedBox(height: 24),
                // Section 6: Upcoming Quests
                upcomingAsync.when(
                  data: (quests) => UpcomingQuestsWidget(quests: quests),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(tr(context, 'community.error_history'))), 
                ),
                const SizedBox(height: 24),
                // Section 7: Reaction Bar
                const Center(child: ReactionBar()),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
