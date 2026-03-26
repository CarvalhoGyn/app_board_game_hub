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
  String get seeDetails => 'Details';

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

  @override
  String get unlockedLabel => 'Unlocked';

  @override
  String get lockedLabel => 'Locked';

  @override
  String unlockedOnDate(Object date) {
    return 'Unlocked on $date';
  }

  @override
  String get closeButton => 'Close';

  @override
  String get myWishlistTitle => 'My Wishlist';

  @override
  String get emptyWishlist => 'Your wishlist is empty';

  @override
  String get exploreToAddToWishlist => 'Explore games to add them here';

  @override
  String removedFromWishlist(Object game) {
    return '$game removed from wishlist';
  }

  @override
  String get emptyCollection => 'Your collection is empty';

  @override
  String get exploreToAddToCollection => 'Mark games as owned to see them here';

  @override
  String removedFromCollection(Object game) {
    return '$game removed from collection';
  }

  @override
  String get myFriendsTab => 'My Friends';

  @override
  String get friendRequestsTab => 'Requests';

  @override
  String friendRequestsCount(Object count) {
    return 'Requests ($count)';
  }

  @override
  String acceptedFriendRequest(Object user) {
    return 'Accepted friend request from $user (+10 XP)';
  }

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get findFriendsButton => 'Find Friends';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get sentFriendRequest => 'Sent you a friend request';

  @override
  String rankReachLevel(Object level) {
    return 'Reach Level $level';
  }

  @override
  String get achFirstMatchTitle => 'First Steps';

  @override
  String get achFirstMatchDesc => 'Record your first match result.';

  @override
  String get achFirstWinTitle => 'Champion';

  @override
  String get achFirstWinDesc => 'Win your first competitive match.';

  @override
  String get achVeteranTitle => 'Veteran';

  @override
  String get achVeteranDesc => 'Play 100 matches.';

  @override
  String get achSocialTitle => 'Social Butterfly';

  @override
  String get achSocialDesc => 'Add 5 friends.';

  @override
  String friendsCount(Object count) {
    return '$count friends';
  }

  @override
  String get appearanceLabel => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get countryLabel => 'Country';

  @override
  String get selectBirthDateLabel => 'Select Birth Date';

  @override
  String locationUpdated(Object lat, Object lng) {
    return 'Location Updated: $lat, $lng';
  }

  @override
  String locationCurrent(Object lat, Object lng) {
    return 'Current: $lat, $lng';
  }

  @override
  String get updateLocationLabel => 'Update Location (Tap to fetch)';

  @override
  String get saveChangesButton => 'Save Changes';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String profileUpdatedError(Object error) {
    return 'Error updating profile: $error';
  }

  @override
  String get locationDisabled => 'Location services are disabled.';

  @override
  String get locationDenied => 'Location permissions are denied';

  @override
  String get locationPermDenied =>
      'Location permissions are permanently denied.';

  @override
  String get locationUpdateSuccess =>
      'Location updated! Press Save to persist.';

  @override
  String locationUpdateError(Object error) {
    return 'Error getting location: $error';
  }

  @override
  String get imageUploaded => 'Image uploaded!';

  @override
  String imageUploadFailed(Object error) {
    return 'Upload failed: $error';
  }

  @override
  String get lvl0Title => 'Unranked';

  @override
  String get lvl1Title => 'Board Game Recruit';

  @override
  String get lvl2Title => 'Dice Roller';

  @override
  String get lvl3Title => 'Card Buyer';

  @override
  String get lvl4Title => 'Setup Specialist';

  @override
  String get lvl5Title => 'Rulebook Reader';

  @override
  String get lvl6Title => 'Meeple Mover';

  @override
  String get lvl7Title => 'Token Keeper';

  @override
  String get lvl8Title => 'Mechanics Explorer';

  @override
  String get lvl9Title => 'Gateway Gamer';

  @override
  String get lvl10Title => 'Cardboard Baron';

  @override
  String get lvl11Title => 'Combo Hunter';

  @override
  String get lvl12Title => 'Sleeve Defender';

  @override
  String get lvl13Title => 'Box Organizer';

  @override
  String get lvl14Title => 'VP Counter';

  @override
  String get lvl15Title => 'Tuesday Strategist';

  @override
  String get lvl16Title => 'Tiebreaker Champion';

  @override
  String get lvl17Title => 'Deckbuilding Mage';

  @override
  String get lvl18Title => 'AP Victim';

  @override
  String get lvl19Title => 'Bluff King';

  @override
  String get lvl20Title => 'Scoring Titan';

  @override
  String get lvl21Title => 'Worker Placement Specialist';

  @override
  String get lvl22Title => 'Turf Dominator';

  @override
  String get lvl23Title => 'Area Control General';

  @override
  String get lvl24Title => 'Turn Optimizer';

  @override
  String get lvl25Title => 'Master Rule Breaker';

  @override
  String get lvl26Title => 'Kingmaker Punisher';

  @override
  String get lvl27Title => 'Board Mathematician';

  @override
  String get lvl28Title => 'Eurogame Emperor';

  @override
  String get lvl29Title => 'Ameritrash Legend';

  @override
  String get lvl30Title => 'Board Architect';

  @override
  String get lvl31Title => 'Expansion Expert';

  @override
  String get lvl32Title => 'Miniature Painter';

  @override
  String get lvl33Title => 'Kickstarter Backer';

  @override
  String get lvl34Title => 'Promo Finder';

  @override
  String get lvl35Title => 'Shelf Curator';

  @override
  String get lvl36Title => 'Shelf of Shame Owner';

  @override
  String get lvl37Title => 'Crowdfunding Oracle';

  @override
  String get lvl38Title => 'Campaign Hoarder';

  @override
  String get lvl39Title => 'Collection Monarch';

  @override
  String get lvl40Title => 'The Completionist';

  @override
  String get lvl41Title => 'Sacred Beta Tester';

  @override
  String get lvl42Title => 'Obscure Tactics Creator';

  @override
  String get lvl43Title => 'Rules Encyclopedia';

  @override
  String get lvl44Title => 'Impartial Referee';

  @override
  String get lvl45Title => 'Sage of the Board';

  @override
  String get lvl46Title => 'Seer of Moves';

  @override
  String get lvl47Title => 'Supreme Host';

  @override
  String get lvl48Title => 'Shadow Designer';

  @override
  String get lvl49Title => 'Golden Meeple Incarnate';

  @override
  String get lvl50Title => 'Deity of Wooden Pieces';

  @override
  String get reviewGame => 'Review Game';

  @override
  String get rateThisGame => 'Rate this game:';

  @override
  String get communityReviews => 'Community Reviews';

  @override
  String ratingsCount(Object count) {
    return '$count Ratings';
  }

  @override
  String get reviewHint => 'Write your thoughts (Optional)...';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get syncCompleted => 'Sync completed';

  @override
  String get recordMatch => 'Record Match';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get notifLevelUpTitle => 'Level Up!';

  @override
  String notifLevelUpMsg(Object level, Object rank) {
    return 'You reached Level $level: $rank!';
  }

  @override
  String get notifAchievementTitle => 'Achievement Unlocked!';

  @override
  String notifAchievementMsg(Object title) {
    return 'You unlocked: $title';
  }

  @override
  String get notifPrestigeTitle => 'PRESTIGE UNLOCKED! ⭐';

  @override
  String get notifPrestigeMsg =>
      'You have ascended! Your level is reset, but your glory grows.';

  @override
  String get notifFriendRequestTitle => 'New Friend Request';

  @override
  String notifFriendRequestMsg(Object name) {
    return '$name wants to be your friend!';
  }

  @override
  String get notifMatchVictoryTitle => 'VICTORY!';

  @override
  String get notifMatchVictoryMsg => 'Match result: VICTORY!';

  @override
  String get notifMatchDefeatTitle => 'DEFEAT';

  @override
  String get notifMatchDefeatMsg => 'Match result: DEFEAT';

  @override
  String get categoriesLabel => 'CATEGORIES';

  @override
  String get mechanicsLabel => 'MECHANICS';

  @override
  String get bggRatingLabel => 'BGG RATING';

  @override
  String get timeLabel => 'TIME';

  @override
  String get playersLabel => 'PLAYERS';

  @override
  String get aboutThisGame => 'About this Game';

  @override
  String get classificationLabel => 'Classification';

  @override
  String get typeLabel => 'Type';

  @override
  String get familyLabel => 'Family';

  @override
  String get integrationsLabel => 'Integrations';

  @override
  String get reimplementsLabel => 'Reimplements';

  @override
  String get translate => 'Translate description';

  @override
  String get showOriginal => 'Show Original';

  @override
  String get premiumTitle => 'MeepleSync Premium';

  @override
  String get premiumSubtitle =>
      'Take your board gaming experience to the next level.';

  @override
  String get premiumFeature1Title => 'Unlimited Matches';

  @override
  String get premiumFeature1Desc =>
      'Record all your matches without any restrictions.';

  @override
  String get premiumFeature2Title => 'Advanced Statistics';

  @override
  String get premiumFeature2Desc =>
      'Detailed charts and insights of your performance.';

  @override
  String get premiumFeature3Title => 'Priority Sync';

  @override
  String get premiumFeature3Desc =>
      'Your data always safe and synced across devices.';

  @override
  String get premiumMonthlyPlan => 'Monthly Plan';

  @override
  String get premiumAnnualPlan => 'Annual Plan';

  @override
  String get premiumMonthlyPrice => '\$ 1.99 / month';

  @override
  String get premiumAnnualPrice => '\$ 14.99 / year';

  @override
  String get premiumMonthlyDesc => 'Perfect for occasional players.';

  @override
  String get premiumAnnualDesc => 'Save 33% and support the project!';

  @override
  String get premiumBestValue => 'BEST VALUE';

  @override
  String get premiumSubscribeButton => 'Subscribe Now';

  @override
  String get registrationEmailConfirmation =>
      'Please confirm your account in the email provided.';

  @override
  String get matchLimitTitle => 'Match Limit Reached';

  @override
  String get matchLimitMessage =>
      'You can only participate in 5 matches with a free account. Upgrade to Pro to record more!';

  @override
  String matchLimitFriendMessage(Object username) {
    return '$username reached the free match limit and cannot be added.';
  }

  @override
  String get upgradeNow => 'Upgrade Now';

  @override
  String get noOfferingsAvailable => 'No offerings available at the moment.';

  @override
  String get premiumWelcomeMessage => 'Welcome to MeepleSync Pro!';

  @override
  String get subscriptionFailed => 'Subscription failed. Please try again.';
}
