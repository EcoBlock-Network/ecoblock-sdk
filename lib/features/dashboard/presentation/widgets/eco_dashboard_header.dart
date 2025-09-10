import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/providers/stories_provider.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/story_viewer.dart';

class EcoDashboardHeader extends ConsumerWidget {
  final int currentLevel;
  const EcoDashboardHeader({required this.currentLevel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final storiesAsync = ref.watch(storiesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 86,
                  child: storiesAsync.when(
                    data: (stories) {
                      if (stories.isEmpty) return const SizedBox.shrink();
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: stories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final s = stories[i];
                          return Consumer(
                            builder: (context, ref, _) {
                              final seen = ref.watch(seenStoriesProvider);
                              final isSeen = s.id.isNotEmpty && seen.contains(s.id);
                              return GestureDetector(
                            onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoryViewer(stories: stories, initialIndex: i)));
                                if (s.id.isNotEmpty) ref.read(seenStoriesProvider.notifier).markSeen(s.id);
                            },
                            child: Column(
                              children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: isSeen
                                                  ? null
                                                  : LinearGradient(
                                                      colors: [scheme.primary.withValues(alpha: 0.14), scheme.tertiaryContainer.withValues(alpha: 0.06)],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                              border: Border.all(color: scheme.surfaceVariant.withValues(alpha: isSeen ? 0.5 : 0.85)),
                                              color: isSeen ? scheme.surface : scheme.surfaceVariant,
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Colors.transparent,
                                            child: s.imageUrl != null
                                                ? ClipOval(
                                                    child: Image.network(s.imageUrl!, width: 36, height: 36, fit: BoxFit.cover),
                                                  )
                                                : Icon(Icons.eco, color: scheme.primary, size: 20),
                                          ),
                                          if (!isSeen)
                                            Positioned(
                                              right: 6,
                                              bottom: 10,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: scheme.secondary,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [BoxShadow(color: scheme.secondary.withValues(alpha: 0.22), blurRadius: 6, offset: const Offset(0, 2))],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                              ],
                            ),
                              );
                            },
                          );
                        },
                      );
                    },
                    loading: () => ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) => Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(color: scheme.surfaceVariant, shape: BoxShape.circle),
                      ),
                    ),
                    error: (e, _) => Center(child: Text(tr(context, 'loading_error'))),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr(context, 'dashboard.title'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr(context, 'dashboard.subtitle'),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.66),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
