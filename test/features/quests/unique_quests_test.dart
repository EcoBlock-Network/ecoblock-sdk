import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/unique_quests_provider.dart';
import 'package:ecoblock_mobile/features/quests/data/providers/quest_service_provider.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';
import 'package:ecoblock_mobile/features/quests/data/services/quest_service.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ecoblock_mobile/features/profile/domain/entities/profile.dart';
import 'package:ecoblock_mobile/features/profile/data/profile_persistence_service.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_unique_quests_list.dart';

class FakeQuestService implements QuestService {
  final List<Quest> _unique;
  FakeQuestService(this._unique);

  @override
  Future<List<Quest>> loadUniqueQuests() async => _unique;

  @override
  Future<List<Quest>> loadPersonalQuests() async => [];

  @override
  Future<List<Quest>> loadCommunityQuests() async => [];
}

class FakePersistence implements ProfilePersistenceService {
  Profile? lastSaved;
  @override
  Future<void> save(Profile profile) async {
    lastSaved = profile;
  }

  @override
  Future<Profile?> load() async => null;
}

Quest makeQuest(String id, {int progress = 1, int goal = 1}) => Quest(
      id: id,
      title: 'Quest $id',
      description: 'desc',
      goal: goal,
      progress: progress,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 7)),
  type: QuestType.unique,
    );

void main() {
  test('uniqueQuestsProvider filters completed quests', () async {
    final q1 = makeQuest('q1');
    final q2 = makeQuest('q2');
    final fakeService = FakeQuestService([q1, q2]);
    final container = ProviderContainer(overrides: [questServiceProvider.overrideWithValue(fakeService)]);
    addTearDown(container.dispose);

    // provide a profile with q1 completed
    final profile = Profile(userId: 'u', pseudonyme: 'p', avatar: '', xp: 0, niveau: 1, completedUniqueQuestIds: ['q1']);
    container.read(profileProvider.notifier).state = AsyncValue.data(profile);

    final result = await container.read(uniqueQuestsProvider.future);
    expect(result.map((q) => q.id), contains('q2'));
    expect(result.map((q) => q.id), isNot(contains('q1')));
  });

  testWidgets('EcoUniqueQuestsList completes a quest and persists profile', (WidgetTester tester) async {
    final q1 = makeQuest('q1');
    final fakeService = FakeQuestService([q1]);
    final fakePersistence = FakePersistence();

    final container = ProviderContainer(overrides: [
      questServiceProvider.overrideWithValue(fakeService),
      profilePersistenceProvider.overrideWithValue(fakePersistence),
    ]);
    addTearDown(container.dispose);

    // Start with empty profile
    final notifier = container.read(profileProvider.notifier);
    final initial = await notifier.build();
    notifier.state = AsyncValue.data(initial);

  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: MaterialApp(home: Scaffold(body: EcoUniqueQuestsList()))));
    await tester.pumpAndSettle();

    // Tap the quest card (title text)
    expect(find.text('Quest q1'), findsOneWidget);
  await tester.tap(find.text('Quest q1'));
  // advance time to let the delayed handler run (400ms in the handler)
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();

    // after tapping a completed quest (progress >= goal), profile should be saved with the quest id
    expect(fakePersistence.lastSaved, isNotNull);
    expect(fakePersistence.lastSaved!.completedUniqueQuestIds, contains('q1'));
  });
}
