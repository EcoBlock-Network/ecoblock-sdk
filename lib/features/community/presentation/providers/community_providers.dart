import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/community_local_datasource.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/entities/community_tree.dart';
import '../../domain/entities/mesh_map.dart';
import '../../domain/entities/reward.dart';
import '../../domain/entities/upcoming_quest.dart';
import '../../domain/entities/daily_quest.dart';

final _repoProvider = Provider<CommunityRepositoryImpl>((ref) {
  return CommunityRepositoryImpl(CommunityLocalDatasource());
});

final leaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final repo = ref.watch(_repoProvider);
  return repo.getLeaderboard();
});

final communityTreeProvider = FutureProvider<CommunityTree>((ref) async {
  final repo = ref.watch(_repoProvider);
  return repo.getCommunityTree();
});

final meshMapProvider = FutureProvider<MeshMap>((ref) async {
  final repo = ref.watch(_repoProvider);
  return repo.getMeshMap();
});

final communityRewardsProvider = FutureProvider<List<Reward>>((ref) async {
  final repo = ref.watch(_repoProvider);
  return repo.getRewards();
});

final upcomingQuestsProvider = FutureProvider<List<UpcomingQuest>>((ref) async {
  final repo = ref.watch(_repoProvider);
  return repo.getUpcomingQuests();
});

final dailyQuestsProvider = FutureProvider<List<DailyQuest>>((ref) async {
  final repo = ref.watch(_repoProvider);
  return repo.getDailyQuests();
});

// ReactionBar: Simulated provider for reactions
final reactionBarProvider = StateProvider<Map<String, int>>((ref) {
  return {'👍': 12, '❤️': 8, '🎉': 5};
});
