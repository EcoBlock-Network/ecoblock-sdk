import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

class AppNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppNavBar({Key? key, required this.selectedIndex, required this.onTap}) : super(key: key);

  static const _navBarIcons = [
    Icons.dashboard_rounded,
    Icons.account_circle_rounded,
    Icons.message_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.only(left: 13, right: 13, bottom: 12 + bottomInset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 64 + bottomInset,
          child: LayoutBuilder(builder: (context, constraints) {
            final itemCount = _navBarIcons.length;
            final alignmentX = itemCount > 1 ? -1.0 + 2.0 * (selectedIndex / (itemCount - 1)) : 0.0;
            final pillWidthFactor = (1 / itemCount) * 0.98;

            final shouldBlur = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

            return Container(
              decoration: BoxDecoration(
                color: scheme.navBackgroundGlass,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: scheme.primary.withAlpha((0.08 * 255).toInt()), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withAlpha((0.10 * 255).toInt()),
                    blurRadius: 22,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (shouldBlur)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(color: Colors.transparent),
                      ),
                    ),

                  AnimatedAlign(
                    alignment: Alignment(alignmentX, 0),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: FractionallySizedBox(
                      widthFactor: pillWidthFactor,
                      heightFactor: 0.78,
                      child: Container(
                        // reduce outer margin so the pill visually spans the item area
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [scheme.primary.withOpacity(0.10), scheme.primaryContainer.withOpacity(0.18)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: scheme.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(itemCount, (i) {
                      final selected = i == selectedIndex;
                      return Flexible(
                        fit: FlexFit.tight,
                        child: _EcoNavBarItem(
                          icon: _navBarIcons[i],
                          label: i == 0
                              ? tr(context, 'nav.home')
                              : i == 1
                                  ? tr(context, 'nav.profile')
                                  : i == 2
                                      ? tr(context, 'nav.news')
                                      : tr(context, 'nav.settings'),
                          selected: selected,
                          onTap: () => onTap(i),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _EcoNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _EcoNavBarItem({required this.icon, required this.label, required this.selected, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: selected ? 8 : 12),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: selected ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: Icon(
                  icon,
                  size: selected ? 32 : 26,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : (selected ? scheme.primary : scheme.onSurface.withOpacity(0.5)),
                  shadows: selected ? [Shadow(color: scheme.primary.withOpacity(0.21), blurRadius: 8)] : [],
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: selected ? 13.7 : 11.7,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : (selected ? scheme.primary : scheme.onSurface.withOpacity(0.48)),
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  letterSpacing: selected ? 0.05 : 0.02,
                  shadows: selected ? [Shadow(color: scheme.primary.withOpacity(0.10), blurRadius: 5)] : [],
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1.0 : 0.0,
                  child: Text(label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
