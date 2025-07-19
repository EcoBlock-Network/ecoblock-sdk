import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  const LeaderboardCard({Key? key, required this.entry, required this.rank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.amber, Colors.grey, Colors.brown];
    final color = rank < 3 ? colors[rank] : Colors.green[100];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('${rank + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.pseudo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Score: ${entry.score}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
