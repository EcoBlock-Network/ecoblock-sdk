import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/models/story.dart';
import 'package:ecoblock_mobile/services/locator.dart';

final List<Story> _fallbackStories = [
  Story(id: 'welcome', title: 'Bienvenue sur EcoBlock'),
  Story(id: 'getting_started', title: 'Commencer'),
  Story(id: 'community', title: 'Communauté'),
];

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  final comm = ref.read(communicationServiceProvider);
  try {
    final items = await comm.fetchStories();
    if (items.isEmpty) {
      debugPrint('stories_provider: communication service returned empty, using fallback');
      return _fallbackStories;
    }
    return items.map((c) => Story(id: c.id, title: c.title, excerpt: c.excerpt, content: c.content, imageUrl: c.imageUrl, createdAt: c.createdAt)).toList();
  } catch (e, st) {
    debugPrint('stories_provider: fetch failed: $e');
    debugPrint('$st');
    return _fallbackStories;
  }
});

class SeenStoriesNotifier extends StateNotifier<Set<String>> {
  SeenStoriesNotifier() : super(<String>{});

  void markSeen(String id) {
    if (id.isEmpty) return;
    state = {...state, id};
  }

  void markAllSeen(Iterable<Story> stories) {
    state = {...state, for (final s in stories) s.id};
  }

  bool isSeen(String id) => state.contains(id);
}

final seenStoriesProvider = StateNotifierProvider<SeenStoriesNotifier, Set<String>>((ref) => SeenStoriesNotifier());
