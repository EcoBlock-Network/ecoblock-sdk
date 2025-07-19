import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/community_tree_model.dart';
import '../models/mesh_map_model.dart';
import '../models/reward_model.dart';
import '../models/upcoming_quest_model.dart';
import '../models/daily_quest_model.dart';

class CommunityLocalDatasource {
  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    final data = await rootBundle.loadString('assets/community/leaderboard.json');
    final list = json.decode(data) as List;
    return list.map((e) => LeaderboardEntryModel.fromJson(e)).toList();
  }

  Future<CommunityTreeModel> getCommunityTree() async {
    // Simulate growth score
    return CommunityTreeModel(growthScore: 1850);
  }

  Future<MeshMapModel> getMeshMap() async {
    final data = await rootBundle.loadString('assets/community/mesh_map.json');
    final map = json.decode(data);
    return MeshMapModel.fromJson(map);
  }

  Future<List<RewardModel>> getRewards() async {
    final data = await rootBundle.loadString('assets/community/rewards.json');
    final list = json.decode(data) as List;
    return list.map((e) => RewardModel.fromJson(e)).toList();
  }

  Future<List<UpcomingQuestModel>> getUpcomingQuests() async {
    final data = await rootBundle.loadString('assets/community/upcoming_quests.json');
    final list = json.decode(data) as List;
    return list.map((e) => UpcomingQuestModel.fromJson(e)).toList();
  }

  Future<List<DailyQuestModel>> getDailyQuests() async {
    final data = await rootBundle.loadString('assets/community/daily_quests.json');
    final list = json.decode(data) as List;
    return list.map((e) => DailyQuestModel.fromJson(e)).toList();
  }
}
