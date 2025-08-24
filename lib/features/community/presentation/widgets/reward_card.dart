import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../../domain/entities/reward.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final bool unlocked;
  const RewardCard({Key? key, required this.reward, required this.unlocked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Card(
        key: ValueKey(unlocked),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: unlocked ? Colors.yellow[100] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: unlocked ? Colors.orange : Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reward.name, style: TextStyle(fontWeight: FontWeight.bold, color: unlocked ? Colors.black : Colors.grey)),
                    Text(tr(context, 'reward.threshold', {'threshold': reward.threshold.toString()}), style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
