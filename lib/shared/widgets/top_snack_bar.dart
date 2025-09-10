import 'package:flutter/material.dart';

class TopSnackBar {
  static OverlayEntry? _current;

  static void show(BuildContext context, Widget child, {Duration duration = const Duration(seconds: 2)}) {
    _current?.remove();
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(builder: (ctx) {
      return _TopSnack(child: child);
    });
    overlay.insert(entry);
    _current = entry;
    Future.delayed(duration, () {
      if (_current == entry) {
        entry.remove();
        _current = null;
      }
    });
  }
}

class _TopSnack extends StatefulWidget {
  final Widget child;
  const _TopSnack({Key? key, required this.child}) : super(key: key);

  @override
  State<_TopSnack> createState() => _TopSnackState();
}

class _TopSnackState extends State<_TopSnack> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    _anim = Tween(begin: const Offset(0, -1.0), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 8.0;
    return Positioned(
      left: 12,
      right: 12,
      top: top,
      child: SlideTransition(
        position: _anim,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), child: widget.child),
        ),
      ),
    );
  }
}
