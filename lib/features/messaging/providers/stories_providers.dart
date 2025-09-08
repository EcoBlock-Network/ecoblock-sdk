import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/messaging/services/stories_service.dart';
import 'package:ecoblock_mobile/core/config.dart';

final storyServiceProvider = Provider<StoryService>((ref) {
  return StoryService(apiKey: kApiKey);
});

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  final svc = ref.watch(storyServiceProvider);
  return svc.fetchStories();
});
