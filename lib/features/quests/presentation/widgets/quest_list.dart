import '../../domain/entities/quest.dart';
import 'package:flutter/material.dart';
import 'quest_card.dart';

/// Widget to display a list of quests
class QuestList extends StatelessWidget {
  final List<Quest> quests;
  const QuestList({Key? key, required this.quests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return Center(child: Text('Aucune quête disponible', style: Theme.of(context).textTheme.bodyMedium));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quests.length,
      itemBuilder: (context, i) => QuestCard(quest: quests[i]),
    );
  }
}
