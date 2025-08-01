import 'package:flutter/material.dart';
import '../../domain/entities/community_tree.dart';

class CommunityTreeWidget extends StatelessWidget {
  final CommunityTree tree;
  const CommunityTreeWidget({Key? key, required this.tree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple CustomPaint tree based on growthScore
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Arbre communautaire', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: 180,
          child: CustomPaint(
            painter: _TreePainter(tree.growthScore),
            child: Center(child: Text('Score: ${tree.growthScore}', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}

class _TreePainter extends CustomPainter {
  final int growthScore;
  _TreePainter(this.growthScore);

  @override
  void paint(Canvas canvas, Size size) {
    final trunk = Paint()..color = Colors.brown..strokeWidth = 12;
    final leaves = Paint()..color = Colors.green[400]!;
    // Draw trunk
    canvas.drawLine(Offset(size.width/2, size.height), Offset(size.width/2, size.height-60), trunk);
    // Draw leaves (size based on growthScore)
    final leafRadius = 40 + (growthScore/100).clamp(0, 60);
    canvas.drawCircle(Offset(size.width/2, size.height-80), leafRadius.toDouble(), leaves);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
