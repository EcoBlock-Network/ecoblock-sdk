import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/story_group.dart';

class StoryViewerState {
  final int groupIndex;
  final int storyIndex;
  final bool paused;
  final List<StoryGroup> groups;

  StoryViewerState({
    required this.groupIndex,
    required this.storyIndex,
    required this.paused,
    required this.groups,
  });

  StoryViewerState copyWith({
    int? groupIndex,
    int? storyIndex,
    bool? paused,
    List<StoryGroup>? groups,
  }) {
    return StoryViewerState(
      groupIndex: groupIndex ?? this.groupIndex,
      storyIndex: storyIndex ?? this.storyIndex,
      paused: paused ?? this.paused,
      groups: groups ?? this.groups,
    );
  }
}

class StoryViewerNotifier extends StateNotifier<StoryViewerState> {
  StoryViewerNotifier(List<StoryGroup> initialGroups)
      : super(StoryViewerState(
          groupIndex: 0,
          storyIndex: 0,
          paused: false,
          groups: initialGroups,
        ));

  void nextStory() {
    final group = state.groups[state.groupIndex];
    if (state.storyIndex < group.stories.length - 1) {
      state = state.copyWith(storyIndex: state.storyIndex + 1);
    } else {
      nextGroup();
    }
  }

  void previousStory() {
    if (state.storyIndex > 0) {
      state = state.copyWith(storyIndex: state.storyIndex - 1);
    } else {
      previousGroup();
    }
  }

  void nextGroup() {
    if (state.groupIndex < state.groups.length - 1) {
      state = state.copyWith(groupIndex: state.groupIndex + 1, storyIndex: 0);
    } else {
      // End of all stories
    }
  }

  void previousGroup() {
    if (state.groupIndex > 0) {
      final prevGroup = state.groups[state.groupIndex - 1];
      state = state.copyWith(groupIndex: state.groupIndex - 1, storyIndex: prevGroup.stories.length - 1);
    }
  }

  void pause() {
    state = state.copyWith(paused: true);
  }

  void resume() {
    state = state.copyWith(paused: false);
  }

  void exit() {
    // Implement exit logic if needed
  }
}

final storyViewerProvider = StateNotifierProvider.autoDispose<StoryViewerNotifier, StoryViewerState>((ref) {
  // Replace with repository or service for real data
  return StoryViewerNotifier([]);
});
