import 'package:flutter/material.dart';
import 'article_model.dart';
import 'package:ecoblock_mobile/features/blog/presentation/widgets/article_header.dart';
import 'package:ecoblock_mobile/features/blog/presentation/widgets/article_panel.dart';
import 'package:ecoblock_mobile/features/blog/presentation/widgets/expand_arrow.dart';

class ArticleViewer extends StatefulWidget {
  final ArticleModel article;
  const ArticleViewer({required this.article, super.key});

  @override
  State<ArticleViewer> createState() => _ArticleViewerState();
}

class _ArticleViewerState extends State<ArticleViewer> {
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
      body: SafeArea(
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
    );
  }
}
