import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../../domain/entities/upcoming_quest.dart';

class UpcomingQuestsWidget extends StatelessWidget {
  final List<UpcomingQuest> quests;
  const UpcomingQuestsWidget({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(tr(context, 'community.upcoming_title'), style: Theme.of(context).textTheme.titleMedium),
      children: quests.map((q) {
        final color = q.status == 'past' ? Colors.grey[300] : q.status == 'current' ? Colors.green[100] : Colors.blue[100];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  q.title,
                  style: TextStyle(
                    color: q.status == 'past' ? Colors.grey : Colors.black,
                    fontWeight: q.status == 'current' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Text(q.date, style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
