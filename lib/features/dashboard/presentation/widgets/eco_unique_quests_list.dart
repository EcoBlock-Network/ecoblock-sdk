import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'eco_quest_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/unique_quests_provider.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class EcoUniqueQuestsList extends ConsumerWidget {
  const EcoUniqueQuestsList({super.key});

  void _handleCompletedQuestTap(BuildContext context, WidgetRef ref, Quest quest) async {
    final profileNotifier = ref.read(profileProvider.notifier);
    final xpToAdd = 100;
    await Future.delayed(const Duration(milliseconds: 400));
    final success = await profileNotifier.completeUniqueQuestAndAddXP(quest.id, xpToAdd);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'xp_added', {'xp': xpToAdd.toString()})),
          backgroundColor: Colors.green,
        ),
      );
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'could_not_complete_quest')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(uniqueQuestsProvider);
    return questsAsync.when(
      data: (quests) {
        final showQuests = quests.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...showQuests.map((q) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: EcoQuestCard(
                  key: ValueKey(q.id),
                  quest: q,
                  vibrant: true,
                  onCompletedTap: q.isCompleted ? () => _handleCompletedQuestTap(context, ref, q) : null,
                ),
              );
            }).toList(),
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
                            Text(tr(context, 'unique_quests_all'), style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            ...quests.map((q) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: EcoQuestCard(
                                    key: ValueKey(q.id),
                                    quest: q,
                                    vibrant: true,
                                    onCompletedTap: q.isCompleted ? () => _handleCompletedQuestTap(context, ref, q) : null,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(tr(context, 'see_more')),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
  error: (_, __) => Center(child: Text(tr(context, 'loading_error'))),
    );
  }
}
