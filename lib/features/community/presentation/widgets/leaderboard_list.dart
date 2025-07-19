import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entry.dart';
import 'leaderboard_card.dart';

class LeaderboardList extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const LeaderboardList({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, i) => LeaderboardCard(entry: entries[i], rank: i),
    );
  }
}
