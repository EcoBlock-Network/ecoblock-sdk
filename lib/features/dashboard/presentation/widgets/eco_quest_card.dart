import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'eco_quest_badge.dart';
import 'eco_progress_pill.dart';
import 'package:ecoblock_mobile/shared/widgets/top_snack_bar.dart';

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
    final reduceMotion = MediaQueryData.fromWindow(WidgetsBinding.instance.window).accessibleNavigation;
    _pulseController = AnimationController(vsync: this, duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 320));
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.09).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.09, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 40),
    ]).animate(_pulseController);
  }

  @override
  void didUpdateWidget(covariant EcoQuestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  final reduceMotion = MediaQueryData.fromWindow(WidgetsBinding.instance.window).accessibleNavigation;
    final newProgress = widget.quest.goal == 0 ? 0.0 : (widget.quest.progress / widget.quest.goal).clamp(0.0, 1.0);
  if ((newProgress - _lastProgress).abs() > 0.0005) {
      final now = DateTime.now();
      if (now.difference(_lastPulseAt) > const Duration(milliseconds: 300)) {
        _pulseController.forward(from: 0.0);
        _lastPulseAt = now;
      }
      final oldAbs = (_lastProgress * (widget.quest.goal)).round();
      final newAbs = (newProgress * (widget.quest.goal)).round();
      final delta = newAbs - oldAbs;
      if (delta > 0) {
        _lastShownDelta = delta;
        _showGlow = true;
        if (mounted) setState(() {});
        Future.delayed(reduceMotion ? Duration.zero : const Duration(milliseconds: 900), () {
          if (mounted) setState(() => _showGlow = false);
        });
        Future.delayed(reduceMotion ? Duration.zero : const Duration(milliseconds: 1200), () {
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
          borderRadius: BorderRadius.circular(widget.small ? 6 : 6),
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
              try {
                TopSnackBar.show(
                  context,
                  Row(children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tr(context, 'quest_progress', {
                      'title': widget.quest.title,
                      'progress': widget.quest.progress.toString(),
                      'goal': widget.quest.goal.toString()
                    }), style: const TextStyle(color: Colors.white))),
                  ]),
                  duration: const Duration(milliseconds: 900),
                );
              } catch (_) {}
            }
          },
          child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.small ? 6 : 6),
                color: Theme.of(context).brightness == Brightness.dark
                    ? scheme.surface.withOpacity(0.10)
                    : scheme.surface.withOpacity(0.12),
                boxShadow: [
                  BoxShadow(color: scheme.primary.withOpacity(0.10), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              padding: EdgeInsets.all(widget.small ? 10 : 14),
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
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 8),
                ])
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
