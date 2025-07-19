class MeshNode {
  final String id;
  final String label;

  MeshNode({required this.id, required this.label});
}

class MeshEdge {
  final String from;
  final String to;

  MeshEdge({required this.from, required this.to});
}

class MeshMap {
  final List<MeshNode> nodes;
  final List<MeshEdge> edges;

  MeshMap({required this.nodes, required this.edges});
}
