import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
  child: Text(tr(context, 'help_title'), style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
