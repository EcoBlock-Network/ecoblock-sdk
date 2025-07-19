import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CommunityPage extends ConsumerWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text('Classement, défis, communauté', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
