import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/quest.dart';

class QuestService {
  Future<List<Quest>> loadPersonalQuests() async {
    print('[QuestService] Chargement du JSON personal_quests.json...');
    try {
      final data = await rootBundle.loadString('assets/data/personal_quests.json');
      final List<dynamic> jsonList = json.decode(data);
      print('[QuestService] Quêtes trouvées dans le JSON: [1m${jsonList.length}[0m');
      return jsonList.map((e) => Quest.fromJson(e)).toList();
    } catch (e) {
      print('[QuestService] Erreur lors du chargement: $e');
      return [];
    }
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
