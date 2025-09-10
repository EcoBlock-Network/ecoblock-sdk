import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import '../../providers/blog_providers.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../widgets/instagram_grid.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_controller.dart';

class MessagingPage extends ConsumerStatefulWidget {
  const MessagingPage({super.key});

  @override
  ConsumerState<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends ConsumerState<MessagingPage> {
  double _titleOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      try {
        ref.read(questControllerProvider.notifier).onOpenNews();
      } catch (_) {}
    });
  }

  void _onScrollNotification(ScrollNotification notification) {
    final pixels = notification.metrics.pixels;
    final newOpacity = (1.0 - (pixels / 60.0)).clamp(0.0, 1.0);
    if ((newOpacity - _titleOpacity).abs() > 0.01) {
      setState(() => _titleOpacity = newOpacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final blogsAsync = ref.watch(blogsProvider);

    return Scaffold(
      backgroundColor: scheme.background,
      body: EcoPageBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Builder(builder: (context) {
            final topInset = MediaQuery.of(context).viewPadding.top;
            return Padding(
              padding: EdgeInsets.only(top: topInset * _titleOpacity),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    height: (56.0 * _titleOpacity).clamp(0.0, 56.0),
                    child: Opacity(
                      opacity: _titleOpacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tr(context, 'messaging.news_title'),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        _onScrollNotification(notification);
                        return false;
                      },
                      child: blogsAsync.when(
                        data: (articles) => InstagramGrid(articles: articles),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Center(child: Text(tr(context, 'messaging.load_failed'))),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}