import 'package:flutter/material.dart';
import '../../domain/entities/mesh_map.dart';

class MeshMapWidget extends StatelessWidget {
  final MeshMap meshMap;
  const MeshMapWidget({Key? key, required this.meshMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Carte du réseau local', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: 180,
          child: CustomPaint(
            painter: _MeshPainter(meshMap),
            child: Container(),
          ),
        ),
      ],
    );
  }
}

class _MeshPainter extends CustomPainter {
  final MeshMap meshMap;
  _MeshPainter(this.meshMap);

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()..color = Colors.blueAccent;
    final edgePaint = Paint()..color = Colors.grey..strokeWidth = 2;
    final nodeRadius = 18.0;
    final positions = <String, Offset>{};
    final count = meshMap.nodes.length;
    for (var i = 0; i < count; i++) {
      final angle = (2 * 3.14159 * i) / count;
      final x = size.width/2 + 60 * (1.2 * (i%2+1)) * (i.isEven ? 1 : -1) * (0.5 + i/10) * (i%3==0 ? 1 : 0.8);
      final y = size.height/2 + 60 * (1.2 * (i%2+1)) * (i.isOdd ? 1 : -1) * (0.5 + i/10) * (i%3==0 ? 1 : 0.8);
      positions[meshMap.nodes[i].id] = Offset(x, y);
    }
    // Draw edges
    for (final edge in meshMap.edges) {
      final from = positions[edge.from]!;
      final to = positions[edge.to]!;
      canvas.drawLine(from, to, edgePaint);
    }
    // Draw nodes
    for (final node in meshMap.nodes) {
      final pos = positions[node.id]!;
      canvas.drawCircle(pos, nodeRadius, nodePaint);
      final textSpan = TextSpan(text: node.label, style: const TextStyle(color: Colors.black, fontSize: 12));
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, pos + Offset(-nodeRadius, nodeRadius+2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
