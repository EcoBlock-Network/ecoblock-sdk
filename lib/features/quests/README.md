# Feature: Quests

## Objectif
Gestion des quêtes personnelles et communautaires, gamification, affichage dynamique via Riverpod.

## Architecture
- Clean Architecture (data/domain/presentation)
- Providers Riverpod: `personalQuestsProvider`, `communityQuestsProvider`
- Widgets: `QuestCard`, `QuestList`, `PersonalQuestsPage`

## Exemple de provider
```dart
final personalQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  // ...
});
```

## Lien assets/tests
- assets/data/personal_quests.json
- test/features/quests/
