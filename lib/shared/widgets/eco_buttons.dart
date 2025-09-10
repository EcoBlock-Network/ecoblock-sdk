import 'package:flutter/material.dart';
class EcoPrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool loading;
  final double height;

  const EcoPrimaryButton({super.key, required this.child, this.onPressed, this.loading = false, this.height = 52});

  @override
  State<EcoPrimaryButton> createState() => _EcoPrimaryButtonState();
}

class _EcoPrimaryButtonState extends State<EcoPrimaryButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
  _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    if (_isActive) {
      _controller.repeat(reverse: true);
    }
  }

  bool get _isActive => widget.onPressed != null && !widget.loading;

  @override
  void didUpdateWidget(covariant EcoPrimaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!_isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final raw = Curves.easeInOut.transform(_controller.value);
  final offset = (raw - 0.5) * 0.4;
        final begin = Alignment(-0.3 + offset, -0.3);
        final end = Alignment(0.3 + offset, 0.3);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.primaryContainer],
                  begin: begin,
                  end: end,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: scheme.primary.withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 6)),
                ],
              ),
              child: Center(
                child: widget.loading
                    ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: scheme.onPrimary, strokeWidth: 2))
                    : DefaultTextStyle(style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w600), child: widget.child),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EcoGhostButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;

  const EcoGhostButton({super.key, required this.child, this.onPressed, this.height = 48});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
          ),
          child: Center(child: DefaultTextStyle(style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600), child: child)),
        ),
      ),
    );
  }
}
