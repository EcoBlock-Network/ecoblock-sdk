import '../../domain/entities/community_tree.dart';

class CommunityTreeModel {
  final int growthScore;

  CommunityTreeModel({required this.growthScore});

  factory CommunityTreeModel.fromJson(Map<String, dynamic> json) {
    return CommunityTreeModel(growthScore: json['growthScore']);
  }

  Map<String, dynamic> toJson() => {'growthScore': growthScore};

  CommunityTree toEntity() => CommunityTree(growthScore: growthScore);
}
