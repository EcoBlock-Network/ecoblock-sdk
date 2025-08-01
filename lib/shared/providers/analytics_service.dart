import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  void logStoryViewed(String storyId) {
    // TODO: Envoyer à un backend ou stocker localement
    print('[Analytics] Story viewed: $storyId');
  }

  void logQuestCompleted(String questId) {
    print('[Analytics] Quest completed: $questId');
  }

  // Ajoute d'autres méthodes d'analytics ici
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
