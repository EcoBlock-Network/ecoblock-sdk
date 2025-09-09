import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleHeader extends StatelessWidget {
  final String title;
  final DateTime publishedAt;
  final String? imageUrl;
  final bool hasImage;
  final bool showBack;
  final String? heroTag;
  const ArticleHeader({required this.title, required this.publishedAt, this.imageUrl, required this.hasImage, this.showBack = true, this.heroTag, super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Material(
                color: scheme.onBackground.withOpacity(0.12),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                ),
              ),
            )
          : null,
      backgroundColor: Colors.transparent,
      expandedHeight: MediaQuery.of(context).size.height * 0.95,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  if (heroTag != null)
                    Hero(
                      tag: heroTag!,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(color: Colors.black),
                        placeholder: (context, url) => Container(color: Colors.black12),
                      ),
                    )
                  else
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(color: Colors.black),
                      placeholder: (context, url) => Container(color: Colors.black12),
                    ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black26, Colors.transparent],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    shadows: const [Shadow(blurRadius: 8, color: Colors.black45)],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${publishedAt.year}-${publishedAt.month.toString().padLeft(2, '0')}-${publishedAt.day.toString().padLeft(2, '0')} • By EcoBlock',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(color: scheme.surface),
      ),
    );
  }
}
