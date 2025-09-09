import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'article_model.dart';
import 'article_viewer.dart';

class ArticleTile extends StatefulWidget {
  final ArticleModel article;
  final bool isHighlighted;
  final bool isRead;
  final Future<void> Function()? onOpened;
  const ArticleTile({required this.article, this.isHighlighted = false, this.isRead = false, this.onOpened, super.key});

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  void _open() async {
    if (widget.onOpened != null) {
      await widget.onOpened!();
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticleViewer(article: widget.article)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final imageUrl = widget.article.imageUrl;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _open,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.isRead ? 0.82 : 1.0,
        child: AnimatedScale(
          scale: widget.isHighlighted ? 0.985 : 1.0,
          duration: const Duration(milliseconds: 160),
          child: Stack(
            fit: StackFit.expand,
            children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Hero(
                tag: widget.article.id,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset('assets/images/mock_story.png', fit: BoxFit.cover),
                  placeholder: (context, url) => Container(color: Colors.black12),
                ),
              )
            else
              Container(
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

            // subtle animated dark gradient overlay (lighter than before)
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(widget.isHighlighted ? 0.04 : 0.12),
                    Colors.black.withOpacity(widget.isHighlighted ? 0.06 : 0.32),
                  ],
                ),
              ),
            ),

            // title area (bottom)
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

            // small read dot top-right
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: widget.isRead ? 1.0 : 0.0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))],
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
