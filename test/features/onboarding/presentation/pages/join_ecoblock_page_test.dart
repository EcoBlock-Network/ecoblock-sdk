import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/onboarding/presentation/pages/join_ecoblock_page.dart';

void main() {
  testWidgets('Affiche le titre, bouton et card d’explication', (WidgetTester tester) async {
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: JoinEcoBlockPage())));
    expect(find.text('🌍 Bienvenue dans EcoBlock'), findsOneWidget);
    expect(find.text('Créer mon nœud'), findsOneWidget);
  expect(find.textContaining('Crée ton nœud pour rejoindre le réseau'), findsOneWidget);
  });
}
