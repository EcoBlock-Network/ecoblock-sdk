import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuestProgressService {
  static const _prefsKey = 'quest_progress_map';

  Future<Map<String, int>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null || jsonString.isEmpty) return {};
    final Map<String, dynamic> map = json.decode(jsonString) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, (v as num).toInt()));
  }

  Future<void> saveProgress(Map<String, int> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(progress));
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
