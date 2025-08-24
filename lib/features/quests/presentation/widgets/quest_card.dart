import '../../domain/entities/quest.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

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
                Text(tr(context, 'quest.progress', {'progress': quest.progress.toString(), 'goal': quest.goal.toString()}), style: Theme.of(context).textTheme.bodySmall),
                Text(tr(context, 'quest.ends', {'date': _formatDate(quest.endDate)}), style: Theme.of(context).textTheme.bodySmall),
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
