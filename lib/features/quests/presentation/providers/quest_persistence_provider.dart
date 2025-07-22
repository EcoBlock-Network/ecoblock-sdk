import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/quest_persistence_service.dart';

final questPersistenceProvider = StateNotifierProvider<QuestPersistenceNotifier, QuestPersistenceState>((ref) {
  return QuestPersistenceNotifier(QuestPersistenceService());
});

class QuestPersistenceNotifier extends StateNotifier<QuestPersistenceState> {
  final QuestPersistenceService _service;
  QuestPersistenceNotifier(this._service) : super(QuestPersistenceState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final loaded = await _service.loadState();
    state = loaded;
  }

  Future<void> setVisibleQuestId(int index, String? id) async {
    final updated = List<String?>.from(state.visibleQuestIds);
    updated[index] = id;
    state = QuestPersistenceState(
      visibleQuestIds: updated,
      deletedTimes: state.deletedTimes,
    );
    await _service.saveState(state);
  }

  Future<void> setDeletedTime(int index, DateTime? time) async {
    final updated = List<DateTime?>.from(state.deletedTimes);
    updated[index] = time;
    state = QuestPersistenceState(
      visibleQuestIds: state.visibleQuestIds,
      deletedTimes: updated,
    );
    await _service.saveState(state);
  }

  Future<void> reset() async {
    state = QuestPersistenceState.initial();
    await _service.reset();
  }
}
