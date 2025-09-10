import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'eco_quest_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/theme/theme.dart';
import 'package:ecoblock_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/unique_quests_provider.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class EcoUniqueQuestsList extends ConsumerStatefulWidget {
  const EcoUniqueQuestsList({super.key});

  @override
  ConsumerState<EcoUniqueQuestsList> createState() => _EcoUniqueQuestsListState();
}

class _EcoUniqueQuestsListState extends ConsumerState<EcoUniqueQuestsList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Quest> _items = [];

  void _handleCompletedQuestTap(BuildContext context, Quest quest) async {
    final profileNotifier = ref.read(profileProvider.notifier);
    final xpToAdd = 100;
    await Future.delayed(const Duration(milliseconds: 400));
    final success = await profileNotifier.completeUniqueQuestAndAddXP(quest.id, xpToAdd);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'xp_added', {'xp': xpToAdd.toString()})),
          backgroundColor: AppColors.green,
        ),
      );
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'could_not_complete_quest')),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _applyListDiffs(List<Quest> newItems) {
    final prevIds = _items.map((e) => e.id).toList();
    final newIds = newItems.map((e) => e.id).toList();
    for (int i = prevIds.length - 1; i >= 0; i--) {
      final id = prevIds[i];
      if (!newIds.contains(id)) {
        final removed = _items.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => SizeTransition(sizeFactor: animation, child: Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: EcoQuestCard(quest: removed, small: false))),
          duration: const Duration(milliseconds: 320),
        );
      }
    }
    for (int i = 0; i < newItems.length; i++) {
      final id = newItems[i].id;
      if (!prevIds.contains(id)) {
        _items.insert(i, newItems[i]);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 320));
      } else {
        final currentIndex = _items.indexWhere((e) => e.id == id);
        if (currentIndex != i) {
          final moved = _items.removeAt(currentIndex);
          _items.insert(i, moved);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questsAsync = ref.watch(uniqueQuestsProvider);
    return questsAsync.when(
      data: (quests) {
        final showQuests = quests.take(3).toList();
        return LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 420;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _applyListDiffs(showQuests);
          });
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
            child: AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: _items.length,
              itemBuilder: (context, idx, animation) {
                final q = _items[idx];
                return SizeTransition(
                  sizeFactor: animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: EcoQuestCard(
                      key: ValueKey(q.id),
                      quest: q,
                      small: compact,
                      vibrant: true,
                      onCompletedTap: q.isCompleted ? () => _handleCompletedQuestTap(context, q) : null,
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(tr(context, 'loading_error'))),
    );
  }
}
