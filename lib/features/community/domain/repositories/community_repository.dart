import '../entities/leaderboard_entry.dart';
import '../entities/community_tree.dart';
import '../entities/mesh_map.dart';
import '../entities/reward.dart';
import '../entities/upcoming_quest.dart';
import '../entities/daily_quest.dart';

abstract class CommunityRepository {
  Future<List<LeaderboardEntry>> getLeaderboard();
  Future<CommunityTree> getCommunityTree();
  Future<MeshMap> getMeshMap();
  Future<List<Reward>> getRewards();
  Future<List<UpcomingQuest>> getUpcomingQuests();
  Future<List<DailyQuest>> getDailyQuests();
}
