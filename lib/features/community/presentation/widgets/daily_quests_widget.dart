import 'package:flutter/material.dart';
import '../../domain/entities/daily_quest.dart';

class DailyQuestsWidget extends StatelessWidget {
  final List<DailyQuest> quests;
  const DailyQuestsWidget({Key? key, required this.quests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Défis communautaires du jour', style: Theme.of(context).textTheme.titleMedium),
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
                    Text('${q.progress}/${q.goal}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
