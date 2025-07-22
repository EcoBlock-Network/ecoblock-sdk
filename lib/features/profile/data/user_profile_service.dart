import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/user_profile.dart';

class UserProfileService {
  static const _prefsKey = 'user_profile';

  Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) {
      return UserProfile(
        userId: 'user1',
        pseudonyme: 'EcoUser',
        avatar: '',
        xp: 0,
        niveau: 1,
        badges: [],
        blocks: [],
        loot: [],
        stats: /* TODO: provide default Stats */ throw UnimplementedError(),
        nodeId: 'node1',
        completedUniqueQuestIds: [],
      );
    }
    return UserProfile.fromJson(json.decode(jsonString));
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(profile.toJson()));
  }
}
