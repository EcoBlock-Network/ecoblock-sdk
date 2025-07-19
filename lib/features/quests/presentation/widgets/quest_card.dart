import '../../domain/entities/quest.dart';
import 'package:flutter/material.dart';

/// Widget to display a quest card
class QuestCard extends StatelessWidget {
  final Quest quest;
  const QuestCard({Key? key, required this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (quest.progress / quest.goal).clamp(0.0, 1.0);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quest.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(quest.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: percent, minHeight: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progression: ${quest.progress}/${quest.goal}', style: Theme.of(context).textTheme.bodySmall),
                Text('Fin: ${_formatDate(quest.endDate)}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
