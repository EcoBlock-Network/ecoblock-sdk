import 'dart:convert';
import 'package:flutter/services.dart';
import '../../quests/domain/entities/quest.dart';
import '../presentation/widgets/quest_types.dart';

class QuestService {
  Future<List<Quest>> loadPersonalQuests() async {
    final data = await rootBundle.loadString('assets/data/personal_quests.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Quest.fromJson(e)).toList();
  }

  Future<List<Quest>> loadCommunityQuests() async {
    final data = await rootBundle.loadString('assets/data/community_quests.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Quest.fromJson(e)).toList();
  }

  Future<List<Quest>> loadUniqueQuests() async {
    final data = await rootBundle.loadString('assets/data/unique_quests.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Quest.fromJson(e)).toList();
  }
}
