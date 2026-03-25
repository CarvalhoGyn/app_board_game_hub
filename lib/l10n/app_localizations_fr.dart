// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loginTitle => 'Bon retour';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour continuer votre aventure de jeux de société';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get loginButton => 'Connexion';

  @override
  String get registerText => 'Pas de compte ? S\'inscrire';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get languageLabel => 'Langue';

  @override
  String get themeLabel => 'Thème';

  @override
  String get logoutButton => 'Déconnexion';

  @override
  String get profileTitle => 'Profil';

  @override
  String get friendsTitle => 'Amis';

  @override
  String get collectionTitle => 'Collection';

  @override
  String get matchesTitle => 'Matchs';

  @override
  String get cancel => 'Annuler';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get loading => 'Chargement...';

  @override
  String get ok => 'OK';

  @override
  String error(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get welcomeBack => 'Bon retour,';

  @override
  String get trendingGames => 'Jeux Tendance';

  @override
  String get seeAll => 'Voir Tout';

  @override
  String get noTrendingGames => 'Pas encore de tendances';

  @override
  String get noTrendingSubtitle =>
      'Jouez des matchs pour voir ce qui est populaire dans votre groupe.';

  @override
  String get startMatch => 'Commencer le Match';

  @override
  String get recommendedForYou => 'Recommandé pour Vous';

  @override
  String get needMoreData => 'Besoin de plus de données';

  @override
  String get needMoreDataSubtitle =>
      'Jouez et notez des jeux pour obtenir des choix personnalisés.';

  @override
  String get exploreGamesButton => 'Explorer les Jeux';

  @override
  String playersCount(Object max, Object min) {
    return '$min-$max joueurs';
  }

  @override
  String rankLabel(Object rank) {
    return '(Rang #$rank)';
  }

  @override
  String get exploreTitle => 'Explorer les Jeux';

  @override
  String get searchPlaceholder => 'Rechercher des jeux de société...';

  @override
  String get emptySearchTitle => 'Recherchez vos jeux préférés';

  @override
  String get emptySearchSubtitle =>
      'Tapez un nom de jeu pour commencer à explorer';

  @override
  String get noResults => 'Aucun jeu trouvé';

  @override
  String get noResultsSubtitle =>
      'Essayez de rechercher avec des mots-clés différents';

  @override
  String get enrichDatabase => 'Enrichir la Base de Données';

  @override
  String get enrichConfirmation =>
      'Cela récupérera les détails de TOUS les jeux de BoardGameGeek. Cela peut prendre beaucoup de temps.\n\nContinuer ?';

  @override
  String get newMatchTitle => 'Nouveau Match';

  @override
  String get selectGameLabel => 'Sélectionner un Jeu';

  @override
  String get gameLabel => 'Jeu';

  @override
  String get scoringMode => 'Mode de Score';

  @override
  String get competitive => 'Compétitif';

  @override
  String get cooperative => 'Coopératif';

  @override
  String get whoIsPlaying => 'Qui joue ?';

  @override
  String get whoStarts => 'Qui commence ?';

  @override
  String get diceSubtitle =>
      'Ne discutez pas, laissez les dés décider de votre sort.';

  @override
  String get rollButton => 'LANCER';

  @override
  String get pickRandomPlayer => 'Appuyez pour choisir un joueur au hasard';

  @override
  String get diceRolled => 'Dés Lancés ! 🎲';

  @override
  String get startingPlayerIs => 'Le joueur qui commence est :';

  @override
  String get addPlayersWarning => 'Ajoutez des joueurs d\'abord !';

  @override
  String get editProfile => 'Modifier le Profil';

  @override
  String get addFriend => 'Ajouter un Ami';

  @override
  String get requestSent => 'Demande Envoyée';

  @override
  String get friendsButton => 'Amis';

  @override
  String get winsLabel => 'Victoires';

  @override
  String get winRateLabel => 'Taux de Victoire';

  @override
  String get achievementsLabel => 'Succès';

  @override
  String get badgesSubtitle => 'Badges et jalons';

  @override
  String get myCollection => 'Ma Collection';

  @override
  String gamesCount(Object count) {
    return '$count jeux';
  }

  @override
  String get matchHistory => 'Historique des Jeux';

  @override
  String matchesPlayed(Object count) {
    return '$count matchs joués';
  }

  @override
  String levelLabel(Object level) {
    return 'NIVEAU $level';
  }

  @override
  String xpLabel(Object current, Object total) {
    return '$current / $total XP';
  }

  @override
  String get prestigeReset => 'RÉINITIALISATION PRESTIGE';

  @override
  String get prestigeAscension => '🌟 Ascension de Prestige 🌟';

  @override
  String get prestigeWarning =>
      'Êtes-vous sûr ? Cela RÉINITIALISERA votre niveau à 1, mais vous gagnerez une ÉTOILE DE PRESTIGE et la gloire éternelle.';

  @override
  String get ascendButton => 'ASCENSION';

  @override
  String get historyYear => 'Année';

  @override
  String get historyMonth => 'Mois';

  @override
  String get historyNoMatches => 'Aucune partie trouvée pour ce filtre.';

  @override
  String get unlockedLabel => 'Débloqué';

  @override
  String get lockedLabel => 'Verrouillé';

  @override
  String unlockedOnDate(Object date) {
    return 'Débloqué le $date';
  }

  @override
  String get closeButton => 'Fermer';

  @override
  String get myWishlistTitle => 'Ma Liste d\'Envies';

  @override
  String get emptyWishlist => 'Votre liste d\'envies est vide';

  @override
  String get exploreToAddToWishlist => 'Explorez des jeux pour les ajouter ici';

  @override
  String removedFromWishlist(Object game) {
    return '$game retiré de la liste';
  }

  @override
  String get emptyCollection => 'Votre collection est vide';

  @override
  String get exploreToAddToCollection =>
      'Marquez des jeux comme possédés pour les voir ici';

  @override
  String removedFromCollection(Object game) {
    return '$game retiré de la collection';
  }

  @override
  String get myFriendsTab => 'Mes Amis';

  @override
  String get friendRequestsTab => 'Demandes';

  @override
  String friendRequestsCount(Object count) {
    return 'Demandes ($count)';
  }

  @override
  String acceptedFriendRequest(Object user) {
    return 'Demande de $user acceptée (+10 XP)';
  }

  @override
  String get noFriendsYet => 'Aucun ami pour le moment';

  @override
  String get findFriendsButton => 'Trouver des amis';

  @override
  String get noPendingRequests => 'Aucune demande en attente';

  @override
  String get sentFriendRequest => 'Vous a envoyé une demande';

  @override
  String rankReachLevel(Object level) {
    return 'Reach Level $level';
  }

  @override
  String get achFirstMatchTitle => 'Premiers Pas';

  @override
  String get achFirstMatchDesc => 'Enregistrez votre première partie.';

  @override
  String get achFirstWinTitle => 'Champion';

  @override
  String get achFirstWinDesc => 'Gagnez votre première partie compétitive.';

  @override
  String get achVeteranTitle => 'Vétéran';

  @override
  String get achVeteranDesc => 'Jouez 100 parties.';

  @override
  String get achSocialTitle => 'Papillon Social';

  @override
  String get achSocialDesc => 'Ajoutez 5 amis.';

  @override
  String friendsCount(Object count) {
    return '$count amis';
  }

  @override
  String get appearanceLabel => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get lastNameLabel => 'Nom';

  @override
  String get phoneNumberLabel => 'Téléphone';

  @override
  String get countryLabel => 'Pays';

  @override
  String get selectBirthDateLabel => 'Date de Naissance';

  @override
  String locationUpdated(Object lat, Object lng) {
    return 'Localisation: $lat, $lng';
  }

  @override
  String locationCurrent(Object lat, Object lng) {
    return 'Actuel: $lat, $lng';
  }

  @override
  String get updateLocationLabel => 'Mettre à jour la localisation';

  @override
  String get saveChangesButton => 'Enregistrer';

  @override
  String get profileUpdatedSuccess => 'Profil mis à jour';

  @override
  String profileUpdatedError(Object error) {
    return 'Erreur de mise à jour: $error';
  }

  @override
  String get locationDisabled => 'Localisation désactivée.';

  @override
  String get locationDenied => 'Permissions de localisation refusées';

  @override
  String get locationPermDenied => 'Permissions refusées.';

  @override
  String get locationUpdateSuccess => 'Localisation à jour ! Enregistrez.';

  @override
  String locationUpdateError(Object error) {
    return 'Erreur de localisation: $error';
  }

  @override
  String get imageUploaded => 'Image téléchargée !';

  @override
  String imageUploadFailed(Object error) {
    return 'Échec: $error';
  }

  @override
  String get lvl0Title => 'Non classé';

  @override
  String get lvl1Title => 'Recrue de Plateau';

  @override
  String get lvl2Title => 'Jeteur de Dés';

  @override
  String get lvl3Title => 'Acheteur de Cartes';

  @override
  String get lvl4Title => 'Spécialiste de Mise en Place';

  @override
  String get lvl5Title => 'Lecteur de Règles';

  @override
  String get lvl6Title => 'Pousseur de Meeples';

  @override
  String get lvl7Title => 'Garde-Jetons';

  @override
  String get lvl8Title => 'Explorateur de Mécaniques';

  @override
  String get lvl9Title => 'Joueur Débutant';

  @override
  String get lvl10Title => 'Baron du Carton';

  @override
  String get lvl11Title => 'Chasseur de Combos';

  @override
  String get lvl12Title => 'Défenseur de Protèges-Cartes';

  @override
  String get lvl13Title => 'Organisateur de Boîtes';

  @override
  String get lvl14Title => 'Compteur de Points';

  @override
  String get lvl15Title => 'Stratège du Mardi';

  @override
  String get lvl16Title => 'Champion du Départage';

  @override
  String get lvl17Title => 'Mage du Deckbuilding';

  @override
  String get lvl18Title => 'Victime de Paralysie d\'Analyse';

  @override
  String get lvl19Title => 'Roi du Bluff';

  @override
  String get lvl20Title => 'Titan du Score';

  @override
  String get lvl21Title => 'Spécialiste de la Pose d\'Ouvriers';

  @override
  String get lvl22Title => 'Dominateur de Territoire';

  @override
  String get lvl23Title => 'Général de Contrôle de Zone';

  @override
  String get lvl24Title => 'Optimiseur de Tours';

  @override
  String get lvl25Title => 'Briseur de Règles';

  @override
  String get lvl26Title => 'Punisseur de Faiseur de Rois';

  @override
  String get lvl27Title => 'Mathématicien de Plateau';

  @override
  String get lvl28Title => 'Empereur de l\'Eurogame';

  @override
  String get lvl29Title => 'Légende de l\'Ameritrash';

  @override
  String get lvl30Title => 'Architecte de Plateau';

  @override
  String get lvl31Title => 'Expert en Extensions';

  @override
  String get lvl32Title => 'Peintre de Figurines';

  @override
  String get lvl33Title => 'Soutien Kickstarter';

  @override
  String get lvl34Title => 'Chasseur de Promos';

  @override
  String get lvl35Title => 'Conservateur d\'Étagère';

  @override
  String get lvl36Title => 'Propriétaire d\'Étagère de la Honte';

  @override
  String get lvl37Title => 'Oracle du Financement';

  @override
  String get lvl38Title => 'Collectionneur de Campagnes';

  @override
  String get lvl39Title => 'Monarque de la Collection';

  @override
  String get lvl40Title => 'Le Complétiste';

  @override
  String get lvl41Title => 'Bêta-Testeur Sacré';

  @override
  String get lvl42Title => 'Créateur de Tactiques Obscures';

  @override
  String get lvl43Title => 'Encyclopédie de Règles';

  @override
  String get lvl44Title => 'Arbitre Impartial';

  @override
  String get lvl45Title => 'Sage du Plateau';

  @override
  String get lvl46Title => 'Voyant des Déplacements';

  @override
  String get lvl47Title => 'Hôte Suprême';

  @override
  String get lvl48Title => 'Designer de l\'Ombre';

  @override
  String get lvl49Title => 'Meeple Doré Incarné';

  @override
  String get lvl50Title => 'Divinité des Pièces en Bois';
}
