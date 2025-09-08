import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoblock_mobile/core/ux/motion.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

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
            // haptic feedback
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
                // Gradient circular badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                  width: widget.small ? 44 : 56,
                  height: widget.small ? 44 : 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [badgeColor.withOpacity(0.98), badgeColor.withOpacity(0.68)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Center(
                    child: Icon(
                      isCompleted ? Icons.emoji_events_rounded : Icons.eco_rounded,
                      color: Colors.white,
                      size: widget.small ? 20 : 24,
                    ),
                  ),
                    ),
                    if (_lastShownDelta != null)
                      Positioned(
                        right: -6,
                        top: -8,
                          child: AnimatedSwitcher(
                            duration: AppMotion.short,
                            transitionBuilder: (child, anim) {
                              final offsetAnim = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(anim);
                              return SlideTransition(position: offsetAnim, child: FadeTransition(opacity: anim, child: child));
                            },
                            child: _lastShownDelta != null
                                ? Container(
                                    key: ValueKey(_lastShownDelta),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent.shade400,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 3))],
                                    ),
                                    child: Text(
                                      '+${_lastShownDelta!}',
                                      style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 12),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                // Content
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
                      // Modern pill progress with percentage
                      LayoutBuilder(builder: (context, constraints) {
                        final barHeight = widget.small ? 28.0 : 34.0;
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // Background pill
                            Container(
                              width: double.infinity,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: scheme.surface.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(barHeight / 2),
                              ),
                            ),
                            // Filled gradient (disable animation if user prefers reduced motion)
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: progress),
                              duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 700),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Container(
                                  width: constraints.maxWidth * value,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [badgeColor, badgeColor.withOpacity(0.7)]),
                                    borderRadius: BorderRadius.circular(barHeight / 2),
                                    boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))],
                                  ),
                                );
                              },
                            ),
                            // Glow overlay when progress increments
                            if (_showGlow)
                              Positioned(
                                left: 0,
                                child: IgnorePointer(
                                  child: AnimatedOpacity(
                                    duration: AppMotion.short,
                                    opacity: _showGlow ? 0.9 : 0.0,
                                    child: Container(
                                      width: constraints.maxWidth * progress,
                                      height: barHeight,
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(colors: [badgeColor.withOpacity(0.14), Colors.transparent], radius: 0.9),
                                        borderRadius: BorderRadius.circular(barHeight / 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // Percentage badge at left with pulse
                            Positioned(
                              left: 8,
                              child: ScaleTransition(
                                scale: reduceMotion ? const AlwaysStoppedAnimation(1.0) : _pulseAnim,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.03)),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${(progress * 100).round()}%',
                                        style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w800, fontSize: widget.small ? 12 : 14),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(isCompleted ? Icons.check_circle : Icons.arrow_upward, size: widget.small ? 12 : 14, color: scheme.onSurface.withOpacity(0.85)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right status chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widget.small ? 8 : 10, vertical: widget.small ? 6 : 8),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.white.withOpacity(0.06) : badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (isCompleted) ...[
                        Icon(Icons.check, size: widget.small ? 14 : 16, color: scheme.onSurface.withOpacity(0.85)),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        isCompleted ? tr(context, 'done') : '${widget.quest.progress}/${widget.quest.goal}',
                        style: TextStyle(color: isCompleted ? scheme.onSurface : badgeColor, fontWeight: FontWeight.w700, fontSize: widget.small ? 12 : 13),
                      ),
                    ],
                  ),
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
