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
}
