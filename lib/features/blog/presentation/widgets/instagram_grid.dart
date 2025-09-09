import 'package:flutter/material.dart';
import 'article_model.dart';
import '../../data/read_articles_service.dart';
import 'article_tile.dart';
import 'article_viewer.dart';

class InstagramGrid extends StatefulWidget {
  final List<dynamic> articles;
  const InstagramGrid({required this.articles, super.key});

  @override
  State<InstagramGrid> createState() => _InstagramGridState();
}

class _InstagramGridState extends State<InstagramGrid> {
  final List<GlobalKey> _tileKeys = [];
  int? _highlightedIndex;
  bool _dragging = false;
  final Set<String> _readIds = {};

  @override
  void initState() {
    super.initState();
    _ensureKeys();
    ReadArticlesService.loadReadIds().then((ids) {
      if (mounted) setState(() => _readIds.addAll(ids));
    });
  }

  void _ensureKeys() {
    _tileKeys.clear();
    _tileKeys.addAll(List.generate(widget.articles.length, (_) => GlobalKey()));
  }

  @override
  void didUpdateWidget(covariant InstagramGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.articles.length != widget.articles.length) {
      _ensureKeys();
    }
  }

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

  void _updateHoveredIndex(Offset globalPosition) {
    for (var i = 0; i < _tileKeys.length; i++) {
      final key = _tileKeys[i];
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final topLeft = box.localToGlobal(Offset.zero);
      final rect = topLeft & box.size;
      if (rect.contains(globalPosition)) {
        if (_highlightedIndex != i) {
          setState(() => _highlightedIndex = i);
        }
        return;
      }
    }
    if (_highlightedIndex != null) setState(() => _highlightedIndex = null);
  }

  void _markRead(String id) {
    if (id.isEmpty) return;
    if (!_readIds.contains(id)) {
      setState(() => _readIds.add(id));
      ReadArticlesService.markRead(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        _dragging = true;
        _updateHoveredIndex(details.globalPosition);
      },
      onLongPressMoveUpdate: (details) {
        if (!_dragging) return;
        _updateHoveredIndex(details.globalPosition);
      },
      onLongPressEnd: (details) async {
        if (_highlightedIndex != null) {
          final a = widget.articles[_highlightedIndex!];
          final article = ArticleModel(
            id: (_get(a, 'id') ?? _highlightedIndex).toString(),
            title: (_get(a, 'title') ?? '').toString(),
            excerpt: (_get(a, 'excerpt') ?? '').toString(),
            content: (_get(a, 'content') ?? '').toString(),
            imageUrl: (_get(a, 'imageUrl') as String?),
            publishedAt: (_get(a, 'createdAt') is DateTime ? _get(a, 'createdAt') as DateTime : null),
          );

          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticleViewer(article: article)));
          _markRead(article.id);
        }
        _dragging = false;
        setState(() => _highlightedIndex = null);
      },
      onLongPressCancel: () {
        _dragging = false;
        setState(() => _highlightedIndex = null);
      },
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 0.68,
        ),
        itemCount: widget.articles.length,
        itemBuilder: (context, index) {
          final a = widget.articles[index];

          final article = ArticleModel(
            id: (_get(a, 'id') ?? index).toString(),
            title: (_get(a, 'title') ?? '').toString(),
            excerpt: (_get(a, 'excerpt') ?? '').toString(),
            content: (_get(a, 'content') ?? '').toString(),
            imageUrl: (_get(a, 'imageUrl') as String?),
            publishedAt: (_get(a, 'createdAt') is DateTime ? _get(a, 'createdAt') as DateTime : null),
          );

          return ArticleTile(
            key: _tileKeys[index],
            article: article,
            isHighlighted: _highlightedIndex == index,
            isRead: _readIds.contains(article.id),
            onOpened: () async {
              // Called when tapped normally
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticleViewer(article: article)));
              _markRead(article.id);
            },
          );
        },
      ),
    );
  }
}
