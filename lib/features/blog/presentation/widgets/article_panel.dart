import 'package:flutter/material.dart';

class ArticlePanel extends StatelessWidget {
  final String title;
  final String content;
  final DateTime publishedAt;
  final Key panelKey;
  const ArticlePanel({required this.title, required this.content, required this.publishedAt, required this.panelKey, super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: const Offset(0, -56),
        child: ConstrainedBox(
          key: panelKey,
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Material(
            color: Colors.white,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 6,
                      decoration: BoxDecoration(
                        color: scheme.onSurfaceVariant.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w800, height: 1.15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('${publishedAt.year}-${publishedAt.month.toString().padLeft(2, '0')}-${publishedAt.day.toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(width: 12),
                      Text('•', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(width: 12),
                      Text('By EcoBlock', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: scheme.onSurface, height: 1.5),
                    child: SelectableText(content),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
