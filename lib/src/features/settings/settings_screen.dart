import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.volume_up_outlined),
            title: Text(l10n.settingsSoundEnabled),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.settingsSupportUs),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsLicenses),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}
