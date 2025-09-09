import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/models/story.dart';
import '../providers/stories_provider.dart';
import 'package:ecoblock_mobile/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryViewer extends ConsumerStatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final Duration autoAdvanceDuration;

  const StoryViewer({super.key, required this.stories, this.initialIndex = 0, this.autoAdvanceDuration = const Duration(seconds: 5)});

  @override
  ConsumerState<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends ConsumerState<StoryViewer> {
  late PageController _pageController;
  Timer? _tickTimer;
  late List<double> _progress;
  late int _currentIndex;

  static const Duration _tick = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.stories.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _progress = List<double>.filled(widget.stories.length, 0);
    _startProgress();
  }

  void _startProgress() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(_tick, (timer) {
      final inc = _tick.inMilliseconds / widget.autoAdvanceDuration.inMilliseconds;
      setState(() {
        _progress[_currentIndex] = (_progress[_currentIndex] + inc).clamp(0.0, 1.0);
      });
      if (_progress[_currentIndex] >= 1.0) {
  final sid = widget.stories[_currentIndex].id;
  if (sid.isNotEmpty) ref.read(seenStoriesProvider.notifier).markSeen(sid);
  _goNext();
      }
    });
  }

  void _goNext() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      setState(() {
        _progress[_currentIndex] = 0;
      });
    }
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, BoxConstraints box) {
    final dx = details.localPosition.dx;
    if (dx < box.maxWidth * 0.35) {
      _goPrevious();
    } else if (dx > box.maxWidth * 0.65) {
      _goNext();
    } else {
      if (_tickTimer?.isActive ?? false) {
        _tickTimer?.cancel();
      } else {
        _startProgress();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = widget.stories;
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  // reset progress for new index if necessary
                  if (_progress[index] >= 1.0) _progress[index] = 0.0;
                });
                _startProgress();
                // mark as seen when swiped into view
                final sid = widget.stories[index].id;
                if (sid.isNotEmpty) ref.read(seenStoriesProvider.notifier).markSeen(sid);
              },
              itemBuilder: (context, index) {
                final s = stories[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) => _onTapDown(details, BoxConstraints.tight(MediaQuery.of(context).size)),
                  onVerticalDragUpdate: (d) {
                    if (d.delta.dy > 10) Navigator.of(context).maybePop();
                  },
                    child: SizedBox.expand(
                    child: s.imageUrl != null
                        ? Image.network(
                            s.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, _, __) => _buildPlaceholder(s),
                          )
                        : _buildPlaceholder(s),
                  ),
                );
              },
            ),
            Positioned(
              top: 12,
              left: 8,
              right: 8,
              child: Column(
                children: [
                  Row(
                    children: stories
                        .asMap()
                        .map((i, _) {
                          return MapEntry(
                              i,
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                    value: _progress[i].clamp(0.0, 1.0),
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkBackground.withAlpha((0.12 * 255).toInt())
                      : Theme.of(context).colorScheme.background.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).brightness == Brightness.dark ? AppColors.darkOnBackground : Theme.of(context).colorScheme.onBackground),
                                      minHeight: 3,
                                    ),
                                  ),
                                ),
                              ));
                        })
                        .values
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            stories[_currentIndex].title,
                            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkOnBackground : AppColors.white, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: Icon(Icons.close, color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkOnBackground : Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(Story s) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark ? AppColors.black : AppColors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkOnBackground : Colors.white, size: 64),
            const SizedBox(height: 12),
            Text(s.title, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkOnBackground.withAlpha((0.7 * 255).toInt()) : Theme.of(context).colorScheme.onBackground.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}
