import '../models/quest_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Reads quests from local JSON assets
class LocalQuestDatasource {
  Future<List<QuestModel>> getPersonalQuests() async {
    final data = await rootBundle.loadString('assets/data/personal_quests.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => QuestModel.fromJson(e)).toList();
  }

  Future<List<QuestModel>> getCommunityQuests() async {
    final data = await rootBundle.loadString('assets/data/community_quests.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => QuestModel.fromJson(e)).toList();
  }
}
