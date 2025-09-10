import 'package:flutter/material.dart';
import 'onboarding_welcome.dart';
import 'onboarding_features.dart';
import 'onboarding_create_node.dart';
import 'onboarding_finish.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:ecoblock_mobile/shared/widgets.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _index = 0;
  final GlobalKey _createKey = GlobalKey();
  late final AnimationController _pulseController;
  bool _canProceed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _pulseController.reverse();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < 3) {
      _index += 1;
      _controller.animateToPage(_index, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
      setState(() {});
    }
  }

  void _back() {
    if (_index > 0) {
      _index -= 1;
      _controller.animateToPage(_index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: EcoPageBackground(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OnboardingWelcome(onNext: _next),
                OnboardingFeatures(onNext: _next, onBack: _back),
                OnboardingCreateNode(
                  key: _createKey,
                  onNext: _next,
                  onBack: _back,
                  onCreated: () {
                    if (!mounted) return;
                    setState(() {
                      _canProceed = true;
                    });
                    _pulseController.forward(from: 0.0);
                  },
                ),
                OnboardingFinish(onBack: _back),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: _index == i ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _index == i ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          child: _buildPrimaryButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    final label = () {
      switch (_index) {
        case 0:
          return 'Commencer';
        case 1:
          return 'Suivant';
        case 2:
          return 'Créer mon nœud';
        case 3:
        default:
          return 'Terminer';
      }
    }();

    final bool isLoading = _index == 2 && _createKey.currentState != null && ((_createKey.currentState as dynamic).isLoading == true);
    final bool isCreated = _index == 2 && _createKey.currentState != null && ((_createKey.currentState as dynamic).isCreated == true);

    if (isCreated && !_canProceed) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _canProceed = true;
        });
        _pulseController.forward(from: 0.0);
      });
    }

    if (_index == 2) {
      final labelText = isLoading ? 'Créer mon nœud' : (isCreated ? 'Suivant' : 'Créer mon nœud');
      final bool enabled = !isLoading && (isCreated ? _canProceed : false);
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final glow = (_pulseController.value * 0.35);
          return Container(
            decoration: enabled
                ? BoxDecoration(boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.18 + glow), blurRadius: 20, spreadRadius: 1)])
                : null,
            child: EcoPrimaryButton(
              onPressed: enabled
                  ? () {
                      _next();
                    }
                  : (isLoading
                      ? null
                      : () async {
                          if (_createKey.currentState != null) {
                            await (_createKey.currentState as dynamic).triggerAssociate();
                          }
                        }),
              loading: isLoading,
              child: Text(labelText),
            ),
          );
        },
      );
    }

    return EcoPrimaryButton(
      onPressed: isLoading
          ? null
          : () async {
              if (_index == 0) {
                _next();
              } else if (_index == 1) {
                _next();
              } else if (_index == 3) {
                Navigator.of(context).pushReplacementNamed('/app');
              }
            },
      loading: isLoading,
      child: Text(label),
    );
  }
}
