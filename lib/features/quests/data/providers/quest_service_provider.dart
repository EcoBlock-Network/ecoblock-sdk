import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/quest_service.dart';

final questServiceProvider = Provider<QuestService>((ref) {
  return QuestService();
});
