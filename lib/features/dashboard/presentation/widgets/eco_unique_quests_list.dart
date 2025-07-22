import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/services/quest_service.dart';
import 'eco_quest_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class EcoUniqueQuestsList extends ConsumerStatefulWidget {
  const EcoUniqueQuestsList({super.key});

  @override
  ConsumerState<EcoUniqueQuestsList> createState() => _EcoUniqueQuestsListState();
}

class _EcoUniqueQuestsListState extends ConsumerState<EcoUniqueQuestsList> {
  Future<List<Quest>> _loadUniqueQuests() async {
    final service = QuestService();
    return await service.loadUniqueQuests();
  }

  void _handleCompletedQuestTap(Quest quest) async {
    final profileNotifier = ref.read(profileProvider.notifier);
    final xpToAdd = 100;
    await Future.delayed(const Duration(milliseconds: 400));
    await profileNotifier.completeUniqueQuestAndAddXP(quest.id, xpToAdd);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${xpToAdd} XP added to your profile!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    return FutureBuilder<List<Quest>>(
      future: _loadUniqueQuests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Loading error'));
        }
        final quests = snapshot.data ?? [];
        final completedIds = profileAsync.maybeWhen(
          data: (profile) => profile.completedUniqueQuestIds,
          orElse: () => <String>[],
        );
        final showQuests = quests.where((q) => !completedIds.contains(q.id)).take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...showQuests.map((q) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: EcoQuestCard(
                    key: ValueKey(q.id),
                    quest: q,
                    vibrant: true,
                    onCompletedTap: q.isCompleted
                        ? () => _handleCompletedQuestTap(q)
                        : null,
                  ),
                )),
            if (quests.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.7,
                        minChildSize: 0.4,
                        maxChildSize: 0.95,
                        builder: (_, controller) => ListView(
                          controller: controller,
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text('Toutes les quêtes uniques', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            ...quests.where((q) => !completedIds.contains(q.id)).map((q) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: EcoQuestCard(
                                    key: ValueKey(q.id),
                                    quest: q,
                                    vibrant: true,
                                    onCompletedTap: q.isCompleted
                                        ? () => _handleCompletedQuestTap(q)
                                        : null,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Voir plus'),
                ),
              ),
          ],
        );
      },
    );
  }
}
