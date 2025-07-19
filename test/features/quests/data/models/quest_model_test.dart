import 'package:flutter_test/flutter_test.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_model.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';

void main() {
  test('QuestModel parses from JSON', () {
    final json = {
      'id': 'qp1',
      'type': 'personal',
      'title': 'Scanner 3 nœuds',
      'description': 'Scanne 3 nouveaux nœuds autour de toi.',
      'goal': 3,
      'progress': 1,
      'startDate': '2025-07-19',
      'endDate': '2025-07-31',
    };
    final model = QuestModel.fromJson(json);
    expect(model.id, 'qp1');
    expect(model.type, QuestType.personal);
    expect(model.title, 'Scanner 3 nœuds');
    expect(model.goal, 3);
    expect(model.progress, 1);
    expect(model.startDate.year, 2025);
    expect(model.endDate.month, 7);
  });
}
