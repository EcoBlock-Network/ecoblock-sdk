import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/controllers/onboarding_controller.dart';
import 'dart:async';
import 'dart:math';

class OnboardingCreateNode extends ConsumerStatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback? onCreated;

  const OnboardingCreateNode({super.key, this.onNext, this.onBack, this.onCreated});

  @override
  ConsumerState<OnboardingCreateNode> createState() => _OnboardingCreateNodeState();
}

class _OnboardingCreateNodeState extends ConsumerState<OnboardingCreateNode> {
  bool _loading = false;
  String? _error;
  Timer? _ticker;
  final _random = Random();

  // Visual generator targets
  String _target = 'ECONODE';
  List<String>? _chars;
  int _locked = 0; // how many chars from left are locked
  bool _created = false;
  int _progressVersion = 0;

  Future<void> _associate() async {
    // start visual generator
    _startGenerator();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final nodeId = await ref.read(onboardingControllerProvider.notifier).associateNode();
        if (nodeId != null && nodeId.isNotEmpty) {
          _progressVersion++;
          setState(() {
            _target = nodeId.toUpperCase();
            _chars = List<String>.filled(_target.length, '', growable: false);
            for (var i = 0; i < _chars!.length; i++) {
              _chars![i] = _randomChar();
            }
            _locked = 0;
          });
        }
        await _finishGenerator(_progressVersion);
      setState(() {
        _created = true;
      });
      try {
        widget.onCreated?.call();
      } catch (_) {}
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      _stopGenerator();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> triggerAssociate() async {
    await _associate();
  }

  bool get isCreated => _created;

  bool get isLoading => _loading;

  @override
  Widget build(BuildContext context) {
  _ensureCharsInitialized();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(tr(context, 'onboarding.join.title'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(tr(context, 'onboarding.join.subtitle'), style: const TextStyle(fontSize: 16, height: 1.4), textAlign: TextAlign.center),
            const SizedBox(height: 28),
            Semantics(
              label: 'Generator',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: (_chars ?? []).asMap().entries.map((e) {
                    final i = e.key;
                    final c = e.value;
                    final locked = i < _locked;
                    return AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: locked ? 20 : 18,
                        color: locked ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: locked ? FontWeight.w800 : FontWeight.w600,
                      ),
                      child: Text(c),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_loading) Text(tr(context, 'onboarding.join.cta'), style: const TextStyle(fontSize: 13)),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }

  void _ensureCharsInitialized() {
    if (_chars != null) return;
    _chars = List<String>.filled(_target.length, '', growable: false);
    for (var i = 0; i < _chars!.length; i++) {
      _chars![i] = _randomChar();
    }
  }

  String _randomChar() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return chars[_random.nextInt(chars.length)];
  }

  void _startGenerator() {
    _locked = 0;
    _progressVersion++;
    final v = _progressVersion;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (!mounted) return;
      setState(() {
        for (var i = _locked; i < (_chars?.length ?? 0); i++) {
          _chars![i] = _randomChar();
        }
      });
    });
    _progressLock(v);
  }
  Future<void> _progressLock(int version) async {
    while (_locked < (_chars?.length ?? 0)) {
      await Future.delayed(const Duration(milliseconds: 220));
      if (!mounted) return;
      if (version != _progressVersion) return;
      if (_locked >= (_target.length)) return;
      setState(() {
        if (_chars != null && _locked < _chars!.length && _locked < _target.length) {
          _chars![_locked] = _target[_locked];
          _locked += 1;
        }
      });
    }
  }
  Future<void> _finishGenerator(int version) async {
    while (_locked < (_chars?.length ?? 0)) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      if (version != _progressVersion) return;
      if (_locked >= _target.length) break;
      setState(() {
        if (_chars != null && _locked < _chars!.length && _locked < _target.length) {
          _chars![_locked] = _target[_locked];
          _locked += 1;
        }
      });
    }
    _stopGenerator();
    await Future.delayed(const Duration(milliseconds: 600));
  }

  void _stopGenerator() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
