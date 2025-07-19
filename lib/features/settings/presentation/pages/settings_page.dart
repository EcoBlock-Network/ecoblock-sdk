import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsProvider);
    final selectedLanguage = ref.watch(languageProvider);
    final themeMode = ref.watch(themeProvider);
    final dataSaverEnabled = ref.watch(dataSaverProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        children: [
          const _SectionTitle('Affichage'),
          SettingsTile(
            icon: Icons.brightness_6,
            title: 'Thème',
            subtitle: _themeLabel(themeMode),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Clair')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Sombre')),
                DropdownMenuItem(value: ThemeMode.system, child: Text('Système')),
              ],
              onChanged: (mode) {
                if (mode != null) ref.read(themeProvider.notifier).setTheme(mode);
              },
            ),
          ),
          SettingsTile(
            icon: Icons.language,
            title: 'Langue',
            subtitle: _languageLabel(selectedLanguage),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'en', child: Text('Anglais')),
                DropdownMenuItem(value: 'es', child: Text('Espagnol')),
              ],
              onChanged: (lang) {
                if (lang != null) ref.read(languageProvider.notifier).setLanguage(lang);
              },
            ),
          ),
          const _SectionTitle('Notifications'),
          SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications push',
            subtitle: notificationsEnabled ? 'Activées' : 'Désactivées',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (_) => ref.read(notificationsProvider.notifier).toggle(),
            ),
          ),
          const _SectionTitle('Qualité des médias'),
          SettingsTile(
            icon: Icons.data_saver_on,
            title: 'Économie de données',
            subtitle: dataSaverEnabled ? 'Activée' : 'Désactivée',
            trailing: Switch(
              value: dataSaverEnabled,
              onChanged: (_) => ref.read(dataSaverProvider.notifier).toggle(),
            ),
          ),
          const _SectionTitle('Confidentialité'),
          SettingsTile(
            icon: Icons.delete_forever,
            title: 'Effacer les données locales',
            subtitle: 'Supprime toutes les données stockées sur l’appareil',
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmErase(context),
            ),
          ),
          SettingsTile(
            icon: Icons.restart_alt,
            title: 'Réinitialiser les réglages',
            subtitle: 'Remettre tous les paramètres à zéro',
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _confirmReset(context, ref),
            ),
          ),
          const _SectionTitle('À propos'),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'Version de l’application',
            subtitle: '1.0.0',
            trailing: const SizedBox.shrink(),
          ),
          SettingsTile(
            icon: Icons.article,
            title: 'Mentions légales / CGU',
            subtitle: 'Consulter les conditions d’utilisation',
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                // TODO: Ouvrir la page CGU
              },
            ),
          ),
        ],
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
        title: const Text('Effacer les données locales'),
        content: const Text('Cette action est irréversible. Voulez-vous continuer ?'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Effacer'),
            onPressed: () {
              // TODO: Effacer les données locales (mock)
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
        title: const Text('Réinitialiser les réglages'),
        content: const Text('Tous les paramètres seront remis à zéro. Voulez-vous continuer ?'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Réinitialiser'),
            onPressed: () {
              // Reset using public methods
              final notif = ref.read(notificationsProvider.notifier);
              final lang = ref.read(languageProvider.notifier);
              final theme = ref.read(themeProvider.notifier);
              final dataSaver = ref.read(dataSaverProvider.notifier);
              if (!ref.read(notificationsProvider)) notif.toggle(); // set to true
              lang.setLanguage('fr');
              theme.setTheme(ThemeMode.system);
              if (ref.read(dataSaverProvider)) dataSaver.toggle(); // set to false
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
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  }) : super(key: key);

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
