import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/stories_service.dart';

/// Fullscreen story viewer similar to Instagram stories.
/// - Accepts a list of [Story] and an [initialIndex].
/// - Auto advances every [autoAdvanceDuration].
class StoryViewer extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final Duration autoAdvanceDuration;

  const StoryViewer({super.key, required this.stories, this.initialIndex = 0, this.autoAdvanceDuration = const Duration(seconds: 5)});

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
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
        _goNext();
      }
    });
  }

  void _goNext() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // last story -> close
      Navigator.of(context).maybePop();
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // already first, reset progress
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
      // center tap: pause / resume
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
      backgroundColor: Colors.black,
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
            // Top progress bars and controls
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
                                      backgroundColor: Colors.white12,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close, color: Colors.white),
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
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.eco, color: Colors.white, size: 64),
            const SizedBox(height: 12),
            Text(s.title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
