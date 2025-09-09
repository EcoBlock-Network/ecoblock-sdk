import 'package:flutter/material.dart';

class ExpandArrow extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  const ExpandArrow({required this.isExpanded, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.black45.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
