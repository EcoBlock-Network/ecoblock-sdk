import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('FAQ, support, à propos', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
