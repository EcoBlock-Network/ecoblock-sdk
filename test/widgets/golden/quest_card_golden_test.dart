import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/quests/presentation/widgets/quest_card.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';

void main() {
  testWidgets('QuestCard golden', (WidgetTester tester) async {
    final quest = Quest(
      id: 'q1',
      title: 'Défi recyclage collectif',
      description: 'Ramasser 100kg de déchets',
      progress: 80,
      goal: 100,
      type: QuestType.community,
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 31),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: QuestCard(quest: quest)),
        ),
      ),
    );
    await expectLater(
      find.byType(QuestCard),
      matchesGoldenFile('quest_card_golden.png'),
    );
  });
}
