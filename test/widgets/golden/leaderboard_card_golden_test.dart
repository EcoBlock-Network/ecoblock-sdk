import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/community/presentation/widgets/leaderboard_card.dart';
import 'package:ecoblock_mobile/features/community/domain/entities/leaderboard_entry.dart';

void main() {
  testWidgets('LeaderboardCard golden', (WidgetTester tester) async {
    final entry = LeaderboardEntry(
      id: '1',
      pseudo: 'LynxVert',
      avatar: 'lynx.png',
      score: 1200,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: LeaderboardCard(entry: entry, rank: 0)),
        ),
      ),
    );
    await expectLater(
      find.byType(LeaderboardCard),
      matchesGoldenFile('leaderboard_card_golden.png'),
    );
  });
}
