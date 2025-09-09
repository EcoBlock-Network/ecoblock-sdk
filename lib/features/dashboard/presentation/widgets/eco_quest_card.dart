import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'eco_quest_badge.dart';
import 'eco_progress_pill.dart';
import 'eco_status_chip.dart';

/// Modern EcoQuestCard — glass card, gradient icon badge, animated pill progress with percentage
class EcoQuestCard extends StatefulWidget {
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
  State<EcoQuestCard> createState() => _EcoQuestCardState();
}

class _EcoQuestCardState extends State<EcoQuestCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;
  late double _lastProgress;
  DateTime _lastPulseAt = DateTime.fromMillisecondsSinceEpoch(0);
  int? _lastShownDelta;
  bool _showGlow = false;

  @override
  void initState() {
    super.initState();
    _lastProgress = widget.quest.goal == 0 ? 0.0 : (widget.quest.progress / widget.quest.goal).clamp(0.0, 1.0);
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08).chain(CurveTween(curve: Curves.easeOut)), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 40),
    ]).animate(_pulseController);
  }

  @override
  void didUpdateWidget(covariant EcoQuestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newProgress = widget.quest.goal == 0 ? 0.0 : (widget.quest.progress / widget.quest.goal).clamp(0.0, 1.0);
    if ((newProgress - _lastProgress).abs() > 0.0001) {
      // debounce rapid updates so the pulse remains punchy and not spammy
      final now = DateTime.now();
      if (now.difference(_lastPulseAt) > const Duration(milliseconds: 300)) {
        _pulseController.forward(from: 0.0);
        _lastPulseAt = now;
      }
      // compute delta in absolute units, show small transient badge
      final oldAbs = (_lastProgress * (widget.quest.goal)).round();
      final newAbs = (newProgress * (widget.quest.goal)).round();
      final delta = newAbs - oldAbs;
      if (delta > 0) {
        _lastShownDelta = delta;
        _showGlow = true;
        if (mounted) setState(() {});
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) setState(() => _showGlow = false);
        });
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) setState(() => _lastShownDelta = null);
        });
      }
      _lastProgress = newProgress;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCompleted = widget.quest.isCompleted;
    final badgeColor = widget.vibrant ? scheme.secondary : scheme.primary;
    final progress = widget.quest.goal == 0 ? 0.0 : (widget.quest.progress / widget.quest.goal).clamp(0.0, 1.0);
  final reduceMotion = MediaQuery.of(context).accessibleNavigation;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.small ? 6 : 8, horizontal: widget.small ? 6 : 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.small ? 12 : 16),
          onTap: () async {
            HapticFeedback.selectionClick();
            if (isCompleted) {
              if (widget.onCompletedTap != null) return widget.onCompletedTap!();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(tr(context, 'quest_completed_title')),
                  content: Text(tr(context, 'quest_completed_content', {'title': widget.quest.title})),
                  actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(tr(context, 'ok')))],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr(context, 'quest_progress', {
                    'title': widget.quest.title,
                    'progress': widget.quest.progress.toString(),
                    'goal': widget.quest.goal.toString()
                  })),
                  backgroundColor: scheme.primary.withOpacity(0.95),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  duration: const Duration(milliseconds: 900),
                ),
              );
            }
          },
          child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.small ? 12 : 16),
                color: scheme.surface.withOpacity(0.08),
                border: Border.all(color: scheme.surfaceVariant.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              padding: EdgeInsets.all(widget.small ? 12 : 16),
            child: Row(
              children: [
                EcoQuestBadge(isCompleted: isCompleted, badgeColor: badgeColor, lastShownDelta: _lastShownDelta, small: widget.small),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quest.title,
                        style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900, fontSize: widget.small ? 14 : 16),
                        maxLines: widget.small ? 1 : 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(builder: (context, constraints) {
                        final barHeight = widget.small ? 28.0 : 34.0;
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              width: double.infinity,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: scheme.surface.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(barHeight / 2),
                              ),
                            ),
                            EcoProgressPill(progress: progress, badgeColor: badgeColor, showGlow: _showGlow, small: widget.small, pulseAnim: _pulseAnim, reduceMotion: reduceMotion),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // status chip
                EcoStatusChip(isCompleted: isCompleted, badgeColor: badgeColor, small: widget.small),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
