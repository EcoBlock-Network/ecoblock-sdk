import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quest_provider.dart';
import '../widgets/quest_card.dart';

class PersonalQuestsPage extends ConsumerWidget {
  const PersonalQuestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final questsAsync = ref.watch(personalQuestsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Quêtes'),
        backgroundColor: scheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: questsAsync.when(
          data: (quests) {
            if (quests.isEmpty) {
              return Center(
                child: Text('Aucune quête disponible', style: Theme.of(context).textTheme.bodyLarge),
              );
            }
            return ListView.separated(
              itemCount: quests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => QuestCard(quest: quests[i]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Erreur de chargement des quêtes', style: TextStyle(color: scheme.error)),
          ),
        ),
      ),
    );
  }
}
