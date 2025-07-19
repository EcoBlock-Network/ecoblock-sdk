import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/story_model.dart';

class StoryState {
  final int currentIndex;
  final bool isPaused;
  StoryState({required this.currentIndex, required this.isPaused});

  StoryState copyWith({int? currentIndex, bool? isPaused}) => StoryState(
    currentIndex: currentIndex ?? this.currentIndex,
    isPaused: isPaused ?? this.isPaused,
  );
}

class StoryNotifier extends StateNotifier<StoryState> {
  StoryNotifier() : super(StoryState(currentIndex: 0, isPaused: false));

  void next(int max) {
    if (state.currentIndex < max - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previous() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void pause() => state = state.copyWith(isPaused: true);
  void resume() => state = state.copyWith(isPaused: false);
  void reset() => state = StoryState(currentIndex: 0, isPaused: false);
}

final storyProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) => StoryNotifier());

final storyListProvider = Provider<List<StoryItem>>((ref) => [
  StoryItem(url: 'https://via.placeholder.com/400x700.png?text=Story+1', type: StoryType.image),
  StoryItem(url: 'https://via.placeholder.com/400x700.png?text=Story+2', type: StoryType.image),
  StoryItem(url: 'https://via.placeholder.com/400x700.png?text=Story+3', type: StoryType.image),
]);
