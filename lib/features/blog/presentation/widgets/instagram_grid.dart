import 'package:flutter/material.dart';
import 'article_model.dart';
import 'article_tile.dart';

class InstagramGrid extends StatelessWidget {
  final List<dynamic> articles;
  const InstagramGrid({required this.articles, super.key});

  Object? _get(dynamic src, String key) {
    if (src == null) return null;
    if (src is Map) return src[key];
    try {
      switch (key) {
        case 'id':
          return src.id;
        case 'title':
          return src.title;
        case 'excerpt':
          return src.excerpt;
        case 'content':
          return src.content;
        case 'imageUrl':
          return (src.imageUrl ?? (src.image ?? null));
        case 'createdAt':
          return src.createdAt;
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 0.68,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final a = articles[index];

        final article = ArticleModel(
          id: (_get(a, 'id') ?? index).toString(),
          title: (_get(a, 'title') ?? '').toString(),
          excerpt: (_get(a, 'excerpt') ?? '').toString(),
          content: (_get(a, 'content') ?? '').toString(),
          imageUrl: (_get(a, 'imageUrl') as String?),
          publishedAt: (_get(a, 'createdAt') is DateTime ? _get(a, 'createdAt') as DateTime : null),
        );

        return ArticleTile(article: article);
      },
    );
  }
}
