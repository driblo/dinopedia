import 'app_localizations.dart';

/// Non-translatable URL constants that live next to the localisation layer
/// because the rest of the strings flow through it. The translatable strings
/// introduced after the initial scaffold (settingsSystemDefault,
/// detailWikiUnavailable, quizContinueCheckpoint, quizHighScore) were folded
/// into the ARB + generated files during M6.
extension AppLocalizationsExt on AppLocalizations {
  String get supportUrl => 'https://ko-fi.com/dinopedia';
}
