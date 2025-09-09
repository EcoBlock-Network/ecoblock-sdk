import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsProvider);
    final selectedLanguage = ref.watch(languageProvider);
    final themeMode = ref.watch(themeProvider);
    final dataSaverEnabled = ref.watch(dataSaverProvider);

    return Scaffold(
      body: EcoPageBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(tr(context, 'settings.title'), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              _SectionTitle(tr(context, 'settings.display')),
          SettingsTile(
            icon: Icons.brightness_6,
            title: tr(context, 'settings.theme'),
            subtitle: _themeLabel(themeMode),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
                items: [
                DropdownMenuItem(value: ThemeMode.light, child: Text(tr(context, 'theme.light'))),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(tr(context, 'theme.dark'))),
                DropdownMenuItem(value: ThemeMode.system, child: Text(tr(context, 'theme.system'))),
              ],
              onChanged: (mode) {
                if (mode != null) ref.read(themeProvider.notifier).setTheme(mode);
              },
            ),
          ),
          SettingsTile(
            icon: Icons.language,
            title: tr(context, 'settings.language'),
            subtitle: _languageLabel(selectedLanguage),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
                items: [
                DropdownMenuItem(value: 'fr', child: Text(tr(context, 'lang.fr'))),
                DropdownMenuItem(value: 'en', child: Text(tr(context, 'lang.en'))),
                DropdownMenuItem(value: 'es', child: Text(tr(context, 'lang.es'))),
              ],
              onChanged: (lang) {
                if (lang != null) ref.read(languageProvider.notifier).setLanguage(lang);
              },
            ),
          ),
          _SectionTitle(tr(context, 'settings.notifications')),
          SettingsTile(
            icon: Icons.notifications,
            title: tr(context, 'settings.notifications'),
            subtitle: notificationsEnabled ? tr(context, 'enabled') : tr(context, 'disabled'),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (_) => ref.read(notificationsProvider.notifier).toggle(),
            ),
          ),
          _SectionTitle(tr(context, 'settings.data_saver')),
          SettingsTile(
            icon: Icons.data_saver_on,
            title: tr(context, 'settings.data_saver'),
            subtitle: dataSaverEnabled ? tr(context, 'enabled') : tr(context, 'disabled'),
            trailing: Switch(
              value: dataSaverEnabled,
              onChanged: (_) => ref.read(dataSaverProvider.notifier).toggle(),
            ),
          ),
          _SectionTitle(tr(context, 'settings.privacy')),
          SettingsTile(
            icon: Icons.delete_forever,
            title: tr(context, 'settings.erase_local_data'),
            subtitle: tr(context, 'settings.erase_local_data_sub'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmErase(context),
            ),
          ),
          SettingsTile(
            icon: Icons.restart_alt,
            title: tr(context, 'settings.reset_settings'),
            subtitle: tr(context, 'settings.reset_settings'),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _confirmReset(context, ref),
            ),
          ),
          _SectionTitle(tr(context, 'settings.about')),
          SettingsTile(
            icon: Icons.info_outline,
            title: tr(context, 'settings.about.version'),
            subtitle: '1.0.0',
            trailing: const SizedBox.shrink(),
          ),
          SettingsTile(
            icon: Icons.article,
            title: tr(context, 'settings.legal'),
            subtitle: tr(context, 'settings.legal_action'),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
    ),
      ),
    );
  }

  static String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Système';
    }
  }

  static String _languageLabel(String lang) {
    switch (lang) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'Anglais';
      case 'es':
        return 'Espagnol';
      default:
        return lang;
    }
  }

  void _confirmErase(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr(context, 'settings.erase_local_data')),
        content: Text(tr(context, 'settings.erase_local_data_sub')),
        actions: [
          TextButton(
            child: Text(tr(context, 'confirm.cancel')),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text(tr(context, 'confirm.erase')),
            onPressed: () {

              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr(context, 'settings.reset_settings')),
        content: Text(tr(context, 'settings.reset_settings')),
        actions: [
          TextButton(
            child: Text(tr(context, 'confirm.cancel')),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text(tr(context, 'confirm.reset')),
            onPressed: () {
              final notif = ref.read(notificationsProvider.notifier);
              final lang = ref.read(languageProvider.notifier);
              final theme = ref.read(themeProvider.notifier);
              final dataSaver = ref.read(dataSaverProvider.notifier);
              if (!ref.read(notificationsProvider)) notif.toggle();
              lang.setLanguage('fr');
              theme.setTheme(ThemeMode.system);
              if (ref.read(dataSaverProvider)) dataSaver.toggle();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

// Providers for each setting
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) => NotificationsNotifier());
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) => LanguageNotifier());
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
final dataSaverProvider = StateNotifierProvider<DataSaverNotifier, bool>((ref) => DataSaverNotifier());

class NotificationsNotifier extends StateNotifier<bool> {
  NotificationsNotifier() : super(true);
  void toggle() => state = !state;
}

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('fr');
  void setLanguage(String lang) => state = lang;
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);
  void setTheme(ThemeMode mode) => state = mode;
}

class DataSaverNotifier extends StateNotifier<bool> {
  DataSaverNotifier() : super(false);
  void toggle() => state = !state;
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }
}
