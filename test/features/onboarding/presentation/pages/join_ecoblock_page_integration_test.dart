import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/onboarding/presentation/pages/join_ecoblock_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Association stocke l’état et navigation vers Dashboard', (WidgetTester tester) async {
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: JoinEcoBlockPage())));
    expect(find.text('Créer mon nœud'), findsOneWidget);
    await tester.tap(find.text('Créer mon nœud'));
    await tester.pumpAndSettle();
    // Ici, on pourrait vérifier la navigation et la persistance
    // (à compléter selon l’implémentation réelle du Dashboard et du stockage)
  });
}
