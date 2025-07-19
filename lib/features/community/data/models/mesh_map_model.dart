import '../../domain/entities/mesh_map.dart';

class MeshNodeModel {
  final String id;
  final String label;

  MeshNodeModel({required this.id, required this.label});

  factory MeshNodeModel.fromJson(Map<String, dynamic> json) => MeshNodeModel(
    id: json['id'],
    label: json['label'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'label': label};

  MeshNode toEntity() => MeshNode(id: id, label: label);
}

class MeshEdgeModel {
  final String from;
  final String to;

  MeshEdgeModel({required this.from, required this.to});

  factory MeshEdgeModel.fromJson(Map<String, dynamic> json) => MeshEdgeModel(
    from: json['from'],
    to: json['to'],
  );

  Map<String, dynamic> toJson() => {'from': from, 'to': to};

  MeshEdge toEntity() => MeshEdge(from: from, to: to);
}

class MeshMapModel {
  final List<MeshNodeModel> nodes;
  final List<MeshEdgeModel> edges;

  MeshMapModel({required this.nodes, required this.edges});

  factory MeshMapModel.fromJson(Map<String, dynamic> json) => MeshMapModel(
    nodes: (json['nodes'] as List).map((n) => MeshNodeModel.fromJson(n)).toList(),
    edges: (json['edges'] as List).map((e) => MeshEdgeModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'nodes': nodes.map((n) => n.toJson()).toList(),
    'edges': edges.map((e) => e.toJson()).toList(),
  };

  MeshMap toEntity() => MeshMap(
    nodes: nodes.map((n) => n.toEntity()).toList(),
    edges: edges.map((e) => e.toEntity()).toList(),
  );
}
