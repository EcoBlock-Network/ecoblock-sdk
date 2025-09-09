class Story {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  Story({required this.id, required this.title, this.excerpt = '', this.content = '', this.imageUrl, DateTime? createdAt}) : createdAt = createdAt ?? DateTime.now().toUtc();

  factory Story.fromJson(Map<String, dynamic> j) {
    final rawId = j['id'] ?? j['uuid'] ?? j['slug'] ?? '';
    final id = rawId?.toString() ?? '';
    final title = (j['title'] ?? j['label'] ?? j['name'] ?? '')?.toString() ?? '';
    final content = (j['body'] ?? j['content'] ?? j['excerpt'] ?? '')?.toString() ?? '';
    final excerpt = (j['excerpt'] ?? (content.length > 140 ? content.substring(0, 140) : content))?.toString() ?? '';
    final image = (j['image_url'] ?? j['image'] ?? j['thumbnail'])?.toString();
    DateTime created;
    try {
      created = DateTime.parse((j['created_at'] ?? j['created'] ?? DateTime.now().toUtc().toIso8601String()).toString());
    } catch (_) {
      created = DateTime.now().toUtc();
    }
    return Story(id: id, title: title, excerpt: excerpt, content: content, imageUrl: image, createdAt: created);
  }
}
