
import 'package:hive/hive.dart';

import 'badge.dart';
import 'block_data.dart';
import 'loot_item.dart';
import 'stats.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)

class UserProfile extends HiveObject {
  @HiveField(0)
  String userId;
  @HiveField(1)
  String pseudonyme;
  @HiveField(2)
  String avatar;
  @HiveField(3)
  int xp;
  @HiveField(4)
  int niveau;
  @HiveField(5)
  List<Badge> badges;
  @HiveField(6)
  List<BlockData> blocks;
  @HiveField(7)
  List<LootItem> loot;
  @HiveField(8)
  Stats stats;
  @HiveField(9)
  String nodeId;
  @HiveField(10)
  List<String> completedUniqueQuestIds; 

  UserProfile({
    required this.userId,
    required this.pseudonyme,
    required this.avatar,
    required this.xp,
    required this.niveau,
    required this.badges,
    required this.blocks,
    required this.loot,
    required this.stats,
    required this.nodeId,
    required this.completedUniqueQuestIds,
  });
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'pseudonyme': pseudonyme,
    'avatar': avatar,
    'xp': xp,
    'niveau': niveau,
    'badges': badges.map((b) => b.toJson()).toList(),
    'blocks': blocks.map((b) => b.toJson()).toList(),
    'loot': loot.map((l) => l.toJson()).toList(),
    'stats': stats.toJson(),
    'nodeId': nodeId,
    'completedUniqueQuestIds': completedUniqueQuestIds,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json['userId'],
    pseudonyme: json['pseudonyme'],
    avatar: json['avatar'],
    xp: json['xp'],
    niveau: json['niveau'],
    badges: (json['badges'] as List).map((b) => Badge.fromJson(b)).toList(),
    blocks: (json['blocks'] as List).map((b) => BlockData.fromJson(b)).toList(),
    loot: (json['loot'] as List).map((l) => LootItem.fromJson(l)).toList(),
    stats: Stats.fromJson(json['stats']),
    nodeId: json['nodeId'],
    completedUniqueQuestIds: List<String>.from(json['completedUniqueQuestIds'] ?? []),
  );
}
