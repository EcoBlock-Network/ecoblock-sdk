enum StoryMediaType { image, video, text }

class StoryMediaItem {
  final StoryMediaType type;
  final String url;
  final String? text;
  final Duration duration;

  StoryMediaItem({required this.type, required this.url, this.text, this.duration = const Duration(seconds: 5)});
}
