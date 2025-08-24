import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class NodeDetailPage extends StatelessWidget {
  const NodeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
  child: Text(tr(context, 'node_detail_info'), style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
