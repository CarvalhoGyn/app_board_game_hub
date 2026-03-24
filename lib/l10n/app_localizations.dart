import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your board game journey'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @registerText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get registerText;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @collectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collectionTitle;

  /// No description provided for @matchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matchesTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @trendingGames.
  ///
  /// In en, this message translates to:
  /// **'Trending Games'**
  String get trendingGames;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noTrendingGames.
  ///
  /// In en, this message translates to:
  /// **'No Trends Yet'**
  String get noTrendingGames;

  /// No description provided for @noTrendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play matches to see what\'s hot among your group.'**
  String get noTrendingSubtitle;

  /// No description provided for @startMatch.
  ///
  /// In en, this message translates to:
  /// **'Start Match'**
  String get startMatch;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// No description provided for @needMoreData.
  ///
  /// In en, this message translates to:
  /// **'Need More Data'**
  String get needMoreData;

  /// No description provided for @needMoreDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play and rate games to get personalized picks.'**
  String get needMoreDataSubtitle;

  /// No description provided for @exploreGamesButton.
  ///
  /// In en, this message translates to:
  /// **'Explore Games'**
  String get exploreGamesButton;

  /// No description provided for @playersCount.
  ///
  /// In en, this message translates to:
  /// **'{min}-{max} players'**
  String playersCount(Object max, Object min);

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'(Rank #{rank})'**
  String rankLabel(Object rank);

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Games'**
  String get exploreTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for board games...'**
  String get searchPlaceholder;

  /// No description provided for @emptySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search for your favorite games'**
  String get emptySearchTitle;

  /// No description provided for @emptySearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type a game name to start exploring'**
  String get emptySearchSubtitle;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No games found'**
  String get noResults;

  /// No description provided for @noResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get noResultsSubtitle;

  /// No description provided for @enrichDatabase.
  ///
  /// In en, this message translates to:
  /// **'Enrich Database'**
  String get enrichDatabase;

  /// No description provided for @enrichConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will fetch details for ALL games from BoardGameGeek. This may take a long time.\n\nContinue?'**
  String get enrichConfirmation;

  /// No description provided for @newMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'New Match'**
  String get newMatchTitle;

  /// No description provided for @selectGameLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a Game'**
  String get selectGameLabel;

  /// No description provided for @gameLabel.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameLabel;

  /// No description provided for @scoringMode.
  ///
  /// In en, this message translates to:
  /// **'Scoring Mode'**
  String get scoringMode;

  /// No description provided for @competitive.
  ///
  /// In en, this message translates to:
  /// **'Competitive'**
  String get competitive;

  /// No description provided for @cooperative.
  ///
  /// In en, this message translates to:
  /// **'Cooperative'**
  String get cooperative;

  /// No description provided for @whoIsPlaying.
  ///
  /// In en, this message translates to:
  /// **'Who\'s playing?'**
  String get whoIsPlaying;

  /// No description provided for @whoStarts.
  ///
  /// In en, this message translates to:
  /// **'Who starts?'**
  String get whoStarts;

  /// No description provided for @diceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t argue, let the dice decide your fate.'**
  String get diceSubtitle;

  /// No description provided for @rollButton.
  ///
  /// In en, this message translates to:
  /// **'ROLL'**
  String get rollButton;

  /// No description provided for @pickRandomPlayer.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick a random player'**
  String get pickRandomPlayer;

  /// No description provided for @diceRolled.
  ///
  /// In en, this message translates to:
  /// **'Dice Rolled! 🎲'**
  String get diceRolled;

  /// No description provided for @startingPlayerIs.
  ///
  /// In en, this message translates to:
  /// **'The starting player is:'**
  String get startingPlayerIs;

  /// No description provided for @addPlayersWarning.
  ///
  /// In en, this message translates to:
  /// **'Add players first!'**
  String get addPlayersWarning;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSent;

  /// No description provided for @friendsButton.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsButton;

  /// No description provided for @winsLabel.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get winsLabel;

  /// No description provided for @winRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRateLabel;

  /// No description provided for @achievementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsLabel;

  /// No description provided for @badgesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Badges and milestones'**
  String get badgesSubtitle;

  /// No description provided for @myCollection.
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get myCollection;

  /// No description provided for @gamesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} games'**
  String gamesCount(Object count);

  /// No description provided for @matchHistory.
  ///
  /// In en, this message translates to:
  /// **'Game History'**
  String get matchHistory;

  /// No description provided for @matchesPlayed.
  ///
  /// In en, this message translates to:
  /// **'{count} matches played'**
  String matchesPlayed(Object count);

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String levelLabel(Object level);

  /// No description provided for @xpLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} XP'**
  String xpLabel(Object current, Object total);

  /// No description provided for @prestigeReset.
  ///
  /// In en, this message translates to:
  /// **'PRESTIGE RESET'**
  String get prestigeReset;

  /// No description provided for @prestigeAscension.
  ///
  /// In en, this message translates to:
  /// **'🌟 Prestige Ascension 🌟'**
  String get prestigeAscension;

  /// No description provided for @prestigeWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This will RESET your level to 1, but you will gain a PRESTIGE STAR and eternal glory.'**
  String get prestigeWarning;

  /// No description provided for @ascendButton.
  ///
  /// In en, this message translates to:
  /// **'ASCEND'**
  String get ascendButton;

  /// No description provided for @historyYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get historyYear;

  /// No description provided for @historyMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get historyMonth;

  /// No description provided for @historyNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches found for this filter.'**
  String get historyNoMatches;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
