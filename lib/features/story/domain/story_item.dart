
enum StoryType { image, video, text }

class StoryItem {
  final StoryType type;
  final String url;
  final String? text;
  final Duration duration;

  StoryItem({
    required this.type,
    required this.url,
    this.text,
    required this.duration,
  });
}
