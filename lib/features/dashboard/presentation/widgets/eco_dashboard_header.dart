import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/providers/stories_provider.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/story_viewer.dart';

class EcoDashboardHeader extends ConsumerWidget {
  final int currentLevel;
  const EcoDashboardHeader({required this.currentLevel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final storiesAsync = ref.watch(storiesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 94,
                  child: storiesAsync.when(
                    data: (stories) {
                      if (stories.isEmpty) return const SizedBox.shrink();
                      // Log fetched stories for debugging
                      debugPrint('Stories fetched: ${stories.map((s) => s.title).toList()}');
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: stories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final s = stories[i];
                          return GestureDetector(
                            onTap: () {
                              // Open fullscreen story viewer
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoryViewer(stories: stories, initialIndex: i)));
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [scheme.primary.withValues(alpha: 0.12), scheme.tertiaryContainer.withValues(alpha: 0.06)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: scheme.primary.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3)),
                                    ],
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                                      child: s.imageUrl != null
                                          ? ClipOval(
                                              child: Image.network(s.imageUrl!, width: 40, height: 40, fit: BoxFit.cover),
                                            )
                                          : Icon(Icons.eco, color: scheme.primary, size: 26),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () => ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) => Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(color: scheme.surfaceVariant, shape: BoxShape.circle),
                      ),
                    ),
                    error: (e, _) => Center(child: Text('')),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "My EcoNode",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Welcome to the EcoBlock mesh",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.53),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.03,
                      ),
                ),
              ],
            ),
          ),
          // Level badge
        ],
      ),
    );
  }
}
