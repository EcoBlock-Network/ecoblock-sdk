import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/community_providers.dart';

class ReactionBar extends ConsumerWidget {
  const ReactionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactions = ref.watch(reactionBarProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: reactions.keys.map((emoji) {
        final count = reactions[emoji]!;
        return GestureDetector(
          onTap: () {
            ref.read(reactionBarProvider.notifier).update((state) => {
              ...state,
              emoji: state[emoji]! + 1,
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 4),
                Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
