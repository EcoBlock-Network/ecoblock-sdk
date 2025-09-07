import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/stories_service.dart';

final storiesServiceProvider = Provider<StoriesService>((ref) => StoriesService());

final List<Story> _fallbackStories = [
  Story(id: 'welcome', title: 'Bienvenue sur EcoBlock', imageUrl: null),
  Story(id: 'getting_started', title: 'Commencer', imageUrl: null),
  Story(id: 'community', title: 'Communauté', imageUrl: null),
];

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  final svc = ref.read(storiesServiceProvider);
  try {
    final stories = await svc.fetchStories();
    if (stories.isEmpty) {
      debugPrint('stories_provider: API returned empty, using fallback');
      return _fallbackStories;
    }
    return stories;
  } catch (e, st) {
    debugPrint('stories_provider: fetch failed: $e');
    debugPrint('$st');
    return _fallbackStories;
  }
});
