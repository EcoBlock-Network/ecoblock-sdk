import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quest_provider.dart';
import '../widgets/quest_list.dart';

class QuestPage extends ConsumerWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalQuestsAsync = ref.watch(personalQuestsProvider);
    final communityQuestsAsync = ref.watch(communityQuestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quêtes')), 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Quêtes personnelles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            personalQuestsAsync.when(
              data: (quests) => QuestList(quests: quests),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur de chargement')), 
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Quêtes communautaires', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            communityQuestsAsync.when(
              data: (quests) => QuestList(quests: quests),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur de chargement')), 
            ),
          ],
        ),
      ),
    );
  }
}
