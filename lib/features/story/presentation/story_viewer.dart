import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model for a single story item (image or video)
class StoryItem {
  final String url;
  final StoryType type;
  final Duration duration;

  StoryItem({
    required this.url,
    required this.type,
    this.duration = const Duration(seconds: 5),
  });
}

enum StoryType { image, video }

// Optional: Model for a group of stories (e.g., one user)
class StoryGroup {
  final String ownerName;
  final String ownerAvatar;
  final List<StoryItem> items;

  StoryGroup({
    required this.ownerName,
    required this.ownerAvatar,
    required this.items,
  });
}

// Riverpod provider for story viewer state
final storyIndexProvider = StateProvider<int>((ref) => 0);
final storyPausedProvider = StateProvider<bool>((ref) => false);

// Main StoryViewer widget
class StoryViewer extends ConsumerStatefulWidget {
  final StoryGroup storyGroup;
  final VoidCallback? onClose;

  const StoryViewer({
    Key? key,
    required this.storyGroup,
    this.onClose,
  }) : super(key: key);

  @override
  ConsumerState<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends ConsumerState<StoryViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late StoryItem _currentStory;

  @override
  void initState() {
    super.initState();
    _setupStory();
  }

  void _setupStory() {
    final index = ref.read(storyIndexProvider);
    _currentStory = widget.storyGroup.items[index];
    _progressController = AnimationController(
      vsync: this,
      duration: _currentStory.duration,
    )..addStatusListener(_handleAnimationStatus);
    _progressController.forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextStory();
    }
  }

  void _nextStory() {
    final index = ref.read(storyIndexProvider);
    if (index < widget.storyGroup.items.length - 1) {
      ref.read(storyIndexProvider.notifier).state++;
      _restartStory();
    } else {
      widget.onClose?.call();
      Navigator.of(context).pop();
    }
  }

  void _prevStory() {
    final index = ref.read(storyIndexProvider);
    if (index > 0) {
      ref.read(storyIndexProvider.notifier).state--;
      _restartStory();
    }
  }

  void _restartStory() {
    _progressController.dispose();
    _setupStory();
    setState(() {});
  }

  void _pauseStory() {
    ref.read(storyPausedProvider.notifier).state = true;
    _progressController.stop();
  }

  void _resumeStory() {
    ref.read(storyPausedProvider.notifier).state = false;
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Widget _buildProgressBar() {
    final storyCount = widget.storyGroup.items.length;
    final currentIndex = ref.watch(storyIndexProvider);
    return Row(
      children: List.generate(storyCount, (i) {
        double value;
        if (i < currentIndex) {
          value = 1.0;
        } else if (i == currentIndex) {
          value = _progressController.value;
        } else {
          value = 0.0;
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Stack(
              children: [
                Container(
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStoryContent(StoryItem story) {
    switch (story.type) {
      case StoryType.image:
        return Image.asset(
          story.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      case StoryType.video:
        // Placeholder for video widget
        return Center(
          child: Icon(Icons.videocam, color: Colors.white, size: 64),
        );
      default:
        return Container(color: Colors.black);
    }
  }

  void _onTapDown(TapDownDetails details, BoxConstraints constraints) {
    final dx = details.localPosition.dx;
    if (dx < constraints.maxWidth / 3) {
      _prevStory();
    } else if (dx > constraints.maxWidth * 2 / 3) {
      _nextStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paused = ref.watch(storyPausedProvider);
    final currentIndex = ref.watch(storyIndexProvider);
    final group = widget.storyGroup;
    final story = group.items[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => _onTapDown(details, constraints),
              onLongPress: _pauseStory,
              onLongPressUp: _resumeStory,
              child: Stack(
                children: [
                  Positioned.fill(child: _buildStoryContent(story)),
                  Positioned(
                    top: 32,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildProgressBar(),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    left: 16,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(group.ownerAvatar),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    left: 60,
                    child: Text(
                      group.ownerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 32),
                      onPressed: () {
                        widget.onClose?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  if (paused)
                    const Center(
                      child: Icon(Icons.pause_circle_filled, color: Colors.white70, size: 64),
                    ),
                ],
              ));
          },
        ),
      ),
    );
  }
}
