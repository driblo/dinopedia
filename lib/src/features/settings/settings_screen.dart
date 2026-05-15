import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_ext.dart';
import 'language_picker.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final soundOn = ref.watch(soundEnabledProvider);
    final localeOverride = ref.watch(localeOverrideProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(
              localeOverride?.languageCode ?? l10n.settingsSystemDefault,
            ),
            onTap: () => showLanguagePicker(context, ref),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: Text(l10n.settingsSoundEnabled),
            value: soundOn,
            onChanged: (v) =>
                ref.read(soundEnabledProvider.notifier).set(v),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.settingsSupportUs),
            subtitle: Text(l10n.supportUrl),
            onTap: () => _shareSupportLink(context, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsLicenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareSupportLink(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await Clipboard.setData(ClipboardData(text: l10n.supportUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.supportUrl),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
