import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'eco_quest_card.dart';

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
    final reduceMotion = WidgetsBinding.instance.window.accessibilityFeatures.reduceMotion;
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.09),
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
