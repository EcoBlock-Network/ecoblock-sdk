class BlogModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  BlogModel({required this.id, required this.title, required this.excerpt, required this.content, this.imageUrl, required this.createdAt});

  factory BlogModel.fromJson(Map<String, dynamic> j) {
    return BlogModel(
      id: j['id'] as String,
      title: j['title'] as String,
      excerpt: (j['body'] as String).substring(0, (j['body'] as String).length.clamp(0, 140)),
      content: j['body'] as String,
      imageUrl: j['image_url'] != null ? j['image_url'] as String : null,
      createdAt: DateTime.parse(j['created_at'] as String),
    );
  }
}
