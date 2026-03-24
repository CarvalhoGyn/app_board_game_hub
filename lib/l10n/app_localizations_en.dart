// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to continue your board game journey';

  @override
  String get usernameLabel => 'Username';

  @override
  String get loginButton => 'Login';

  @override
  String get registerText => 'Don\'t have an account? Register';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get logoutButton => 'Logout';

  @override
  String get profileTitle => 'Profile';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get collectionTitle => 'Collection';

  @override
  String get matchesTitle => 'Matches';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get loading => 'Loading...';

  @override
  String get ok => 'OK';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get trendingGames => 'Trending Games';

  @override
  String get seeAll => 'See All';

  @override
  String get noTrendingGames => 'No Trends Yet';

  @override
  String get noTrendingSubtitle =>
      'Play matches to see what\'s hot among your group.';

  @override
  String get startMatch => 'Start Match';

  @override
  String get recommendedForYou => 'Recommended for You';

  @override
  String get needMoreData => 'Need More Data';

  @override
  String get needMoreDataSubtitle =>
      'Play and rate games to get personalized picks.';

  @override
  String get exploreGamesButton => 'Explore Games';

  @override
  String playersCount(Object max, Object min) {
    return '$min-$max players';
  }

  @override
  String rankLabel(Object rank) {
    return '(Rank #$rank)';
  }

  @override
  String get exploreTitle => 'Explore Games';

  @override
  String get searchPlaceholder => 'Search for board games...';

  @override
  String get emptySearchTitle => 'Search for your favorite games';

  @override
  String get emptySearchSubtitle => 'Type a game name to start exploring';

  @override
  String get noResults => 'No games found';

  @override
  String get noResultsSubtitle => 'Try searching with different keywords';

  @override
  String get enrichDatabase => 'Enrich Database';

  @override
  String get enrichConfirmation =>
      'This will fetch details for ALL games from BoardGameGeek. This may take a long time.\n\nContinue?';

  @override
  String get newMatchTitle => 'New Match';

  @override
  String get selectGameLabel => 'Select a Game';

  @override
  String get gameLabel => 'Game';

  @override
  String get scoringMode => 'Scoring Mode';

  @override
  String get competitive => 'Competitive';

  @override
  String get cooperative => 'Cooperative';

  @override
  String get whoIsPlaying => 'Who\'s playing?';

  @override
  String get whoStarts => 'Who starts?';

  @override
  String get diceSubtitle => 'Don\'t argue, let the dice decide your fate.';

  @override
  String get rollButton => 'ROLL';

  @override
  String get pickRandomPlayer => 'Tap to pick a random player';

  @override
  String get diceRolled => 'Dice Rolled! 🎲';

  @override
  String get startingPlayerIs => 'The starting player is:';

  @override
  String get addPlayersWarning => 'Add players first!';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get requestSent => 'Request Sent';

  @override
  String get friendsButton => 'Friends';

  @override
  String get winsLabel => 'Wins';

  @override
  String get winRateLabel => 'Win Rate';

  @override
  String get achievementsLabel => 'Achievements';

  @override
  String get badgesSubtitle => 'Badges and milestones';

  @override
  String get myCollection => 'My Collection';

  @override
  String gamesCount(Object count) {
    return '$count games';
  }

  @override
  String get matchHistory => 'Game History';

  @override
  String matchesPlayed(Object count) {
    return '$count matches played';
  }

  @override
  String levelLabel(Object level) {
    return 'LEVEL $level';
  }

  @override
  String xpLabel(Object current, Object total) {
    return '$current / $total XP';
  }

  @override
  String get prestigeReset => 'PRESTIGE RESET';

  @override
  String get prestigeAscension => '🌟 Prestige Ascension 🌟';

  @override
  String get prestigeWarning =>
      'Are you sure? This will RESET your level to 1, but you will gain a PRESTIGE STAR and eternal glory.';

  @override
  String get ascendButton => 'ASCEND';

  @override
  String get historyYear => 'Year';

  @override
  String get historyMonth => 'Month';

  @override
  String get historyNoMatches => 'No matches found for this filter.';
}
