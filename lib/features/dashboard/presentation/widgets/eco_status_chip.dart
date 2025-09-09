import 'package:flutter/material.dart';

class EcoStatusChip extends StatelessWidget {
  final bool isCompleted;
  final Color badgeColor;
  final bool small;

  const EcoStatusChip({super.key, required this.isCompleted, required this.badgeColor, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 10, vertical: small ? 6 : 8),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.white.withOpacity(0.06) : badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (isCompleted) ...[
            Icon(Icons.check, size: small ? 14 : 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)),
            const SizedBox(width: 8),
          ],
          Text(
            isCompleted ? 'Done' : '',
            style: TextStyle(color: isCompleted ? Theme.of(context).colorScheme.onSurface : badgeColor, fontWeight: FontWeight.w700, fontSize: small ? 12 : 13),
          ),
        ],
      ),
    );
  }
}
