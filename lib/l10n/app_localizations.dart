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

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get seeDetails;

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

  /// No description provided for @unlockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlockedLabel;

  /// No description provided for @lockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get lockedLabel;

  /// No description provided for @unlockedOnDate.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String unlockedOnDate(Object date);

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @myWishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get myWishlistTitle;

  /// No description provided for @emptyWishlist.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get emptyWishlist;

  /// No description provided for @exploreToAddToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Explore games to add them here'**
  String get exploreToAddToWishlist;

  /// No description provided for @removedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'{game} removed from wishlist'**
  String removedFromWishlist(Object game);

  /// No description provided for @emptyCollection.
  ///
  /// In en, this message translates to:
  /// **'Your collection is empty'**
  String get emptyCollection;

  /// No description provided for @exploreToAddToCollection.
  ///
  /// In en, this message translates to:
  /// **'Mark games as owned to see them here'**
  String get exploreToAddToCollection;

  /// No description provided for @removedFromCollection.
  ///
  /// In en, this message translates to:
  /// **'{game} removed from collection'**
  String removedFromCollection(Object game);

  /// No description provided for @myFriendsTab.
  ///
  /// In en, this message translates to:
  /// **'My Friends'**
  String get myFriendsTab;

  /// No description provided for @friendRequestsTab.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get friendRequestsTab;

  /// No description provided for @friendRequestsCount.
  ///
  /// In en, this message translates to:
  /// **'Requests ({count})'**
  String friendRequestsCount(Object count);

  /// No description provided for @acceptedFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Accepted friend request from {user} (+10 XP)'**
  String acceptedFriendRequest(Object user);

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get noFriendsYet;

  /// No description provided for @findFriendsButton.
  ///
  /// In en, this message translates to:
  /// **'Find Friends'**
  String get findFriendsButton;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @sentFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Sent you a friend request'**
  String get sentFriendRequest;

  /// No description provided for @rankReachLevel.
  ///
  /// In en, this message translates to:
  /// **'Reach Level {level}'**
  String rankReachLevel(Object level);

  /// No description provided for @achFirstMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get achFirstMatchTitle;

  /// No description provided for @achFirstMatchDesc.
  ///
  /// In en, this message translates to:
  /// **'Record your first match result.'**
  String get achFirstMatchDesc;

  /// No description provided for @achFirstWinTitle.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get achFirstWinTitle;

  /// No description provided for @achFirstWinDesc.
  ///
  /// In en, this message translates to:
  /// **'Win your first competitive match.'**
  String get achFirstWinDesc;

  /// No description provided for @achVeteranTitle.
  ///
  /// In en, this message translates to:
  /// **'Veteran'**
  String get achVeteranTitle;

  /// No description provided for @achVeteranDesc.
  ///
  /// In en, this message translates to:
  /// **'Play 100 matches.'**
  String get achVeteranDesc;

  /// No description provided for @achSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Social Butterfly'**
  String get achSocialTitle;

  /// No description provided for @achSocialDesc.
  ///
  /// In en, this message translates to:
  /// **'Add 5 friends.'**
  String get achSocialDesc;

  /// No description provided for @friendsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} friends'**
  String friendsCount(Object count);

  /// No description provided for @appearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @selectBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Birth Date'**
  String get selectBirthDateLabel;

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location Updated: {lat}, {lng}'**
  String locationUpdated(Object lat, Object lng);

  /// No description provided for @locationCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {lat}, {lng}'**
  String locationCurrent(Object lat, Object lng);

  /// No description provided for @updateLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Location (Tap to fetch)'**
  String get updateLocationLabel;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButton;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileUpdatedError.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile: {error}'**
  String profileUpdatedError(Object error);

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationDisabled;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationDenied;

  /// No description provided for @locationPermDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied.'**
  String get locationPermDenied;

  /// No description provided for @locationUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Location updated! Press Save to persist.'**
  String get locationUpdateSuccess;

  /// No description provided for @locationUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error getting location: {error}'**
  String locationUpdateError(Object error);

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded!'**
  String get imageUploaded;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed: {error}'**
  String imageUploadFailed(Object error);

  /// No description provided for @lvl0Title.
  ///
  /// In en, this message translates to:
  /// **'Unranked'**
  String get lvl0Title;

  /// No description provided for @lvl1Title.
  ///
  /// In en, this message translates to:
  /// **'Board Game Recruit'**
  String get lvl1Title;

  /// No description provided for @lvl2Title.
  ///
  /// In en, this message translates to:
  /// **'Dice Roller'**
  String get lvl2Title;

  /// No description provided for @lvl3Title.
  ///
  /// In en, this message translates to:
  /// **'Card Buyer'**
  String get lvl3Title;

  /// No description provided for @lvl4Title.
  ///
  /// In en, this message translates to:
  /// **'Setup Specialist'**
  String get lvl4Title;

  /// No description provided for @lvl5Title.
  ///
  /// In en, this message translates to:
  /// **'Rulebook Reader'**
  String get lvl5Title;

  /// No description provided for @lvl6Title.
  ///
  /// In en, this message translates to:
  /// **'Meeple Mover'**
  String get lvl6Title;

  /// No description provided for @lvl7Title.
  ///
  /// In en, this message translates to:
  /// **'Token Keeper'**
  String get lvl7Title;

  /// No description provided for @lvl8Title.
  ///
  /// In en, this message translates to:
  /// **'Mechanics Explorer'**
  String get lvl8Title;

  /// No description provided for @lvl9Title.
  ///
  /// In en, this message translates to:
  /// **'Gateway Gamer'**
  String get lvl9Title;

  /// No description provided for @lvl10Title.
  ///
  /// In en, this message translates to:
  /// **'Cardboard Baron'**
  String get lvl10Title;

  /// No description provided for @lvl11Title.
  ///
  /// In en, this message translates to:
  /// **'Combo Hunter'**
  String get lvl11Title;

  /// No description provided for @lvl12Title.
  ///
  /// In en, this message translates to:
  /// **'Sleeve Defender'**
  String get lvl12Title;

  /// No description provided for @lvl13Title.
  ///
  /// In en, this message translates to:
  /// **'Box Organizer'**
  String get lvl13Title;

  /// No description provided for @lvl14Title.
  ///
  /// In en, this message translates to:
  /// **'VP Counter'**
  String get lvl14Title;

  /// No description provided for @lvl15Title.
  ///
  /// In en, this message translates to:
  /// **'Tuesday Strategist'**
  String get lvl15Title;

  /// No description provided for @lvl16Title.
  ///
  /// In en, this message translates to:
  /// **'Tiebreaker Champion'**
  String get lvl16Title;

  /// No description provided for @lvl17Title.
  ///
  /// In en, this message translates to:
  /// **'Deckbuilding Mage'**
  String get lvl17Title;

  /// No description provided for @lvl18Title.
  ///
  /// In en, this message translates to:
  /// **'AP Victim'**
  String get lvl18Title;

  /// No description provided for @lvl19Title.
  ///
  /// In en, this message translates to:
  /// **'Bluff King'**
  String get lvl19Title;

  /// No description provided for @lvl20Title.
  ///
  /// In en, this message translates to:
  /// **'Scoring Titan'**
  String get lvl20Title;

  /// No description provided for @lvl21Title.
  ///
  /// In en, this message translates to:
  /// **'Worker Placement Specialist'**
  String get lvl21Title;

  /// No description provided for @lvl22Title.
  ///
  /// In en, this message translates to:
  /// **'Turf Dominator'**
  String get lvl22Title;

  /// No description provided for @lvl23Title.
  ///
  /// In en, this message translates to:
  /// **'Area Control General'**
  String get lvl23Title;

  /// No description provided for @lvl24Title.
  ///
  /// In en, this message translates to:
  /// **'Turn Optimizer'**
  String get lvl24Title;

  /// No description provided for @lvl25Title.
  ///
  /// In en, this message translates to:
  /// **'Master Rule Breaker'**
  String get lvl25Title;

  /// No description provided for @lvl26Title.
  ///
  /// In en, this message translates to:
  /// **'Kingmaker Punisher'**
  String get lvl26Title;

  /// No description provided for @lvl27Title.
  ///
  /// In en, this message translates to:
  /// **'Board Mathematician'**
  String get lvl27Title;

  /// No description provided for @lvl28Title.
  ///
  /// In en, this message translates to:
  /// **'Eurogame Emperor'**
  String get lvl28Title;

  /// No description provided for @lvl29Title.
  ///
  /// In en, this message translates to:
  /// **'Ameritrash Legend'**
  String get lvl29Title;

  /// No description provided for @lvl30Title.
  ///
  /// In en, this message translates to:
  /// **'Board Architect'**
  String get lvl30Title;

  /// No description provided for @lvl31Title.
  ///
  /// In en, this message translates to:
  /// **'Expansion Expert'**
  String get lvl31Title;

  /// No description provided for @lvl32Title.
  ///
  /// In en, this message translates to:
  /// **'Miniature Painter'**
  String get lvl32Title;

  /// No description provided for @lvl33Title.
  ///
  /// In en, this message translates to:
  /// **'Kickstarter Backer'**
  String get lvl33Title;

  /// No description provided for @lvl34Title.
  ///
  /// In en, this message translates to:
  /// **'Promo Finder'**
  String get lvl34Title;

  /// No description provided for @lvl35Title.
  ///
  /// In en, this message translates to:
  /// **'Shelf Curator'**
  String get lvl35Title;

  /// No description provided for @lvl36Title.
  ///
  /// In en, this message translates to:
  /// **'Shelf of Shame Owner'**
  String get lvl36Title;

  /// No description provided for @lvl37Title.
  ///
  /// In en, this message translates to:
  /// **'Crowdfunding Oracle'**
  String get lvl37Title;

  /// No description provided for @lvl38Title.
  ///
  /// In en, this message translates to:
  /// **'Campaign Hoarder'**
  String get lvl38Title;

  /// No description provided for @lvl39Title.
  ///
  /// In en, this message translates to:
  /// **'Collection Monarch'**
  String get lvl39Title;

  /// No description provided for @lvl40Title.
  ///
  /// In en, this message translates to:
  /// **'The Completionist'**
  String get lvl40Title;

  /// No description provided for @lvl41Title.
  ///
  /// In en, this message translates to:
  /// **'Sacred Beta Tester'**
  String get lvl41Title;

  /// No description provided for @lvl42Title.
  ///
  /// In en, this message translates to:
  /// **'Obscure Tactics Creator'**
  String get lvl42Title;

  /// No description provided for @lvl43Title.
  ///
  /// In en, this message translates to:
  /// **'Rules Encyclopedia'**
  String get lvl43Title;

  /// No description provided for @lvl44Title.
  ///
  /// In en, this message translates to:
  /// **'Impartial Referee'**
  String get lvl44Title;

  /// No description provided for @lvl45Title.
  ///
  /// In en, this message translates to:
  /// **'Sage of the Board'**
  String get lvl45Title;

  /// No description provided for @lvl46Title.
  ///
  /// In en, this message translates to:
  /// **'Seer of Moves'**
  String get lvl46Title;

  /// No description provided for @lvl47Title.
  ///
  /// In en, this message translates to:
  /// **'Supreme Host'**
  String get lvl47Title;

  /// No description provided for @lvl48Title.
  ///
  /// In en, this message translates to:
  /// **'Shadow Designer'**
  String get lvl48Title;

  /// No description provided for @lvl49Title.
  ///
  /// In en, this message translates to:
  /// **'Golden Meeple Incarnate'**
  String get lvl49Title;

  /// No description provided for @lvl50Title.
  ///
  /// In en, this message translates to:
  /// **'Deity of Wooden Pieces'**
  String get lvl50Title;

  /// No description provided for @reviewGame.
  ///
  /// In en, this message translates to:
  /// **'Review Game'**
  String get reviewGame;

  /// No description provided for @rateThisGame.
  ///
  /// In en, this message translates to:
  /// **'Rate this game:'**
  String get rateThisGame;

  /// No description provided for @communityReviews.
  ///
  /// In en, this message translates to:
  /// **'Community Reviews'**
  String get communityReviews;

  /// No description provided for @ratingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Ratings'**
  String ratingsCount(Object count);

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Write your thoughts (Optional)...'**
  String get reviewHint;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;
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
