import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuestPersistenceState {
  final List<String?> visibleQuestIds;
  final List<DateTime?> deletedTimes;

  QuestPersistenceState({
    required this.visibleQuestIds,
    required this.deletedTimes,
  });

  Map<String, dynamic> toJson() => {
        'visibleQuestIds': visibleQuestIds,
        'deletedTimes': deletedTimes.map((d) => d?.toIso8601String()).toList(),
      };

  factory QuestPersistenceState.fromJson(Map<String, dynamic> json) => QuestPersistenceState(
        visibleQuestIds: List<String?>.from(json['visibleQuestIds'] ?? [null, null, null]),
        deletedTimes: (json['deletedTimes'] as List?)?.map((s) => s == null || s == '' ? null : DateTime.tryParse(s)).toList() ?? [null, null, null],
      );

  static QuestPersistenceState initial() => QuestPersistenceState(
        visibleQuestIds: [null, null, null],
        deletedTimes: [null, null, null],
      );
}

class QuestPersistenceService {
  static const _prefsKey = 'quest_persistence_state';

  Future<QuestPersistenceState> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) return QuestPersistenceState.initial();
    final jsonMap = json.decode(jsonString);
    return QuestPersistenceState.fromJson(jsonMap);
  }

  Future<void> saveState(QuestPersistenceState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(state.toJson()));
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
