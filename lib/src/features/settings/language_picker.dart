import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_ext.dart';

/// Display names for the locales we ship — shown in the language picker so a
/// user can find their language even if the rest of the UI is in another one.
const Map<String, String> _localeNativeNames = {
  'ar': 'العربية',
  'bg': 'Български',
  'cs': 'Čeština',
  'de': 'Deutsch',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'hi': 'हिन्दी',
  'hr': 'Hrvatski',
  'hu': 'Magyar',
  'id': 'Bahasa Indonesia',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'nl': 'Nederlands',
  'pl': 'Polski',
  'pt': 'Português',
  'ro': 'Română',
  'ru': 'Русский',
  'sk': 'Slovenčina',
  'th': 'ไทย',
  'tr': 'Türkçe',
  'uk': 'Українська',
  'vi': 'Tiếng Việt',
  'zh': '中文',
};

Future<void> showLanguagePicker(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final current = ref.read(localeOverrideProvider);
  final supported = AppLocalizations.supportedLocales
      .map((l) => l.languageCode)
      .toSet()
      .toList()
    ..sort();

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Text(l10n.settingsLanguage),
        children: [
          RadioListTile<String?>(
            value: null,
            // ignore: deprecated_member_use
            groupValue: current?.languageCode,
            // ignore: deprecated_member_use
            onChanged: (_) {
              ref.read(localeOverrideProvider.notifier).set(null);
              Navigator.of(ctx).pop();
            },
            title: Text(l10n.settingsSystemDefault),
          ),
          for (final code in supported)
            RadioListTile<String?>(
              value: code,
              // ignore: deprecated_member_use
              groupValue: current?.languageCode,
              // ignore: deprecated_member_use
              onChanged: (_) {
                ref.read(localeOverrideProvider.notifier).set(Locale(code));
                Navigator.of(ctx).pop();
              },
              title: Text(_localeNativeNames[code] ?? code),
              subtitle: Text(code),
            ),
        ],
      );
    },
  );
}
