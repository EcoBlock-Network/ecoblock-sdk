import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecoblock_mobile/features/onboarding/presentation/pages/join_ecoblock_page.dart';

void main() {
  testWidgets('Affiche le titre, bouton et card d’explication', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CupertinoApp(home: JoinEcoBlockPage())));
    expect(find.text('🌍 Bienvenue dans EcoBlock'), findsOneWidget);
    expect(find.text('Créer mon nœud'), findsOneWidget);
    expect(find.textContaining('Un nœud est un appareil'), findsOneWidget);
  });
}
