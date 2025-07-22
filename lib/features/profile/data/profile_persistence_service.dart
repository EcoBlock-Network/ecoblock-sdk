import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecoblock_mobile/features/profile/domain/entities/profile.dart';

class ProfilePersistenceService {
  static const _prefsKey = 'profile';

  Future<void> save(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(_toJson(profile)));
  }

  Future<Profile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) return null;
    return _fromJson(json.decode(jsonString));
  }

  Map<String, dynamic> _toJson(Profile profile) => {
    'userId': profile.userId,
    'pseudonyme': profile.pseudonyme,
    'avatar': profile.avatar,
    'xp': profile.xp,
    'niveau': profile.niveau,
    'completedUniqueQuestIds': profile.completedUniqueQuestIds,
  };

  Profile _fromJson(Map<String, dynamic> json) => Profile(
    userId: json['userId'],
    pseudonyme: json['pseudonyme'],
    avatar: json['avatar'],
    xp: json['xp'],
    niveau: json['niveau'],
    completedUniqueQuestIds: List<String>.from(json['completedUniqueQuestIds'] ?? []),
  );
}
