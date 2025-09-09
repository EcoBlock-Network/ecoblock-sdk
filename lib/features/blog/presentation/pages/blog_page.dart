import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import '../../providers/blog_providers.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../widgets/instagram_grid.dart';

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
                  data: (articles) => InstagramGrid(articles: articles),
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