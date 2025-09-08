import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  void logStoryViewed(String storyId) {
  debugPrint('[Analytics] Story viewed: $storyId');
  }

  void logQuestCompleted(String questId) {
  debugPrint('[Analytics] Quest completed: $questId');
  }

}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
