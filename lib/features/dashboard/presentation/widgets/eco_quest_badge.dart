import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/core/ux/motion.dart';

class EcoQuestBadge extends StatelessWidget {
  final bool isCompleted;
  final Color badgeColor;
  final int? lastShownDelta;
  final bool small;

  const EcoQuestBadge({super.key, required this.isCompleted, required this.badgeColor, this.lastShownDelta, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: small ? 44 : 56,
          height: small ? 44 : 56,
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
              size: small ? 20 : 24,
            ),
          ),
        ),
        if (lastShownDelta != null)
          Positioned(
            right: -6,
            top: -8,
            child: AnimatedSwitcher(
              duration: AppMotion.short,
              transitionBuilder: (child, anim) {
                final offsetAnim = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(anim);
                return SlideTransition(position: offsetAnim, child: FadeTransition(opacity: anim, child: child));
              },
              child: lastShownDelta != null
                  ? Container(
                      key: ValueKey(lastShownDelta),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 3))],
                      ),
                      child: Text(
                        '+$lastShownDelta',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }
}
