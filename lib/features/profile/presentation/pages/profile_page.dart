import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final profileProvider = Provider<ProfileData>((ref) {
  return ProfileData(level: 5, xp: 3200);
});

class ProfileData {
  final int level;
  final int xp;
  ProfileData({required this.level, required this.xp});
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 48, backgroundColor: Colors.green, child: Icon(Icons.park, size: 48, color: Colors.white)),
            const SizedBox(height: 16),
            const Text('Mon arbre virtuel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Niveau ${profile.level} – ${profile.xp} XP'),
          ],
        ),
      ),
    );
  }
}
