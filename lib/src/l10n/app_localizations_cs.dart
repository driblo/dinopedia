// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Dinopédie';

  @override
  String get splashSlogan => 'Poznej obry dávné minulosti.';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navQuiz => 'Kvíz';

  @override
  String get navSettings => 'Nastavení';

  @override
  String get catalogTitle => 'Dinosauři';

  @override
  String get catalogSearchHint => 'Hledat dinosaury…';

  @override
  String get catalogFilterAll => 'Vše';

  @override
  String get detailDiet => 'Strava';

  @override
  String get detailPeriod => 'Období';

  @override
  String get detailClade => 'Klad';

  @override
  String get detailLength => 'Délka';

  @override
  String get detailWeight => 'Hmotnost';

  @override
  String get detailWikipediaSource => 'Číst více na Wikipedii';

  @override
  String get detailLoadingWiki => 'Načítávám detaily…';

  @override
  String get detailWikiAttribution => 'Text z Wikipedie, licence CC BY-SA';

  @override
  String get quizTitle => 'Dino kvíz';

  @override
  String get quizStart => 'Spustit kvíz';

  @override
  String get quizRestart => 'Hrát znovu';

  @override
  String quizQuestion(int number, int total) {
    return 'Otázka $number z $total';
  }

  @override
  String quizTier(int tier) {
    return 'Úroveň $tier';
  }

  @override
  String get quizCorrect => 'Správně!';

  @override
  String get quizWrong => 'Tak úplně ne…';

  @override
  String get quizGameOver => 'Konec hry';

  @override
  String get quizWin => 'Jsi dino expert!';

  @override
  String quizScoreLabel(int score) {
    return 'Skóre: $score';
  }

  @override
  String get quizLifelineFiftyFifty => '50/50';

  @override
  String get quizLifelineAudience => 'Zeptej se smečky';

  @override
  String get quizLifelineSkip => 'Přeskočit';

  @override
  String get quizCheckpointReached => 'Kontrolní bod uložen!';

  @override
  String get quizNeedsInternet =>
      'Kvíz vyžaduje připojení k internetu pro obrázky.';

  @override
  String get quizOfflineHint => 'Prohlíží katalog offline — postup je uložen.';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsSoundEnabled => 'Zvukové efekty';

  @override
  String get settingsSupportUs => 'Podpořte nás';

  @override
  String get settingsLicenses => 'Open-source licence';

  @override
  String settingsAppVersion(String version) {
    return 'Verze $version';
  }

  @override
  String get errorNoInternet => 'Žádné připojení k internetu';

  @override
  String get errorRetry => 'Zkusit znovu';

  @override
  String get errorGeneric => 'Něco se pokazilo';

  @override
  String get dietCarnivore => 'Masožravec';

  @override
  String get dietHerbivore => 'Bylinožravec';

  @override
  String get dietOmnivore => 'Všežravec';
}
