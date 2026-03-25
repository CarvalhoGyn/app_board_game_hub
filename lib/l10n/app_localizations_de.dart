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
  String get seeDetails => 'Details';

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

  @override
  String get unlockedLabel => 'Freigeschaltet';

  @override
  String get lockedLabel => 'Gesperrt';

  @override
  String unlockedOnDate(Object date) {
    return 'Freigeschaltet am $date';
  }

  @override
  String get closeButton => 'Schließen';

  @override
  String get myWishlistTitle => 'Meine Wunschliste';

  @override
  String get emptyWishlist => 'Deine Wunschliste ist leer';

  @override
  String get exploreToAddToWishlist => 'Entdecke Spiele, um sie hinzuzufügen';

  @override
  String removedFromWishlist(Object game) {
    return '$game von Wunschliste entfernt';
  }

  @override
  String get emptyCollection => 'Deine Sammlung ist leer';

  @override
  String get exploreToAddToCollection => 'Markiere Spiele als im Besitz';

  @override
  String removedFromCollection(Object game) {
    return '$game aus Sammlung entfernt';
  }

  @override
  String get myFriendsTab => 'Meine Freunde';

  @override
  String get friendRequestsTab => 'Anfragen';

  @override
  String friendRequestsCount(Object count) {
    return 'Anfragen ($count)';
  }

  @override
  String acceptedFriendRequest(Object user) {
    return 'Anfrage von $user akzeptiert (+10 XP)';
  }

  @override
  String get noFriendsYet => 'Noch keine Freunde';

  @override
  String get findFriendsButton => 'Freunde finden';

  @override
  String get noPendingRequests => 'Keine ausstehenden Anfragen';

  @override
  String get sentFriendRequest => 'Hat dir eine Anfrage gesendet';

  @override
  String rankReachLevel(Object level) {
    return 'Reach Level $level';
  }

  @override
  String get achFirstMatchTitle => 'Erste Schritte';

  @override
  String get achFirstMatchDesc => 'Trage dein erstes Spielergebnis ein.';

  @override
  String get achFirstWinTitle => 'Champion';

  @override
  String get achFirstWinDesc => 'Gewinne dein erstes Spiel.';

  @override
  String get achVeteranTitle => 'Veteran';

  @override
  String get achVeteranDesc => 'Spiele 100 Spiele.';

  @override
  String get achSocialTitle => 'Netzwerker';

  @override
  String get achSocialDesc => 'Füge 5 Freunde hinzu.';

  @override
  String friendsCount(Object count) {
    return '$count Freunde';
  }

  @override
  String get appearanceLabel => 'Erscheinungsbild';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get firstNameLabel => 'Vorname';

  @override
  String get lastNameLabel => 'Nachname';

  @override
  String get phoneNumberLabel => 'Telefonnummer';

  @override
  String get countryLabel => 'Land';

  @override
  String get selectBirthDateLabel => 'Geburtsdatum wählen';

  @override
  String locationUpdated(Object lat, Object lng) {
    return 'Standort: $lat, $lng';
  }

  @override
  String locationCurrent(Object lat, Object lng) {
    return 'Aktuell: $lat, $lng';
  }

  @override
  String get updateLocationLabel => 'Standort aktualisieren';

  @override
  String get saveChangesButton => 'Speichern';

  @override
  String get profileUpdatedSuccess => 'Profil erfolgreich aktualisiert';

  @override
  String profileUpdatedError(Object error) {
    return 'Fehler beim Aktualisieren: $error';
  }

  @override
  String get locationDisabled => 'Standortdienste sind deaktiviert.';

  @override
  String get locationDenied => 'Standortberechtigungen verweigert';

  @override
  String get locationPermDenied => 'Standort verweigert.';

  @override
  String get locationUpdateSuccess => 'Standort aktualisiert!';

  @override
  String locationUpdateError(Object error) {
    return 'Fehler beim Abrufen: $error';
  }

  @override
  String get imageUploaded => 'Bild hochgeladen!';

  @override
  String imageUploadFailed(Object error) {
    return 'Fehler beim Hochladen: $error';
  }

  @override
  String get lvl0Title => 'Unbesehen';

  @override
  String get lvl1Title => 'Brettspiel-Rekrut';

  @override
  String get lvl2Title => 'Würfelroller';

  @override
  String get lvl3Title => 'Kartenkäufer';

  @override
  String get lvl4Title => 'Aufbau-Spezialist';

  @override
  String get lvl5Title => 'Regelleser';

  @override
  String get lvl6Title => 'Meeple-Schieber';

  @override
  String get lvl7Title => 'Token-Hüter';

  @override
  String get lvl8Title => 'Mechanik-Entdecker';

  @override
  String get lvl9Title => 'Gateway-Spieler';

  @override
  String get lvl10Title => 'Papp-Baron';

  @override
  String get lvl11Title => 'Kombo-Jäger';

  @override
  String get lvl12Title => 'Sleeve-Verteidiger';

  @override
  String get lvl13Title => 'Schachtel-Organisator';

  @override
  String get lvl14Title => 'Punkte-Zähler';

  @override
  String get lvl15Title => 'Dienstags-Stratege';

  @override
  String get lvl16Title => 'Tiebreaker-Champion';

  @override
  String get lvl17Title => 'Deckbuilding-Magier';

  @override
  String get lvl18Title => 'Analyse-Paralyse-Opfer';

  @override
  String get lvl19Title => 'Bluff-König';

  @override
  String get lvl20Title => 'Punkte-Titan';

  @override
  String get lvl21Title => 'Worker-Placement-Spezialist';

  @override
  String get lvl22Title => 'Gebiets-Dominator';

  @override
  String get lvl23Title => 'Area-Control-General';

  @override
  String get lvl24Title => 'Züge-Optimierer';

  @override
  String get lvl25Title => 'Regelbrecher';

  @override
  String get lvl26Title => 'Kingmaker-Bestrafer';

  @override
  String get lvl27Title => 'Brettspiel-Mathematiker';

  @override
  String get lvl28Title => 'Eurogame-Kaiser';

  @override
  String get lvl29Title => 'Ameritrash-Legende';

  @override
  String get lvl30Title => 'Brett-Architekt';

  @override
  String get lvl31Title => 'Erweiterungs-Experte';

  @override
  String get lvl32Title => 'Miniaturen-Maler';

  @override
  String get lvl33Title => 'Kickstarter-Unterstützer';

  @override
  String get lvl34Title => 'Promo-Jäger';

  @override
  String get lvl35Title => 'Regal-Kurator';

  @override
  String get lvl36Title => 'Regal der Schande Besitzer';

  @override
  String get lvl37Title => 'Crowdfunding-Orakel';

  @override
  String get lvl38Title => 'Kampagnen-Sammler';

  @override
  String get lvl39Title => 'Sammlungs-Monarch';

  @override
  String get lvl40Title => 'Der Komplettierer';

  @override
  String get lvl41Title => 'Heiliger Beta-Tester';

  @override
  String get lvl42Title => 'Schöpfer obskurer Taktiken';

  @override
  String get lvl43Title => 'Regel-Enzyklopädie';

  @override
  String get lvl44Title => 'Unparteiischer Schiedsrichter';

  @override
  String get lvl45Title => 'Weiser des Brettes';

  @override
  String get lvl46Title => 'Seher der Züge';

  @override
  String get lvl47Title => 'Oberster Gastgeber';

  @override
  String get lvl48Title => 'Schatten-Designer';

  @override
  String get lvl49Title => 'Goldener Meeple';

  @override
  String get lvl50Title => 'Gottheit der Holzfiguren';

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
}
