import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

class TreeGrowthWidget extends StatelessWidget {
  final double progression;
  const TreeGrowthWidget({super.key, required this.progression});

  @override
  Widget build(BuildContext context) {
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
      ..color = AppColors.green.withAlpha((0.7 * 255).toInt())
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(size.width/2-10, size.height-60, 20, 60), paint..color = AppColors.brown);
    final foliageRadius = 40 + 60 * progression;
    canvas.drawCircle(Offset(size.width/2, size.height-60), foliageRadius, paint..color = AppColors.green.withAlpha((0.7 * 255).toInt()));
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) => oldDelegate.progression != progression;
}
