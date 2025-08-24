import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';


class MessagingPage extends ConsumerWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(tr(context, 'messaging.title')),
      ),
    );
  }
}
