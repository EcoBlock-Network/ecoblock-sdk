import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static const String _nodeAssociatedKey = 'node_associated';

  Future<void> setNodeAssociated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_nodeAssociatedKey, value);
  }

  Future<bool> isNodeAssociated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_nodeAssociatedKey) ?? false;
  }
}
