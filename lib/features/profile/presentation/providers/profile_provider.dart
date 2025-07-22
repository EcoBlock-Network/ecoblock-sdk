import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import '../../data/profile_persistence_service.dart';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<Profile> {
  final _persistence = ProfilePersistenceService();
  @override
  Future<Profile> build() async {
    final persisted = await _persistence.load();
    if (persisted != null) return persisted;
    // Création d'un profil par défaut si aucun profil n'existe
    final defaultProfile = Profile(
      userId: '',
      pseudonyme: 'EcoUser',
      avatar: 'assets/images/avatar.png',
      xp: 0,
      niveau: 1,
      completedUniqueQuestIds: const [],
    );
    await _persistence.save(defaultProfile);
    return defaultProfile;
  }

  /// Add XP to the current profile in memory and update state
  Future<void> addXP(int xpToAdd) async {
    if (state case AsyncData(:final value)) {
      final updated = value.copyWith(xp: value.xp + xpToAdd);
      state = AsyncData(updated);
      await _persistence.save(updated);
    }
  }

  /// Marque une quête unique comme complétée et ajoute l'XP, de façon persistante
  Future<void> completeUniqueQuestAndAddXP(String questId, int xpToAdd) async {
    if (state case AsyncData(:final value)) {
      if (!value.completedUniqueQuestIds.contains(questId)) {
        final updated = value.copyWith(
          xp: value.xp + xpToAdd,
          completedUniqueQuestIds: [...value.completedUniqueQuestIds, questId],
        );
        state = AsyncData(updated);
        await _persistence.save(updated);
      }
    }
  }
}
