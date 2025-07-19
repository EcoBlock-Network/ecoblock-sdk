import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';
import 'package:ecoblock_mobile/features/quests/presentation/widgets/quest_card.dart';

void main() {
  testWidgets('QuestCard displays title and progress', (WidgetTester tester) async {
    final quest = Quest(
      id: 'qp1',
      type: QuestType.personal,
      title: 'Scanner 3 nœuds',
      description: 'Scanne 3 nouveaux nœuds autour de toi.',
      goal: 3,
      progress: 1,
      startDate: DateTime(2025, 7, 19),
      endDate: DateTime(2025, 7, 31),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: QuestCard(quest: quest),
      ),
    );
    expect(find.text('Scanner 3 nœuds'), findsOneWidget);
    expect(find.text('Progression: 1/3'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
