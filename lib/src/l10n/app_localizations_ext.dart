import 'app_localizations.dart';

/// Strings introduced after the initial scaffold, kept here so that the
/// generated `app_localizations_*.dart` files don't need hand-edits and stay
/// regenerable. Translations land during M6.
extension AppLocalizationsExt on AppLocalizations {
  String get settingsSystemDefault {
    switch (localeName) {
      case 'sk':
        return 'Systémový jazyk';
      case 'cs':
        return 'Systémový jazyk';
      default:
        return 'System default';
    }
  }

  String get detailWikiUnavailable {
    switch (localeName) {
      case 'sk':
        return 'Detaily z Wikipédie sa nepodarilo načítať.';
      case 'cs':
        return 'Nepodařilo se načíst detaily z Wikipedie.';
      default:
        return "Couldn't load Wikipedia details.";
    }
  }

  String get quizContinueCheckpoint {
    switch (localeName) {
      case 'sk':
        return 'Pokračovať z kontrolného bodu';
      case 'cs':
        return 'Pokračovat z kontrolního bodu';
      default:
        return 'Continue from checkpoint';
    }
  }

  String get quizHighScore {
    switch (localeName) {
      case 'sk':
        return 'Najlepšie skóre';
      case 'cs':
        return 'Nejlepší skóre';
      default:
        return 'Best score';
    }
  }

  String get supportUrl => 'https://ko-fi.com/dinopedia';
}
