import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/quest_timer_placeholder.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quest_types.dart';
import 'eco_quest_card.dart';
import '../pages/dashboard_page.dart' show personalQuestsProvider;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EcoDailyQuestsList extends StatefulWidget {
  const EcoDailyQuestsList({super.key});
  @override
  State<EcoDailyQuestsList> createState() => _EcoDailyQuestsListState();
}

class _EcoDailyQuestsListState extends State<EcoDailyQuestsList> {
  List<Quest?> _visibleQuests = [null, null, null];
  List<DateTime?> _deletedTimes = [null, null, null];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuests(context);
    });
  }

  void _loadQuests(BuildContext context) {
    final ref = ProviderScope.containerOf(context, listen: false);
    final asyncValue = ref.read(personalQuestsProvider);
    asyncValue.whenData((quests) {
      setState(() {
        for (int i = 0; i < 3; i++) {
          _visibleQuests[i] = i < quests.length ? quests[i] : null;
        }
      });
    });
  }

  void _deleteQuest(int index) {
    setState(() {
      _visibleQuests[index] = null;
      _deletedTimes[index] = DateTime.now();
    });
    // Start timer to restore quest after 3 hours
    Future.delayed(const Duration(hours: 3), () {
      setState(() {
        _deletedTimes[index] = null;
        // Optionally reload a new quest here
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const _DailyQuestTimer(),
            const SizedBox(width: 4),
            Expanded(child: SizedBox()),
          ],
        ),
        ...List.generate(3, (i) {
          final quest = _visibleQuests[i];
          final deletedAt = _deletedTimes[i];
          if (quest != null && deletedAt == null) {
            return Dismissible(
              key: ValueKey(quest.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _deleteQuest(i),
              background: Container(
                color: Colors.red.withOpacity(0.13),
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Icon(FeatherIcons.trash2, color: Colors.red, size: 28),
                ),
              ),
              child: AnimatedQuestCard(
                quest: quest,
                delay: Duration(milliseconds: 200 + i * 90),
              ),
            );
          } else if (deletedAt != null) {
            return QuestTimerPlaceholder(deletedAt: deletedAt);
          } else {
            // Empty slot
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.18),
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(18),
                color: Colors.transparent,
              ),
              child: Center(
                child: Text('No quest', style: TextStyle(color: Colors.grey)),
              ),
            );
          }
        }),
      ],
    );
  }
}

class AnimatedQuestCard extends StatefulWidget {
  final Quest quest;
  final Duration delay;
  const AnimatedQuestCard({required this.quest, this.delay = Duration.zero, super.key});
  @override
  State<AnimatedQuestCard> createState() => _AnimatedQuestCardState();
}
class _AnimatedQuestCardState extends State<AnimatedQuestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: Offset(0, 0.09), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack));
    Future.delayed(widget.delay, () => mounted ? _anim.forward() : null);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: EcoQuestCard(quest: widget.quest),
      ),
    );
  }
}

class _DailyQuestTimer extends StatefulWidget {
  const _DailyQuestTimer();
  @override
  State<_DailyQuestTimer> createState() => _DailyQuestTimerState();
}
class _DailyQuestTimerState extends State<_DailyQuestTimer> {
  late Duration timeLeft;
  late final StreamSubscription ticker;
  @override
  void initState() {
    super.initState();
    _updateTime();
    ticker =
        Stream.periodic(const Duration(seconds: 1), (_) => _updateTime()).listen((_) {});
  }

  void _updateTime() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    setState(() {
      timeLeft = nextMidnight.difference(now);
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = timeLeft.inHours;
    final m = timeLeft.inMinutes % 60;
    final s = timeLeft.inSeconds % 60;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.44),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.05),
            blurRadius: 7,
            offset: const Offset(0, 1),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, color: scheme.primary, size: 17),
          const SizedBox(width: 5),
          Text(
            '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: scheme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "until refresh",
            style: TextStyle(
                color: scheme.onBackground.withOpacity(0.45),
                fontSize: 11,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
