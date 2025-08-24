import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

class MeshNode {
  final String id;
  final String label;
  Offset position;
  MeshNode({required this.id, required this.label, required this.position});
}

class MeshEdge {
  final String from;
  final String to;
  MeshEdge({required this.from, required this.to});
}

class MeshTopology {
  final List<MeshNode> nodes;
  final List<MeshEdge> edges;
  MeshTopology({required this.nodes, required this.edges});
}

class MeshSimulatorController extends StateNotifier<MeshTopology> {
  MeshSimulatorController() : super(_generateMockTopology());

  static MeshTopology _generateMockTopology() {
    final nodes = [
      MeshNode(id: '1', label: 'A', position: Offset(100, 100)),
      MeshNode(id: '2', label: 'B', position: Offset(200, 120)),
      MeshNode(id: '3', label: 'C', position: Offset(150, 220)),
      MeshNode(id: '4', label: 'D', position: Offset(80, 200)),
    ];
    final edges = [
      MeshEdge(from: '1', to: '2'),
      MeshEdge(from: '2', to: '3'),
      MeshEdge(from: '3', to: '4'),
      MeshEdge(from: '4', to: '1'),
    ];
    return MeshTopology(nodes: nodes, edges: edges);
  }

  void propagate(String fromId) {
  }
}

final meshSimulatorProvider = StateNotifierProvider<MeshSimulatorController, MeshTopology>((ref) {
  return MeshSimulatorController();
});
