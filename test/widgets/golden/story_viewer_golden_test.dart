import 'package:ecoblock_mobile/features/story/presentation/story_viewer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('StoryViewer golden', (WidgetTester tester) async {
    final story = Story(
      id: 's1',
      imageUrl: 'https://placehold.co/300x500?text=Story',
      title: 'Story Admin',
      timestamp: DateTime.now(),
      isAdmin: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: StoryViewer(story: story)),
        ),
      ),
    );
    await expectLater(
      find.byType(StoryViewer),
      matchesGoldenFile('story_viewer_golden.png'),
    );
  });
}
