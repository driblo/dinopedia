// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Dinopedia';

  @override
  String get splashSlogan => 'Meet the giants of long ago.';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get navSettings => 'Settings';

  @override
  String get catalogTitle => 'Dinosaurs';

  @override
  String get catalogSearchHint => 'Search dinosaursâ€¦';

  @override
  String get catalogFilterAll => 'All';

  @override
  String get detailDiet => 'Diet';

  @override
  String get detailPeriod => 'Period';

  @override
  String get detailClade => 'Clade';

  @override
  String get detailLength => 'Length';

  @override
  String get detailWeight => 'Weight';

  @override
  String get detailWikipediaSource => 'Read more on Wikipedia';

  @override
  String get detailLoadingWiki => 'Loading detailsâ€¦';

  @override
  String get detailWikiAttribution => 'Text from Wikipedia, licensed CC BY-SA';

  @override
  String get quizTitle => 'Dino Quiz';

  @override
  String get quizStart => 'Start Quiz';

  @override
  String get quizRestart => 'Play Again';

  @override
  String quizQuestion(int number, int total) {
    return 'Question $number of $total';
  }

  @override
  String quizTier(int tier) {
    return 'Tier $tier';
  }

  @override
  String get quizCorrect => 'Correct!';

  @override
  String get quizWrong => 'Not quiteâ€¦';

  @override
  String get quizGameOver => 'Game Over';

  @override
  String get quizWin => 'You\'re a Dino Expert!';

  @override
  String quizScoreLabel(int score) {
    return 'Score: $score';
  }

  @override
  String get quizLifelineFiftyFifty => '50/50';

  @override
  String get quizLifelineAudience => 'Ask the Pack';

  @override
  String get quizLifelineSkip => 'Skip';

  @override
  String get quizCheckpointReached => 'Checkpoint saved!';

  @override
  String get quizNeedsInternet =>
      'Quiz needs an internet connection for images.';

  @override
  String get quizOfflineHint =>
      'Browse the catalog while offline â€” your progress is saved.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSoundEnabled => 'Sound effects';

  @override
  String get settingsSupportUs => 'Support our work';

  @override
  String get settingsLicenses => 'Open-source licenses';

  @override
  String settingsAppVersion(String version) {
    return 'Version $version';
  }

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorRetry => 'Retry';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get dietCarnivore => 'Carnivore';

  @override
  String get dietHerbivore => 'Herbivore';

  @override
  String get dietOmnivore => 'Omnivore';
}
