import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/unique_quests_provider.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_quest_card.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';

class UniqueQuestsPage extends ConsumerWidget {
  const UniqueQuestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(uniqueQuestsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: EcoPageBackground(
        child: SafeArea(
          child: questsAsync.when(
            data: (list) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 50,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [theme.colorScheme.surface.withOpacity(0.04), theme.colorScheme.surface.withOpacity(0.02)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
                              ),
                              child: EcoQuestCard(quest: list[index]),
                            ),
                          ),
                        ),
                      ),
                      childCount: list.length,
                    ),
                  ),
                )
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text(tr(context, 'loading_error'))),
          ),
        ),
      ),
    );
  }
}
