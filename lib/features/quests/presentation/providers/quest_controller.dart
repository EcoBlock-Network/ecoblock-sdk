import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/quest_progress_service.dart';
import '../../data/services/quest_service.dart';
import '../../domain/entities/quest.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class QuestProgressState {
  final Map<String, int> progressMap;
  const QuestProgressState(this.progressMap);

  QuestProgressState copyWith(Map<String, int>? updates) => QuestProgressState({...progressMap, ...?updates});
}

final questControllerProvider = StateNotifierProvider<QuestController, QuestProgressState>((ref) {
  return QuestController(ref, QuestProgressService(), QuestService());
});

class QuestController extends StateNotifier<QuestProgressState> {
  final Ref _ref;
  final QuestProgressService _service;
  final QuestService _questService;

  final Map<String, Quest> _questMeta = {};

  QuestController(this._ref, this._service, this._questService) : super(const QuestProgressState({})) {
    _init();
  }

  Future<void> _init() async {
    final loaded = await _service.loadProgress();
    state = QuestProgressState(loaded);
    try {
      final unique = await _questService.loadUniqueQuests();
      for (final q in unique) {
        _questMeta[q.id] = q;
      }
    } catch (e) {}
  }

  Future<void> increment(String id, {int amount = 1}) async {
    final current = state.progressMap[id] ?? 0;
    final updated = {...state.progressMap, id: current + amount};
    state = QuestProgressState(updated);
    await _service.saveProgress(updated);
  await _maybeComplete(id, updated[id]!);
  }

  Future<void> set(String id, int value) async {
    final updated = {...state.progressMap, id: value};
    state = QuestProgressState(updated);
    await _service.saveProgress(updated);
  await _maybeComplete(id, value);
  }

  Future<void> complete(String id, int goal) async {
    await set(id, goal);
  }

  Future<void> _maybeComplete(String id, int currentProgress) async {
  final meta = _questMeta[id];
  if (meta == null) return;
  if (currentProgress < meta.goal) return;

  final profileState = _ref.read(profileProvider);
  if (profileState is! AsyncData) return;
  final profile = profileState.value;
  if (profile == null) return;
  if (profile.completedUniqueQuestIds.contains(id)) return;

  final xpToAdd = meta.goal;
  final notifier = _ref.read(profileProvider.notifier);
  await notifier.completeUniqueQuestAndAddXP(id, xpToAdd);
  }

  Future<void> onReadStory() async {
    await increment('qp7');
  }

  Future<void> onOpenNews() async {
    await increment('qp8');
  }

  Future<void> onOpenMap() async {
    await increment('qp9');
  }

  Future<void> onOpenProfileCard() async {
    await increment('qp10');
  }

}
