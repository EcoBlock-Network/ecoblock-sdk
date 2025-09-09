import 'package:flutter/material.dart';
import 'article_model.dart';
import 'article_viewer.dart';

class ArticleTile extends StatefulWidget {
  final ArticleModel article;
  const ArticleTile({required this.article, super.key});

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  bool _pressed = false;

  void _open() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticleViewer(article: widget.article)));
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
