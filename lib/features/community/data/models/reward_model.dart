import '../../domain/entities/reward.dart';

class RewardModel {
  final String id;
  final String name;
  final String icon;
  final int threshold;

  RewardModel({required this.id, required this.name, required this.icon, required this.threshold});

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    threshold: json['threshold'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'threshold': threshold,
  };

  Reward toEntity() => Reward(id: id, name: name, icon: icon, threshold: threshold);
}
