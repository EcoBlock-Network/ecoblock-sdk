import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import '../widgets/article_header.dart';
import '../widgets/article_panel.dart';
import '../widgets/expand_arrow.dart';

class ArticleViewerPage extends StatefulWidget {
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime publishedAt;

  const ArticleViewerPage({required this.title, required this.content, this.imageUrl, required this.publishedAt, Key? key}) : super(key: key);

  @override
  State<ArticleViewerPage> createState() => _ArticleViewerPageState();
}

class _ArticleViewerPageState extends State<ArticleViewerPage> {
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
    final hasImage = widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

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
                      title: widget.title,
                      publishedAt: widget.publishedAt,
                      imageUrl: widget.imageUrl,
                      hasImage: hasImage,
                      showBack: !_isPanelExpanded,
                    ),
                    ArticlePanel(
                      title: widget.title,
                      content: widget.content,
                      publishedAt: widget.publishedAt,
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
