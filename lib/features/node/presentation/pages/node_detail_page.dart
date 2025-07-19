import 'package:flutter/material.dart';

class NodeDetailPage extends StatelessWidget {
  const NodeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Infos détaillées sur le nœud', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
