import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../../domain/entities/daily_quest.dart';

class DailyQuestsWidget extends StatelessWidget {
  final List<DailyQuest> quests;
  const DailyQuestsWidget({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Text(tr(context, 'community.daily_title'), style: Theme.of(context).textTheme.titleMedium),
        ...quests.map((q) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(q.description, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr(context, 'daily.progress', {'progress': q.progress.toString(), 'goal': q.goal.toString()}), style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(value: q.progress/q.goal, minHeight: 6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ))
      ],
    );
  }
}
