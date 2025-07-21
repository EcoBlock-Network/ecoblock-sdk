import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String avatarUrl;
  @HiveField(2)
  List<String> badges;
  @HiveField(3)
  Map<String, int> stats;

  UserProfile({
    required this.name,
    required this.avatarUrl,
    required this.badges,
    required this.stats,
  });
}
