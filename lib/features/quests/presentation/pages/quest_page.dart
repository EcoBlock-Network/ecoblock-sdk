import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quest_provider.dart';
import '../widgets/quest_list.dart';

class QuestPage extends ConsumerWidget {
  const QuestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalQuestsAsync = ref.watch(personalQuestsProvider);
    final communityQuestsAsync = ref.watch(communityQuestsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'quests.title'))), 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(tr(context, 'quests.personal_title'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            personalQuestsAsync.when(
              data: (quests) => QuestList(quests: quests),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(tr(context, 'error.loading'))), 
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(tr(context, 'quests.community_title'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            communityQuestsAsync.when(
              data: (quests) => QuestList(quests: quests),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(tr(context, 'error.loading'))), 
            ),
          ],
        ),
      ),
    );
  }
}
