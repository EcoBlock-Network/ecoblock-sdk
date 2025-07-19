import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/entities/community_tree.dart';
import '../../domain/entities/mesh_map.dart';
import '../../domain/entities/reward.dart';
import '../../domain/entities/upcoming_quest.dart';
import '../../domain/entities/daily_quest.dart';
import '../datasources/community_local_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityLocalDatasource localDatasource;

  CommunityRepositoryImpl(this.localDatasource);

  @override
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final models = await localDatasource.getLeaderboard();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CommunityTree> getCommunityTree() async {
    final model = await localDatasource.getCommunityTree();
    return model.toEntity();
  }

  @override
  Future<MeshMap> getMeshMap() async {
    final model = await localDatasource.getMeshMap();
    return model.toEntity();
  }

  @override
  Future<List<Reward>> getRewards() async {
    final models = await localDatasource.getRewards();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<UpcomingQuest>> getUpcomingQuests() async {
    final models = await localDatasource.getUpcomingQuests();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DailyQuest>> getDailyQuests() async {
    final models = await localDatasource.getDailyQuests();
    return models.map((m) => m.toEntity()).toList();
  }
}
