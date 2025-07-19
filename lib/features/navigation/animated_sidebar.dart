import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedSidebar extends StatefulWidget {
  final Widget child;
  final VoidCallback onToggle;
  final void Function(String label)? onMenuSelected;

  const AnimatedSidebar({
    Key? key,
    required this.child,
    required this.onToggle,
    this.onMenuSelected,
  }) : super(key: key);

  @override
  AnimatedSidebarState createState() => AnimatedSidebarState();
}

class AnimatedSidebarState extends State<AnimatedSidebar> {
  bool _isMini = false;

  void toggle() {
    setState(() {
      _isMini = !_isMini;
    });
    widget.onToggle();
  }

  static const double _miniSize = 56;
  static const double _fullWidth = 280;
  static const double _radius = 32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = _isMini ? _miniSize : _fullWidth;
    final radius = _isMini ? _miniSize / 2 : _radius;

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primaryContainer.withOpacity(0.35),
                        scheme.secondaryContainer.withOpacity(0.30),
                        scheme.tertiaryContainer.withOpacity(0.25),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border(
                      right: BorderSide(
                        color: scheme.outline.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.tertiary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: Offset(4, 0),
                      ),
                    ],
                  ),
                  child: _isMini ? _buildMini(scheme) : _buildFull(context, theme),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMini(ColorScheme scheme) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.menu, size: 28),
        color: scheme.onPrimary,
            onPressed: () {
              debugPrint('[Sidebar] Mini menu opened');
              toggle();
        },
      ),
    );
  }

  Widget _buildFull(BuildContext context, ThemeData theme) {
    final scheme = theme.colorScheme;
    final totalExp = 3200;
    final nextLevelExp = 5000;
    final progress = totalExp / nextLevelExp;
    final level = 5;

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(seconds: 1),
                        builder: (_, value, __) => CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          backgroundColor: scheme.onSurface.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation(scheme.primary),
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Niveau $level',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalExp XP',
                  style: TextStyle(
                    color: scheme.onPrimary.withOpacity(0.75),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, size: 26),
              color: scheme.onPrimary,
              onPressed: toggle,
            ),
          ),
          const SizedBox(height: 8),
          ..._navItems(context, scheme),
          const Spacer(),
          _navItem(
            icon: Icons.logout,
            label: 'Déconnexion',
          onTap: toggle,
            textColor: scheme.error,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _navItems(BuildContext context, ColorScheme scheme) {
    final items = <_NavData>[
      _NavData(Icons.dashboard, 'Accueil'),
      _NavData(Icons.radar, 'Scan Mesh', trailing: _BleGauge(scheme)),
      _NavData(Icons.account_circle, 'Profil'),
      _NavData(Icons.groups, 'Communauté'),
      _NavData(Icons.message, 'Messagerie'),
      _NavData(Icons.settings, 'Paramètres'),
      _NavData(Icons.help_outline, 'Aide'),
    ];
    return items
        .map((data) => _navItem(
              icon: data.icon,
              label: data.label,
              trailing: data.trailing,
              onTap: () {
                debugPrint('[Sidebar] Menu tap: ${data.label}');
                if (widget.onMenuSelected != null) widget.onMenuSelected!(data.label);
              },
              textColor: scheme.onSurface.withOpacity(0.85),
            ))
        .toList();
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Widget? trailing,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () {
          debugPrint('[Sidebar] InkWell tap: $label');
          if (onTap != null) onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontFamily: 'Merriweather',
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

class _NavData {
  final IconData icon;
  final String label;
  final Widget? trailing;
  const _NavData(this.icon, this.label, {this.trailing});
}

class _BleGauge extends StatelessWidget {
  final ColorScheme scheme;
  const _BleGauge(this.scheme, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 0.6,
            strokeWidth: 3,
            backgroundColor: scheme.onSurface.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(scheme.primary),
          ),
          Icon(Icons.bluetooth, size: 12, color: scheme.onSurface.withOpacity(0.8)),
        ],
      ),
    );
  }
}