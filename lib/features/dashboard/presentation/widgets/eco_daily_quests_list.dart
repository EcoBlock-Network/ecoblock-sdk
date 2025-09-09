import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/theme/theme.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'dart:async';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_persistence_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'eco_quest_card.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EcoDailyQuestsList extends ConsumerStatefulWidget {
  const EcoDailyQuestsList({super.key});
  @override
  ConsumerState<EcoDailyQuestsList> createState() => _EcoDailyQuestsListState();
}

class AnimatedTimerPlaceholder extends StatefulWidget {
  final DateTime deletedAt;
  const AnimatedTimerPlaceholder({required this.deletedAt, super.key});
  @override
  State<AnimatedTimerPlaceholder> createState() => _AnimatedTimerPlaceholderState();
}

class _AnimatedTimerPlaceholderState extends State<AnimatedTimerPlaceholder> {
  late Duration timeLeft;
  late final StreamSubscription ticker;

  @override
  void initState() {
    super.initState();
    _updateTime();
    ticker = Stream.periodic(const Duration(seconds: 1), (_) => _updateTime()).listen((_) {});
  }

  void _updateTime() {
    final elapsed = DateTime.now().difference(widget.deletedAt);
    final remaining = Duration(hours: 3) - elapsed;
    setState(() {
      timeLeft = remaining.isNegative ? Duration.zero : remaining;
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = Duration(hours: 3).inSeconds;
    final left = timeLeft.inSeconds;
    final progress = (total - left) / total;
    final bgColor = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.06);
    final fillColor = Theme.of(context).colorScheme.primary.withOpacity(0.12);

    final h = timeLeft.inHours;
    final m = timeLeft.inMinutes % 60;
    final s = timeLeft.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: bgColor,
            ),
            height: 64,
          ),
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: fillColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 64,
            child: Row(
              children: [
                Container(width: 22, height: 22, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(6))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr(context, 'until_new_quest'),
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.64), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EcoDailyQuestsListState extends ConsumerState<EcoDailyQuestsList> {
  final List<Quest?> _visibleQuests = [null, null, null];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithProvider();
    });
  }

  void _syncWithProvider() {
    final asyncValue = ref.read(personalQuestsProvider);
    final persistence = ref.read(questPersistenceProvider);
    asyncValue.whenData((quests) {
      setState(() {
        for (int i = 0; i < 3; i++) {
          final id = persistence.visibleQuestIds.length > i
              ? persistence.visibleQuestIds[i]
              : null;
          if (id != null) {
            final found = quests.where((q) => q.id == id).toList();
            _visibleQuests[i] = found.isNotEmpty
                ? found.first
                : (i < quests.length ? quests[i] : null);
          } else {
            _visibleQuests[i] = i < quests.length ? quests[i] : null;
          }
        }
      });
    });
  }

  void _deleteQuest(int index) async {
    setState(() {
      _visibleQuests[index] = null;
    });
    await ref
        .read(questPersistenceProvider.notifier)
        .setVisibleQuestId(index, null);
    await ref
        .read(questPersistenceProvider.notifier)
        .setDeletedTime(index, DateTime.now());
    Future.delayed(const Duration(hours: 3), () async {
      await ref
          .read(questPersistenceProvider.notifier)
          .setDeletedTime(index, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(personalQuestsProvider);
    final persistence = ref.watch(questPersistenceProvider);
    asyncValue.whenData((quests) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncWithProvider();
      });
    });
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
          var quest = _visibleQuests[i];
          final deletedAt = persistence.deletedTimes.length > i
              ? persistence.deletedTimes[i]
              : null;
          if (quest == null) {
            final fallback = _visibleQuests.firstWhere(
              (q) => q != null,
              orElse: () => null,
            );
            if (fallback != null) quest = fallback;
          }
          if (quest != null && deletedAt == null) {
            return Dismissible(
              // make key unique per slot to avoid duplicate key errors when the same quest is reused
              key: ValueKey('${quest.id}-$i'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _deleteQuest(i),
                background: Container(
                color: AppColors.error.withAlpha((0.13 * 255).toInt()),
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Icon(FeatherIcons.trash2, color: AppColors.error, size: 28),
                ),
              ),
              child: AnimatedQuestCard(
                quest: quest,
                delay: Duration(milliseconds: 200 + i * 90),
              ),
            );
          } else if (deletedAt != null) {
            return AnimatedTimerPlaceholder(key: ValueKey('deleted-timer-$i'), deletedAt: deletedAt);
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Card(
                  elevation: 2,
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    child: Center(
                      child: Text(
                        tr(context, 'no_quest'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
                        ),
                      ),
                    ),
                  ),
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
  const AnimatedQuestCard({
    super.key,
    required this.quest,
    this.delay = Duration.zero,
  });
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
    // Respect reduced motion preference
    final reduceMotion = WidgetsBinding.instance.window.accessibilityFeatures.reduceMotion;
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: Offset(0, 0.09),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack));
    final startDelay = widget.delay + const Duration(milliseconds: 60);
    if (reduceMotion) {
      Future.delayed(startDelay, () => mounted ? _anim.value = 1.0 : null);
    } else {
      Future.delayed(startDelay, () => mounted ? _anim.forward() : null);
    }
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
        child: ScaleTransition(
          scale: TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.02).chain(CurveTween(curve: Curves.easeOut)), weight: 60),
            TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 40),
          ]).animate(_anim),
          child: EcoQuestCard(quest: widget.quest),
        ),
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
    ticker = Stream.periodic(
      const Duration(seconds: 1),
      (_) => _updateTime(),
    ).listen((_) {});
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
        color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, color: scheme.primary.withValues(alpha: 0.92), size: 16),
          const SizedBox(width: 6),
          Text(
            '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: scheme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            tr(context, 'until_refresh'),
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.62),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
