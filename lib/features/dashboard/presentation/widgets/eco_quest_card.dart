import 'dart:ui';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:flutter/material.dart';
import 'quest_types.dart';

class EcoQuestCard extends StatelessWidget {
  final Quest quest;
  final bool small;
  final bool vibrant;
  const EcoQuestCard({
    required this.quest,
    this.small = false,
    this.vibrant = false,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pastelGradient = LinearGradient(
      colors: vibrant
          ? [Colors.yellow.shade50, scheme.primaryContainer, scheme.tertiaryContainer]
          : [scheme.surface, Colors.white.withOpacity(0.93)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: small ? 4 : 7, horizontal: small ? 4 : 0),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("“${quest.title}” — ${quest.progress}/${quest.goal}"),
              backgroundColor: scheme.primary.withOpacity(0.88),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              duration: Duration(milliseconds: 900),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(small ? 15 : 20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Container(
              width: small ? 168 : null,
              padding: EdgeInsets.symmetric(horizontal: small ? 12 : 17, vertical: small ? 11 : 15),
              decoration: BoxDecoration(
                gradient: pastelGradient,
                borderRadius: BorderRadius.circular(small ? 15 : 20),
                border: Border.all(color: scheme.primary.withOpacity(vibrant ? 0.19 : 0.08), width: 1.1),
                boxShadow: [
                  BoxShadow(
                      color: scheme.primary.withOpacity(0.07),
                      blurRadius: 17,
                      offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: small ? 24 : 33,
                    height: small ? 24 : 33,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent.shade100,
                          scheme.primary.withOpacity(0.84),
                          if (vibrant) Colors.yellowAccent.withOpacity(0.56),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      color: scheme.primary,
                      size: small ? 16 : 21,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: small ? 12.5 : 15,
                            color: scheme.primary,
                            letterSpacing: -0.07,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: quest.goal == 0 ? 0 : quest.progress / quest.goal,
                          minHeight: small ? 3.0 : 4.2,
                          backgroundColor: scheme.surfaceVariant.withOpacity(0.17),
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${quest.progress}/${quest.goal}',
                    style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: small ? 10.5 : 13.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
