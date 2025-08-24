import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mesh_simulator_controller.dart';

class MeshSimulatorPage extends ConsumerWidget {
  const MeshSimulatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topology = ref.watch(meshSimulatorProvider);
    return Scaffold(
  appBar: AppBar(title: Text(tr(context, 'mesh_simulator_title'))),
      body: Center(
        child: SizedBox(
          width: 320,
          height: 320,
          child: CustomPaint(
            painter: _MeshPainter(topology),
            child: Container(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(meshSimulatorProvider.notifier).propagate('1'),
        child: const Icon(Icons.send),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final MeshTopology topology;
  _MeshPainter(this.topology);

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()..color = Colors.blueAccent;
    final edgePaint = Paint()..color = Colors.grey..strokeWidth = 2;
    final nodeRadius = 18.0;
    // Draw edges
    for (final edge in topology.edges) {
      final from = topology.nodes.firstWhere((n) => n.id == edge.from).position;
      final to = topology.nodes.firstWhere((n) => n.id == edge.to).position;
      canvas.drawLine(from, to, edgePaint);
    }
    // Draw nodes
    for (final node in topology.nodes) {
      canvas.drawCircle(node.position, nodeRadius, nodePaint);
      final textSpan = TextSpan(text: node.label, style: const TextStyle(color: Colors.black, fontSize: 12));
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, node.position + Offset(-nodeRadius, nodeRadius+2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
