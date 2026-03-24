// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginTitle => 'Bem-vindo de volta';

  @override
  String get loginSubtitle =>
      'Entre para continuar sua jornada de jogos de tabuleiro';

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String get loginButton => 'Entrar';

  @override
  String get registerText => 'Não tem uma conta? Cadastre-se';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get themeLabel => 'Tema';

  @override
  String get logoutButton => 'Sair';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get collectionTitle => 'Coleção';

  @override
  String get matchesTitle => 'Partidas';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Adicionar';

  @override
  String get search => 'Pesquisar';

  @override
  String get loading => 'Carregando...';

  @override
  String get ok => 'OK';

  @override
  String error(Object error) {
    return 'Erro: $error';
  }

  @override
  String get welcomeBack => 'Bem-vindo de volta,';

  @override
  String get trendingGames => 'Jogos em Alta';

  @override
  String get seeAll => 'Ver Todos';

  @override
  String get noTrendingGames => 'Sem Tendências Ainda';

  @override
  String get noTrendingSubtitle =>
      'Jogue partidas para ver o que está em alta no seu grupo.';

  @override
  String get startMatch => 'Iniciar Partida';

  @override
  String get recommendedForYou => 'Recomendado para Você';

  @override
  String get needMoreData => 'Preciso de Mais Dados';

  @override
  String get needMoreDataSubtitle =>
      'Jogue e avalie jogos para obter recomendações personalizadas.';

  @override
  String get exploreGamesButton => 'Explorar Jogos';

  @override
  String playersCount(Object max, Object min) {
    return '$min-$max jogadores';
  }

  @override
  String rankLabel(Object rank) {
    return '(Rank #$rank)';
  }

  @override
  String get exploreTitle => 'Explorar Jogos';

  @override
  String get searchPlaceholder => 'Pesquisar jogos de tabuleiro...';

  @override
  String get emptySearchTitle => 'Pesquise seus jogos favoritos';

  @override
  String get emptySearchSubtitle =>
      'Digite o nome de um jogo para começar a explorar';

  @override
  String get noResults => 'Nenhum jogo encontrado';

  @override
  String get noResultsSubtitle =>
      'Tente pesquisar com palavras-chave diferentes';

  @override
  String get enrichDatabase => 'Enriquecer Banco de Dados';

  @override
  String get enrichConfirmation =>
      'Isso buscará detalhes de TODOS os jogos do BoardGameGeek. Isso pode levar muito tempo.\n\nContinuar?';

  @override
  String get newMatchTitle => 'Nova Partida';

  @override
  String get selectGameLabel => 'Selecione um Jogo';

  @override
  String get gameLabel => 'Jogo';

  @override
  String get scoringMode => 'Modo de Pontuação';

  @override
  String get competitive => 'Competitivo';

  @override
  String get cooperative => 'Cooperativo';

  @override
  String get whoIsPlaying => 'Quem está jogando?';

  @override
  String get whoStarts => 'Quem começa?';

  @override
  String get diceSubtitle => 'Não discuta, deixe o dado decidir seu destino.';

  @override
  String get rollButton => 'ROLAR';

  @override
  String get pickRandomPlayer => 'Toque para escolher um jogador aleatório';

  @override
  String get diceRolled => 'Dado Rolado! 🎲';

  @override
  String get startingPlayerIs => 'O jogador inicial é:';

  @override
  String get addPlayersWarning => 'Adicione jogadores primeiro!';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get addFriend => 'Adicionar Amigo';

  @override
  String get requestSent => 'Solicitação Enviada';

  @override
  String get friendsButton => 'Amigos';

  @override
  String get winsLabel => 'Vitórias';

  @override
  String get winRateLabel => 'Taxa de Vitória';

  @override
  String get achievementsLabel => 'Conquistas';

  @override
  String get badgesSubtitle => 'Medalhas e marcos';

  @override
  String get myCollection => 'Minha Coleção';

  @override
  String gamesCount(Object count) {
    return '$count jogos';
  }

  @override
  String get matchHistory => 'Histórico de Jogos';

  @override
  String matchesPlayed(Object count) {
    return '$count partidas jogadas';
  }

  @override
  String levelLabel(Object level) {
    return 'NÍVEL $level';
  }

  @override
  String xpLabel(Object current, Object total) {
    return '$current / $total XP';
  }

  @override
  String get prestigeReset => 'RESET DE PRESTÍGIO';

  @override
  String get prestigeAscension => '🌟 Ascensão de Prestígio 🌟';

  @override
  String get prestigeWarning =>
      'Tem certeza? Isso irá REINICIAR seu nível para 1, mas você ganhará uma ESTRELA DE PRESTÍGIO e glória eterna.';

  @override
  String get ascendButton => 'ASCENDER';

  @override
  String get historyYear => 'Ano';

  @override
  String get historyMonth => 'Mês';

  @override
  String get historyNoMatches => 'Nenhuma partida encontrada para este filtro.';
}
