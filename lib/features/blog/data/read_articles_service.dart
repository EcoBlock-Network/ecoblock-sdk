import 'package:shared_preferences/shared_preferences.dart';

class ReadArticlesService {
  static const _kKey = 'read_articles_ids';

  static Future<Set<String>> loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kKey) ?? <String>[];
    return Set<String>.from(list);
  }

  static Future<void> markRead(String id) async {
    if (id.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kKey) ?? <String>[];
    if (!list.contains(id)) {
      list.add(id);
      await prefs.setStringList(_kKey, list);
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kKey);
  }
}
