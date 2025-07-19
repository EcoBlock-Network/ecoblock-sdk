import 'package:flutter_test/flutter_test.dart';
import 'package:ecoblock_mobile/features/quests/domain/usecases/get_personal_quests.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';
import 'package:ecoblock_mobile/features/quests/domain/repositories/quest_repository.dart';

class MockQuestRepository implements QuestRepository {
  @override
  Future<List<Quest>> getPersonalQuests() async => [
    Quest(
      id: 'qp1',
      type: QuestType.personal,
      title: 'Test',
      description: 'Desc',
      goal: 1,
      progress: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ];
  @override
  Future<List<Quest>> getCommunityQuests() async => [];
}

void main() {
  test('GetPersonalQuests returns quests from repository', () async {
    final repo = MockQuestRepository();
    final usecase = GetPersonalQuests(repo);
    final result = await usecase();
    expect(result.length, 1);
    expect(result.first.title, 'Test');
  });
}
