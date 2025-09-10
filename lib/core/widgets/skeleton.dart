import 'package:flutter/material.dart';

/// Lightweight shimmer-like skeleton box used for placeholders.
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  const SkeletonBox({this.width, this.height, this.borderRadius, super.key});

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.12);
    final highlight = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.18);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = (_ctrl.value * 2) - 1;
        final dx = (t * 0.6) * (widget.width ?? MediaQuery.of(context).size.width);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            color: base,
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Positioned.fill(
                  left: dx,
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1 - t, 0),
                          end: Alignment(1 - t, 0),
                          colors: [Colors.transparent, highlight.withOpacity(0.9), Colors.transparent],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
