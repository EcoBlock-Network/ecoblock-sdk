import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../../domain/entities/reward.dart';
import 'reward_card.dart';

class CommunityRewardsWidget extends StatelessWidget {
  final List<Reward> rewards;
  final int currentScore;
  const CommunityRewardsWidget({Key? key, required this.rewards, required this.currentScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Text(tr(context, 'community.rewards_title'), style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: rewards.map((r) => RewardCard(reward: r, unlocked: currentScore >= r.threshold)).toList(),
          ),
        ),
      ],
    );
  }
}
