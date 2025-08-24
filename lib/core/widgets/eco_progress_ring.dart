import 'package:flutter/material.dart';

class EcoProgressRing extends StatelessWidget {
  final double progress;
  final Gradient gradient;
  final double size;
  final Widget child;

  const EcoProgressRing({super.key, required this.progress, required this.gradient, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, _) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
          ),
          SizedBox(
            width: size - 12,
            height: size - 12,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
