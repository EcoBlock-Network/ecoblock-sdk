import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import '../../data/profile_persistence_service.dart';

/// Allows overriding the persistence implementation in tests.
final profilePersistenceProvider = Provider<ProfilePersistenceService>((ref) => ProfilePersistenceService());

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<Profile> {
  ProfilePersistenceService? _persistence;
  bool _isWriting = false;

  @override
  Future<Profile> build() async {
  // obtain persistence implementation from provider so tests can override it
  _persistence ??= ref.read(profilePersistenceProvider);
  final persisted = await _persistence!.load();
    if (persisted != null) return persisted;
    final defaultProfile = Profile(
      userId: '',
      pseudonyme: 'EcoUser',
      avatar: 'assets/images/avatar.png',
      xp: 0,
      niveau: 1,
      completedUniqueQuestIds: const [],
    );
  await _persistence!.save(defaultProfile);
    return defaultProfile;
  }

  Future<void> addXP(int xpToAdd) async {
    final current = state;
    if (current is AsyncData<Profile>) {
      final value = current.value;
      final updated = value.copyWith(xp: value.xp + xpToAdd);
      state = AsyncData(updated);
  await _persistence!.save(updated);
    }
  }

  /// Atomic completion: optimistic update then persist; rollback on failure.
  Future<bool> completeUniqueQuestAndAddXP(String questId, int xpToAdd) async {
    final current = state;
    if (current is! AsyncData<Profile>) return false;
    final profile = current.value;
    if (profile.completedUniqueQuestIds.contains(questId)) return false; // already done
    if (_isWriting) return false; // avoid concurrent writes

    final previous = profile;
    final updated = profile.copyWith(
      xp: profile.xp + xpToAdd,
      completedUniqueQuestIds: [...profile.completedUniqueQuestIds, questId],
    );

    // optimistic
    state = AsyncData(updated);
    _isWriting = true;
    try {
  await _persistence!.save(updated);
      _isWriting = false;
      return true;
    } catch (e) {
      // rollback
      state = AsyncData(previous);
      _isWriting = false;
      return false;
    }
  }
}
