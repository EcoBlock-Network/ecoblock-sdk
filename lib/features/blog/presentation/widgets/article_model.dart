class ArticleModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime publishedAt;

  ArticleModel({required this.id, required this.title, required this.excerpt, required this.content, this.imageUrl, DateTime? publishedAt}) : publishedAt = publishedAt ?? DateTime.now();
}
