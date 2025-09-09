import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import '../../providers/blog_providers.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class MessagingPage extends ConsumerWidget {
  const MessagingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final blogsAsync = ref.watch(blogsProvider);
    print(  'blogsAsync state: $blogsAsync'); // Debug print

    return Scaffold(
      body: EcoPageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(tr(context, 'messaging.news_title'), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: blogsAsync.when(
                    data: (articles) => ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: articles.length,
                      separatorBuilder: (context, index) => Divider(color: scheme.onSurfaceVariant.withOpacity(0.1), height: 1),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          tileColor: scheme.surface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: article.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    article.imageUrl!,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (c, child, p) => p == null ? child : Container(width: 72, height: 72, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator())),
                                    errorBuilder: (c, _, __) => Container(width: 72, height: 72, color: Colors.grey.shade300, child: const Icon(Icons.broken_image)),
                                  ),
                                )
                              : Container(width: 72, height: 72, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.article, size: 36, color: Colors.white)),
                          title: Text(article.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                          subtitle: Text(article.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                          onTap: () {
                            final viewed = _Article(
                              id: article.id,
                              title: article.title,
                              excerpt: article.excerpt,
                              content: article.content,
                              imageUrl: article.imageUrl,
                              publishedAt: article.createdAt,
                            );
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => _ArticleViewer(article: viewed)));
                          },
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text(tr(context, 'messaging.load_failed'))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Article {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime publishedAt;

  _Article({required this.id, required this.title, required this.excerpt, required this.content, this.imageUrl, DateTime? publishedAt}) : publishedAt = publishedAt ?? DateTime.now();
}

final List<_Article> _sampleArticles = [
  _Article(id: 'n1', title: 'EcoBlock — Lancement', excerpt: 'Bienvenue sur la nouvelle app EcoBlock.', content: 'Contenu de l\'article de lancement.'),
  _Article(id: 'n2', title: 'Planter pour demain', excerpt: 'Notre initiative de plantation continue.', content: 'Détails de l\'initiative.', imageUrl: null),
  _Article(id: 'n3', title: 'Stabilité réseau', excerpt: 'Améliorations et maintenance prévues.', content: 'Notes techniques.', imageUrl: 'https://picsum.photos/800/600'),
];

class _ArticleViewer extends StatelessWidget {
  final _Article article;
  const _ArticleViewer({required this.article});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final hasImage = article.imageUrl != null && article.imageUrl!.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: EcoPageBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 260,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: hasImage
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(article.imageUrl!, fit: BoxFit.cover),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.center,
                                  colors: [Colors.black54, Colors.transparent],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(color: Colors.black),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${article.publishedAt.year}-${article.publishedAt.month.toString().padLeft(2, '0')}-${article.publishedAt.day.toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 12),
                        Text(article.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurface)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
