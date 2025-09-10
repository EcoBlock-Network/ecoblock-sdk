import 'package:flutter/material.dart';

class QuickToggles extends StatefulWidget {
  final bool autoSync;
  final bool sharePublic;
  final void Function(String key, bool value)? onToggle;
  const QuickToggles({Key? key, required this.autoSync, required this.sharePublic, this.onToggle}) : super(key: key);

  @override
  State<QuickToggles> createState() => _QuickTogglesState();
}

class _QuickTogglesState extends State<QuickToggles> {
  late bool _autoSync;
  late bool _sharePublic;

  @override
  void initState() {
    super.initState();
    _autoSync = widget.autoSync;
    _sharePublic = widget.sharePublic;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Sync automatique'), Switch(value: _autoSync, onChanged: (v) { setState(() => _autoSync = v); widget.onToggle?.call('autoSync', v); })]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Profil public'), Switch(value: _sharePublic, onChanged: (v) { setState(() => _sharePublic = v); widget.onToggle?.call('sharePublic', v); })]),
    ]);
  }
}
