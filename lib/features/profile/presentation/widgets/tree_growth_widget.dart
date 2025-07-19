import 'package:flutter/material.dart';

class TreeGrowthWidget extends StatelessWidget {
  final double progression;
  const TreeGrowthWidget({super.key, required this.progression});

  @override
  Widget build(BuildContext context) {
    // Placeholder CustomPaint, replace with Rive for real animation
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 800),
      child: SizedBox(
        height: 180,
        child: CustomPaint(
          painter: _TreePainter(progression),
        ),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  final double progression;
  _TreePainter(this.progression);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    // Draw trunk
    canvas.drawRect(Rect.fromLTWH(size.width/2-10, size.height-60, 20, 60), paint..color = Colors.brown);
    // Draw foliage based on progression
    final foliageRadius = 40 + 60 * progression;
    canvas.drawCircle(Offset(size.width/2, size.height-60), foliageRadius, paint..color = Colors.green.withOpacity(0.7));
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) => oldDelegate.progression != progression;
}
