import 'story_item.dart';

class StoryGroup {
  final String id;
  final String ownerName;
  final String ownerAvatar;
  final List<StoryMediaItem> stories;

  StoryGroup({required this.id, required this.ownerName, required this.ownerAvatar, required this.stories});
}
