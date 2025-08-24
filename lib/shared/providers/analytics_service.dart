import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  void logStoryViewed(String storyId) {
  // TODO: Envoyer à un backend ou stocker localement
  debugPrint('[Analytics] Story viewed: $storyId');
  }

  void logQuestCompleted(String questId) {
  debugPrint('[Analytics] Quest completed: $questId');
  }

  // Ajoute d'autres méthodes d'analytics ici
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
