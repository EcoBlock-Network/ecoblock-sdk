import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import '../../providers/blog_providers.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../widgets/article_header.dart';
import '../widgets/article_panel.dart';
import '../widgets/expand_arrow.dart';

class MessagingPage extends ConsumerWidget {
  const MessagingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final blogsAsync = ref.watch(blogsProvider);

    return Scaffold(
      backgroundColor: scheme.background,
      body: EcoPageBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  tr(context, 'messaging.news_title'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
                ),
              ),
              Expanded(
                child: blogsAsync.when(
                  data: (articles) => _InstagramGrid(articles: articles),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text(tr(context, 'messaging.load_failed'))),
                ),
              ),
            ],
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

class _InstagramGrid extends StatelessWidget {
  final List<dynamic> articles;
  const _InstagramGrid({required this.articles});

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

        final article = _Article(
          id: (_get(a, 'id') ?? index).toString(),
          title: (_get(a, 'title') ?? '').toString(),
          excerpt: (_get(a, 'excerpt') ?? '').toString(),
          content: (_get(a, 'content') ?? '').toString(),
          imageUrl: (_get(a, 'imageUrl') as String?),
          publishedAt: (_get(a, 'createdAt') is DateTime ? _get(a, 'createdAt') as DateTime : null),
        );

        return _ArticleTile(article: article);
      },
    );
  }
}

class _ArticleTile extends StatefulWidget {
  final _Article article;
  const _ArticleTile({required this.article});

  @override
  State<_ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<_ArticleTile> {
  bool _pressed = false;

  void _open() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _ArticleViewer(article: widget.article)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final imageUrl = widget.article.imageUrl;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _open,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/mock_story.png',
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  color: scheme.surfaceVariant,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/mock_story.png',
                        fit: BoxFit.contain,
                        color: Colors.white.withOpacity(0.9),
                        width: 56,
                        height: 56,
                      ),
                    ),
                  ),
                ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: _pressed ? Colors.transparent : Colors.black54,
          ),
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                widget.article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, shadows: [Shadow(blurRadius: 4, color: Colors.black45)]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleViewer extends StatefulWidget {
  final _Article article;
  const _ArticleViewer({required this.article});

  @override
  State<_ArticleViewer> createState() => _ArticleViewerState();
}

class _ArticleViewerState extends State<_ArticleViewer> {
  late final ScrollController _controller;
  bool _isExpanding = false;
  final GlobalKey _panelKey = GlobalKey();
  bool _isPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> _expandPanel({Duration duration = const Duration(milliseconds: 420), bool immediate = false}) async {
    if (_isExpanding) return;
    if (_panelKey.currentContext == null) return;

    _isExpanding = true;
    try {
      final d = immediate ? const Duration(milliseconds: 10) : duration;
      await Scrollable.ensureVisible(
        _panelKey.currentContext!,
        duration: d,
        alignment: 0.0,
        curve: Curves.easeOut,
      );
    } catch (_) {
      if (_controller.hasClients) {
        final max = _controller.position.maxScrollExtent;
        if (immediate) {
          _controller.jumpTo(max);
        } else {
          await _controller.animateTo(max, duration: duration, curve: Curves.easeOut);
        }
      }
    } finally {
      _isExpanding = false;
    }
  }

  Future<void> _togglePanel() async {
    if (!_isPanelExpanded) {
      await _expandPanel();
      if (mounted) setState(() => _isPanelExpanded = true);
    } else {
      if (_controller.hasClients) {
        await _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      if (mounted) setState(() => _isPanelExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
  final article = widget.article;
  final hasImage = article.imageUrl != null && article.imageUrl!.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: EcoPageBackground(
        child: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification && notification.dragDetails != null) {
                    _expandPanel(immediate: true).then((_) {
                      if (mounted) setState(() => _isPanelExpanded = true);
                    });
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                  ArticleHeader(
                    title: article.title,
                    publishedAt: article.publishedAt,
                    imageUrl: article.imageUrl,
                    hasImage: hasImage,
                    showBack: !_isPanelExpanded,
                  ),

                  ArticlePanel(
                    title: article.title,
                    content: article.content,
                    publishedAt: article.publishedAt,
                    panelKey: _panelKey,
                  ),
                ],
              ),
            ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: ExpandArrow(isExpanded: _isPanelExpanded, onTap: _togglePanel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}