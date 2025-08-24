import '../../domain/entities/quest.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'quest_card.dart';

/// Widget to display a list of quests
class QuestList extends StatelessWidget {
  final List<Quest> quests;
  const QuestList({Key? key, required this.quests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return Center(child: Text(tr(context, 'no_quests_available'), style: Theme.of(context).textTheme.bodyMedium));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quests.length,
      itemBuilder: (context, i) => QuestCard(quest: quests[i]),
    );
  }
}
