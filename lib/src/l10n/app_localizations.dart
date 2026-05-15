import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Application name shown in app bar
  ///
  /// In en, this message translates to:
  /// **'Dinopedia'**
  String get appTitle;

  /// Slogan displayed on the splash screen
  ///
  /// In en, this message translates to:
  /// **'Meet the giants of long ago.'**
  String get splashSlogan;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get navQuiz;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Dinosaurs'**
  String get catalogTitle;

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search dinosaurs…'**
  String get catalogSearchHint;

  /// No description provided for @catalogFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catalogFilterAll;

  /// No description provided for @detailDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get detailDiet;

  /// No description provided for @detailPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get detailPeriod;

  /// No description provided for @detailClade.
  ///
  /// In en, this message translates to:
  /// **'Clade'**
  String get detailClade;

  /// No description provided for @detailLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get detailLength;

  /// No description provided for @detailWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get detailWeight;

  /// No description provided for @detailWikipediaSource.
  ///
  /// In en, this message translates to:
  /// **'Read more on Wikipedia'**
  String get detailWikipediaSource;

  /// No description provided for @detailLoadingWiki.
  ///
  /// In en, this message translates to:
  /// **'Loading details…'**
  String get detailLoadingWiki;

  /// No description provided for @detailWikiAttribution.
  ///
  /// In en, this message translates to:
  /// **'Text from Wikipedia, licensed CC BY-SA'**
  String get detailWikiAttribution;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Dino Quiz'**
  String get quizTitle;

  /// No description provided for @quizStart.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get quizStart;

  /// No description provided for @quizRestart.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get quizRestart;

  /// No description provided for @quizQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question {number} of {total}'**
  String quizQuestion(int number, int total);

  /// No description provided for @quizTier.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier}'**
  String quizTier(int tier);

  /// No description provided for @quizCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get quizCorrect;

  /// No description provided for @quizWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite…'**
  String get quizWrong;

  /// No description provided for @quizGameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get quizGameOver;

  /// No description provided for @quizWin.
  ///
  /// In en, this message translates to:
  /// **'You\'re a Dino Expert!'**
  String get quizWin;

  /// No description provided for @quizScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String quizScoreLabel(int score);

  /// No description provided for @quizLifelineFiftyFifty.
  ///
  /// In en, this message translates to:
  /// **'50/50'**
  String get quizLifelineFiftyFifty;

  /// No description provided for @quizLifelineAudience.
  ///
  /// In en, this message translates to:
  /// **'Ask the Pack'**
  String get quizLifelineAudience;

  /// No description provided for @quizLifelineSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get quizLifelineSkip;

  /// No description provided for @quizCheckpointReached.
  ///
  /// In en, this message translates to:
  /// **'Checkpoint saved!'**
  String get quizCheckpointReached;

  /// No description provided for @quizNeedsInternet.
  ///
  /// In en, this message translates to:
  /// **'Quiz needs an internet connection for images.'**
  String get quizNeedsInternet;

  /// No description provided for @quizOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Browse the catalog while offline — your progress is saved.'**
  String get quizOfflineHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSoundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSoundEnabled;

  /// No description provided for @settingsSupportUs.
  ///
  /// In en, this message translates to:
  /// **'Support our work'**
  String get settingsSupportUs;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAppVersion(String version);

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNoInternet;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetry;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @dietCarnivore.
  ///
  /// In en, this message translates to:
  /// **'Carnivore'**
  String get dietCarnivore;

  /// No description provided for @dietHerbivore.
  ///
  /// In en, this message translates to:
  /// **'Herbivore'**
  String get dietHerbivore;

  /// No description provided for @dietOmnivore.
  ///
  /// In en, this message translates to:
  /// **'Omnivore'**
  String get dietOmnivore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bg',
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
