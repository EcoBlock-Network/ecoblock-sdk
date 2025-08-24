import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/quest.dart';

class QuestService {
  Future<List<Quest>> loadPersonalQuests() async {
    debugPrint('[QuestService] Chargement du JSON personal_quests.json...');
    try {
      final data = await rootBundle.loadString('assets/data/personal_quests.json');
      final List<dynamic> jsonList = json.decode(data);
      debugPrint('[QuestService] Quêtes trouvées dans le JSON: ${jsonList.length}');
      return jsonList.map((e) => Quest.fromJson(e)).toList();
    } catch (e) {
      debugPrint('[QuestService] Erreur lors du chargement: $e');
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
