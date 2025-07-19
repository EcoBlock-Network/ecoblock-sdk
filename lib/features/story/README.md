# Feature: Story

## Objectif
Gestion des stories administrateur et utilisateur, affichage type Instagram, fallback JSON, future API.

## Architecture
- Clean Architecture (data/domain/presentation)
- Providers Riverpod: `storyProvider`
- Widgets: `StoryViewer`, `StoryList`

## Exemple de provider
```dart
final storyProvider = FutureProvider<List<Story>>((ref) async {
  // ...
});
```

## Lien assets/tests
- assets/data/stories.json
- test/features/story/
