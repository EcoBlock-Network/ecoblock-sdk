import 'dart:ui';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/theme/theme.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'dart:async';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_persistence_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'eco_quest_card.dart';
import 'quest_timer_placeholder.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EcoDailyQuestsList extends ConsumerStatefulWidget {
  const EcoDailyQuestsList({super.key});
  @override
  ConsumerState<EcoDailyQuestsList> createState() => _EcoDailyQuestsListState();
}

class _EcoDailyQuestsListState extends ConsumerState<EcoDailyQuestsList> {
  final List<Quest?> _visibleQuests = [null, null, null];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Object> _items = [];

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
        final List<Object> entries = [];
        final deletedTimes = persistence.deletedTimes;
        for (int i = 0; i < 3; i++) {
          final deletedAt = deletedTimes.length > i ? deletedTimes[i] : null;
          final quest = _visibleQuests[i];
          if (deletedAt != null) {
            entries.add(deletedAt);
          } else if (quest != null) {
            entries.add(quest);
          }
        }
        _applyListDiffs(entries);
      });
    });
  }

  void _applyListDiffs(List<Object> newEntries) {
    String keyOf(Object o) => o is Quest ? o.id : 'deleted-${o.toString()}';
    final prevKeys = _items.map(keyOf).toList();
    final newKeys = newEntries.map(keyOf).toList();

    for (int i = prevKeys.length - 1; i >= 0; i--) {
      final k = prevKeys[i];
      if (!newKeys.contains(k)) {
        final removed = _items.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: removed is Quest ? EcoQuestCard(quest: removed, small: false) : QuestTimerPlaceholder(deletedAt: removed as DateTime),
            ),
          ),
          duration: const Duration(milliseconds: 320),
        );
      }
    }

    for (int i = 0; i < newEntries.length; i++) {
      final k = keyOf(newEntries[i]);
      if (!prevKeys.contains(k)) {
        _items.insert(i, newEntries[i]);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 320));
      } else {
        final currentIndex = _items.indexWhere((e) => keyOf(e) == k);
        if (currentIndex != i) {
          final moved = _items.removeAt(currentIndex);
          _items.insert(i, moved);
        }
      }
    }
  }

  void _deleteQuest(int slotIndex) async {
    final quest = _visibleQuests[slotIndex];
    if (quest == null) return;
    int itemIndex = -1;
    for (int i = 0; i < _items.length; i++) {
      final e = _items[i];
      if (e is Quest && e.id == quest.id) {
        itemIndex = i;
        break;
      }
    }
    if (itemIndex != -1) {
      final removed = _items.removeAt(itemIndex);
      _listKey.currentState?.removeItem(
        itemIndex,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: EcoQuestCard(quest: removed as Quest, small: false),
          ),
        ),
        duration: const Duration(milliseconds: 320),
      );
      final deletedAt = DateTime.now();
      _items.insert(itemIndex, deletedAt);
      _listKey.currentState?.insertItem(itemIndex, duration: const Duration(milliseconds: 320));
    }
    setState(() {
      _visibleQuests[slotIndex] = null;
    });
    await ref
        .read(questPersistenceProvider.notifier)
        .setVisibleQuestId(slotIndex, null);
    await ref
        .read(questPersistenceProvider.notifier)
        .setDeletedTime(slotIndex, DateTime.now());
    Future.delayed(const Duration(hours: 3), () async {
      await ref
          .read(questPersistenceProvider.notifier)
          .setDeletedTime(slotIndex, null);
    });
  }

  @override
  Widget build(BuildContext context) {
  final asyncValue = ref.watch(personalQuestsProvider);
  ref.watch(questPersistenceProvider);
    asyncValue.whenData((quests) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncWithProvider();
      });
    });
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 420;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
        child: Column(
      children: [
        Row(
          children: [
            const _DailyQuestTimer(),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8),
        if (_items.isEmpty)
          Container(
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
          )
        else
          AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            initialItemCount: _items.length,
            itemBuilder: (context, idx, animation) {
              final entry = _items[idx];
              return SizeTransition(
                sizeFactor: animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: entry is Quest
                      ? Dismissible(
                          key: ValueKey('${entry.id}-$idx'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            final slotIndex = _visibleQuests.indexWhere((q) => q?.id == entry.id);
                            _deleteQuest(slotIndex);
                          },
                          background: Container(
                            color: AppColors.error.withAlpha((0.13 * 255).toInt()),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Icon(FeatherIcons.trash2, color: AppColors.error, size: 28),
                            ),
                          ),
                          child: AnimatedQuestCard(
                            quest: entry,
                            delay: Duration(milliseconds: 200 + idx * 90),
                            key: ValueKey('quest-card-$idx-${entry.id}'),
                            small: compact,
                          ),
                        )
                      : QuestTimerPlaceholder(key: ValueKey('deleted-timer-$idx'), deletedAt: entry as DateTime),
                ),
              );
            },
          ),
      ],
    ),
  );
});
  }
}

class AnimatedQuestCard extends StatefulWidget {
  final Quest quest;
  final Duration delay;
  final bool small;
  const AnimatedQuestCard({
    super.key,
    required this.quest,
    this.delay = Duration.zero,
    this.small = false,
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
            TweenSequenceItem(
              tween: Tween(begin: 0.96, end: 1.02).chain(CurveTween(curve: Curves.easeOut)),
              weight: 60,
            ),
            TweenSequenceItem(
              tween: Tween(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
              weight: 40,
            ),
          ]).animate(_anim),
          child: EcoQuestCard(quest: widget.quest, small: widget.small),
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
