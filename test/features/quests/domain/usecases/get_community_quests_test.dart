import 'package:flutter_test/flutter_test.dart';
import 'package:ecoblock_mobile/features/quests/domain/usecases/get_community_quests.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';
import 'package:ecoblock_mobile/features/quests/domain/repositories/quest_repository.dart';

class MockQuestRepository implements QuestRepository {
  @override
  Future<List<Quest>> getPersonalQuests() async => [];
  @override
  Future<List<Quest>> getCommunityQuests() async => [
    Quest(
      id: 'qc1',
      type: QuestType.community,
      title: 'Community Test',
      description: 'Desc',
      goal: 10,
      progress: 5,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ];
}

void main() {
  test('GetCommunityQuests returns quests from repository', () async {
    final repo = MockQuestRepository();
    final usecase = GetCommunityQuests(repo);
    final result = await usecase();
    expect(result.length, 1);
    expect(result.first.title, 'Community Test');
  });
}
