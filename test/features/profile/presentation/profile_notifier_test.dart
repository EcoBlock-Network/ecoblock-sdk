import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ecoblock_mobile/features/profile/domain/entities/profile.dart';
import 'package:ecoblock_mobile/features/profile/data/profile_persistence_service.dart';

// Fake persistence to capture saves and optionally throw
class FakePersistence implements ProfilePersistenceService {
  Profile? lastSaved;
  bool shouldThrow = false;
  // If non-null, load will return this value; otherwise null.
  Profile? loadReturn;

  @override
  Future<void> save(Profile profile) async {
    if (shouldThrow) throw Exception('save failed');
    lastSaved = profile;
  }

  @override
  Future<Profile?> load() async => loadReturn;
}

void main() {
  test('completeUniqueQuestAndAddXP - happy path', () async {
    final fake = FakePersistence();
    final container = ProviderContainer(overrides: [profilePersistenceProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    final notifier = container.read(profileProvider.notifier);

    // initialize state with default profile by calling build
    final initial = await notifier.build();
    expect(initial.xp, 0);

    // set notifier state to initial profile
    notifier.state = AsyncValue.data(initial);

    final success = await notifier.completeUniqueQuestAndAddXP('quest-1', 10);
    expect(success, isTrue);
    final state = notifier.state.value!;
    expect(state.xp, 10);
    expect(state.completedUniqueQuestIds, contains('quest-1'));
    expect(fake.lastSaved, isNotNull);
  });

  test('completeUniqueQuestAndAddXP - rollback on save failure', () async {
    final fake = FakePersistence();
    fake.shouldThrow = true;
  // Prevent build() from calling save by returning an initial profile
  fake.loadReturn = Profile(userId: 'u', pseudonyme: 'p', avatar: '', xp: 0, niveau: 1, completedUniqueQuestIds: []);
    final container = ProviderContainer(overrides: [profilePersistenceProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);
    final notifier = container.read(profileProvider.notifier);
    final initial = await notifier.build();
    notifier.state = AsyncValue.data(initial);

    final success = await notifier.completeUniqueQuestAndAddXP('quest-2', 20);
    expect(success, isFalse);
    final state = notifier.state.value!;
    expect(state.xp, initial.xp);
    expect(state.completedUniqueQuestIds, isNot(contains('quest-2')));
  });

  test('completeUniqueQuestAndAddXP - duplicate quest id is no-op', () async {
    final fake = FakePersistence();
    final container = ProviderContainer(overrides: [profilePersistenceProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);
    final notifier = container.read(profileProvider.notifier);
    final initial = await notifier.build();
    final withQuest = initial.copyWith(completedUniqueQuestIds: ['q3'], xp: 5);
    notifier.state = AsyncValue.data(withQuest);

    final success = await notifier.completeUniqueQuestAndAddXP('q3', 10);
    expect(success, isFalse);
    final state = notifier.state.value!;
    expect(state.xp, 5);
  });
}
