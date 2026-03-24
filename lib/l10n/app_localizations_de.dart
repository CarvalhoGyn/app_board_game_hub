// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get loginTitle => 'Willkommen zurück';

  @override
  String get loginSubtitle =>
      'Melden Sie sich an, um Ihre Brettspiel-Reise fortzusetzen';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get registerText => 'Kein Konto? Registrieren';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get themeLabel => 'Thema';

  @override
  String get logoutButton => 'Abmelden';

  @override
  String get profileTitle => 'Profil';

  @override
  String get friendsTitle => 'Freunde';

  @override
  String get collectionTitle => 'Sammlung';

  @override
  String get matchesTitle => 'Spiele';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get search => 'Suchen';

  @override
  String get loading => 'Laden...';

  @override
  String get ok => 'OK';

  @override
  String error(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get welcomeBack => 'Willkommen zurück,';

  @override
  String get trendingGames => 'Angesagte Spiele';

  @override
  String get seeAll => 'Alle ansehen';

  @override
  String get noTrendingGames => 'Noch keine Trends';

  @override
  String get noTrendingSubtitle =>
      'Spiele Partien, um zu sehen, was in deiner Gruppe angesagt ist.';

  @override
  String get startMatch => 'Spiel starten';

  @override
  String get recommendedForYou => 'Für dich empfohlen';

  @override
  String get needMoreData => 'Benötige mehr Daten';

  @override
  String get needMoreDataSubtitle =>
      'Spiele und bewerte Spiele, um persönliche Empfehlungen zu erhalten.';

  @override
  String get exploreGamesButton => 'Spiele entdecken';

  @override
  String playersCount(Object max, Object min) {
    return '$min-$max Spieler';
  }

  @override
  String rankLabel(Object rank) {
    return '(Rang #$rank)';
  }

  @override
  String get exploreTitle => 'Spiele entdecken';

  @override
  String get searchPlaceholder => 'Nach Brettspielen suchen...';

  @override
  String get emptySearchTitle => 'Suche nach deinen Lieblingsspielen';

  @override
  String get emptySearchSubtitle => 'Gib einen Spielnamen ein, um zu beginnen';

  @override
  String get noResults => 'Keine Spiele gefunden';

  @override
  String get noResultsSubtitle => 'Versuche es mit anderen Suchbegriffen';

  @override
  String get enrichDatabase => 'Datenbank anreichern';

  @override
  String get enrichConfirmation =>
      'Dies ruft Details für ALLE Spiele von BoardGameGeek ab. Dies kann lange dauern.\n\nFortfahren?';

  @override
  String get newMatchTitle => 'Neues Spiel';

  @override
  String get selectGameLabel => 'Wähle ein Spiel';

  @override
  String get gameLabel => 'Spiel';

  @override
  String get scoringMode => 'Punktemodus';

  @override
  String get competitive => 'Wettbewerb';

  @override
  String get cooperative => 'Kooperativ';

  @override
  String get whoIsPlaying => 'Wer spielt?';

  @override
  String get whoStarts => 'Wer beginnt?';

  @override
  String get diceSubtitle => 'Nicht streiten, lass die Würfel entscheiden.';

  @override
  String get rollButton => 'WÜRFELN';

  @override
  String get pickRandomPlayer => 'Tippen, um zufälligen Spieler zu wählen';

  @override
  String get diceRolled => 'Gewürfelt! 🎲';

  @override
  String get startingPlayerIs => 'Der Startspieler ist:';

  @override
  String get addPlayersWarning => 'Füge zuerst Spieler hinzu!';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get addFriend => 'Freund hinzufügen';

  @override
  String get requestSent => 'Anfrage gesendet';

  @override
  String get friendsButton => 'Freunde';

  @override
  String get winsLabel => 'Siege';

  @override
  String get winRateLabel => 'Siegquote';

  @override
  String get achievementsLabel => 'Erfolge';

  @override
  String get badgesSubtitle => 'Abzeichen und Meilensteine';

  @override
  String get myCollection => 'Meine Sammlung';

  @override
  String gamesCount(Object count) {
    return '$count Spiele';
  }

  @override
  String get matchHistory => 'Spielhistorie';

  @override
  String matchesPlayed(Object count) {
    return '$count Spiele gespielt';
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
  String get prestigeReset => 'PRESTIGE ZURÜCKSETZEN';

  @override
  String get prestigeAscension => '🌟 Prestige-Aufstieg 🌟';

  @override
  String get prestigeWarning =>
      'Bist du sicher? Dies setzt dein Level auf 1 zurück, aber du erhältst einen PRESTIGE-STERN und ewigen Ruhm.';

  @override
  String get ascendButton => 'AUFSTEIGEN';

  @override
  String get historyYear => 'Jahr';

  @override
  String get historyMonth => 'Monat';

  @override
  String get historyNoMatches => 'Keine Spiele für diesen Filter gefunden.';
}
