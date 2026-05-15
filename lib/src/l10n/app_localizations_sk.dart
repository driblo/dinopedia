// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Dinopédia';

  @override
  String get splashSlogan => 'Spoznaj obrov dávnej minulosti.';

  @override
  String get navCatalog => 'Katalóg';

  @override
  String get navQuiz => 'Kvíz';

  @override
  String get navSettings => 'Nastavenia';

  @override
  String get catalogTitle => 'Dinosaury';

  @override
  String get catalogSearchHint => 'Hľadať dinosaury…';

  @override
  String get catalogFilterAll => 'Všetky';

  @override
  String get detailDiet => 'Strava';

  @override
  String get detailPeriod => 'Obdobie';

  @override
  String get detailClade => 'Klad';

  @override
  String get detailLength => 'Dĺžka';

  @override
  String get detailWeight => 'Hmotnosť';

  @override
  String get detailWikipediaSource => 'Čítaj viac na Wikipédii';

  @override
  String get detailLoadingWiki => 'Načítavam detaily…';

  @override
  String get detailWikiAttribution => 'Text z Wikipédie, licencia CC BY-SA';

  @override
  String get quizTitle => 'Dino kvíz';

  @override
  String get quizStart => 'Spustiť kvíz';

  @override
  String get quizRestart => 'Hrať znova';

  @override
  String quizQuestion(int number, int total) {
    return 'Otázka $number z $total';
  }

  @override
  String quizTier(int tier) {
    return 'Úroveň $tier';
  }

  @override
  String get quizCorrect => 'Správne!';

  @override
  String get quizWrong => 'Nie celkom…';

  @override
  String get quizGameOver => 'Koniec hry';

  @override
  String get quizWin => 'Si dino expert!';

  @override
  String quizScoreLabel(int score) {
    return 'Skóre: $score';
  }

  @override
  String get quizLifelineFiftyFifty => '50/50';

  @override
  String get quizLifelineAudience => 'Opýtaj sa svorky';

  @override
  String get quizLifelineSkip => 'Preskočiť';

  @override
  String get quizCheckpointReached => 'Kontrolný bod uložený!';

  @override
  String get quizNeedsInternet =>
      'Kvíz vyžaduje internetové pripojenie pre obrázky.';

  @override
  String get quizOfflineHint =>
      'Prehliadaj katalóg offline — postup je uložený.';

  @override
  String get settingsTitle => 'Nastavenia';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsSoundEnabled => 'Zvukové efekty';

  @override
  String get settingsSupportUs => 'Podporte nás';

  @override
  String get settingsLicenses => 'Open-source licencie';

  @override
  String settingsAppVersion(String version) {
    return 'Verzia $version';
  }

  @override
  String get errorNoInternet => 'Žiadne internetové pripojenie';

  @override
  String get errorRetry => 'Skúsiť znova';

  @override
  String get errorGeneric => 'Niečo sa pokazilo';

  @override
  String get dietCarnivore => 'Mäsožravec';

  @override
  String get dietHerbivore => 'Bylinožravec';

  @override
  String get dietOmnivore => 'Všežravec';

  @override
  String get settingsSystemDefault => 'Systémový jazyk';

  @override
  String get detailWikiUnavailable => 'Detaily z Wikipédie sa nepodarilo načítať.';

  @override
  String get quizContinueCheckpoint => 'Pokračovať z kontrolného bodu';

  @override
  String get quizHighScore => 'Najlepšie skóre';
}
