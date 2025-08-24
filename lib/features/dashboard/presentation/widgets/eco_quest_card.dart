import 'dart:ui';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:flutter/material.dart';

class EcoQuestCard extends StatelessWidget {
  final Quest quest;
  final bool small;
  final bool vibrant;
  final VoidCallback? onCompletedTap;
  const EcoQuestCard({
    required this.quest,
    this.small = false,
    this.vibrant = false,
    this.onCompletedTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCompleted = quest.isCompleted;
    final pastelGradient = isCompleted
        ? LinearGradient(
            colors: [
              Colors.greenAccent.shade100,
              scheme.primary.withOpacity(0.18),
              Colors.white.withOpacity(0.85)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : (vibrant
            ? LinearGradient(
                colors: [Colors.yellow.shade50, scheme.primaryContainer, scheme.tertiaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [scheme.surface, Colors.white.withOpacity(0.93)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: small ? 4 : 7, horizontal: small ? 4 : 0),
      child: Stack(
        children: [
          GestureDetector(
        onTap: isCompleted
            ? (onCompletedTap ?? () {
                // Default completed quest tap: show a dialog
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Quest completed!'),
                    content: Text('You have completed "${quest.title}".'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              })
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("“${quest.title}” — ${quest.progress}/${quest.goal}"),
                    backgroundColor: scheme.primary.withOpacity(0.88),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    duration: Duration(milliseconds: 900),
                  ),
                );
              },
        child: Opacity(
          opacity: isCompleted ? 0.7 : 1.0,
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
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green.withOpacity(0.35)
                        : scheme.primary.withOpacity(vibrant ? 0.19 : 0.08),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: isCompleted
                            ? Colors.green.withOpacity(0.13)
                            : scheme.primary.withOpacity(0.07),
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
                        gradient: isCompleted
                            ? LinearGradient(
                                colors: [Colors.green, Colors.greenAccent.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
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
                        isCompleted ? Icons.check_circle_rounded : Icons.spa_rounded,
                        color: isCompleted ? Colors.green : scheme.primary,
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
                              color: isCompleted ? Colors.green : scheme.primary,
                              letterSpacing: -0.07,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: quest.goal == 0 ? 0 : quest.progress / quest.goal,
                            minHeight: small ? 3.0 : 4.2,
                            backgroundColor: scheme.surfaceVariant.withOpacity(0.17),
                            color: isCompleted ? Colors.green : scheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                          const SizedBox(width: 8),
                          Text(
                            '${quest.progress}/${quest.goal}',
                            style: TextStyle(
                              color: isCompleted ? Colors.green : scheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: small ? 10.5 : 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      );
  }
}
