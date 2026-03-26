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
  String get seeDetails => 'Detalhar';

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

  @override
  String get unlockedLabel => 'Desbloqueado';

  @override
  String get lockedLabel => 'Bloqueado';

  @override
  String unlockedOnDate(Object date) {
    return 'Desbloqueado em $date';
  }

  @override
  String get closeButton => 'Fechar';

  @override
  String get myWishlistTitle => 'Minha Lista de Desejos';

  @override
  String get emptyWishlist => 'Sua lista de desejos está vazia';

  @override
  String get exploreToAddToWishlist => 'Explore jogos para adicioná-los aqui';

  @override
  String removedFromWishlist(Object game) {
    return '$game removido da lista de desejos';
  }

  @override
  String get emptyCollection => 'Sua coleção está vazia';

  @override
  String get exploreToAddToCollection =>
      'Marque jogos como adquiridos para vê-los aqui';

  @override
  String removedFromCollection(Object game) {
    return '$game removido da coleção';
  }

  @override
  String get myFriendsTab => 'Meus Amigos';

  @override
  String get friendRequestsTab => 'Solicitações';

  @override
  String friendRequestsCount(Object count) {
    return 'Solicitações ($count)';
  }

  @override
  String acceptedFriendRequest(Object user) {
    return 'Solicitação de $user aceita (+10 XP)';
  }

  @override
  String get noFriendsYet => 'Nenhum amigo ainda';

  @override
  String get findFriendsButton => 'Encontrar Amigos';

  @override
  String get noPendingRequests => 'Nenhuma solicitação pendente';

  @override
  String get sentFriendRequest => 'Te enviou uma solicitação de amizade';

  @override
  String rankReachLevel(Object level) {
    return 'Atingir Nível $level';
  }

  @override
  String get achFirstMatchTitle => 'Primeiros Passos';

  @override
  String get achFirstMatchDesc =>
      'Registre o resultado da sua primeira partida.';

  @override
  String get achFirstWinTitle => 'Campeão';

  @override
  String get achFirstWinDesc => 'Vença sua primeira partida competitiva.';

  @override
  String get achVeteranTitle => 'Veterano';

  @override
  String get achVeteranDesc => 'Jogue 100 partidas.';

  @override
  String get achSocialTitle => 'Borboleta Social';

  @override
  String get achSocialDesc => 'Adicione 5 amigos.';

  @override
  String friendsCount(Object count) {
    return '$count amigos';
  }

  @override
  String get appearanceLabel => 'Aparência';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get firstNameLabel => 'Nome';

  @override
  String get lastNameLabel => 'Sobrenome';

  @override
  String get phoneNumberLabel => 'Telefone';

  @override
  String get countryLabel => 'País';

  @override
  String get selectBirthDateLabel => 'Selecionar Data Nascimento';

  @override
  String locationUpdated(Object lat, Object lng) {
    return 'Localização Atualizada: $lat, $lng';
  }

  @override
  String locationCurrent(Object lat, Object lng) {
    return 'Atual: $lat, $lng';
  }

  @override
  String get updateLocationLabel => 'Atualizar Local (Toque para buscar)';

  @override
  String get saveChangesButton => 'Salvar Alterações';

  @override
  String get profileUpdatedSuccess => 'Perfil atualizado com sucesso';

  @override
  String profileUpdatedError(Object error) {
    return 'Erro ao atualizar perfil: $error';
  }

  @override
  String get locationDisabled => 'Serviços de localização desativados.';

  @override
  String get locationDenied => 'Permissões de localização negadas';

  @override
  String get locationPermDenied =>
      'Permissões de localização foram negadas permanentemente.';

  @override
  String get locationUpdateSuccess =>
      'Localização atualizada! Pressione Salvar.';

  @override
  String locationUpdateError(Object error) {
    return 'Erro ao obter localização: $error';
  }

  @override
  String get imageUploaded => 'Imagem enviada com sucesso!';

  @override
  String imageUploadFailed(Object error) {
    return 'Falhou ao enviar imagem: $error';
  }

  @override
  String get lvl0Title => 'Novato';

  @override
  String get lvl1Title => 'Recruta do Tabuleiro';

  @override
  String get lvl2Title => 'Rolador de Dados';

  @override
  String get lvl3Title => 'Comprador de Cartas';

  @override
  String get lvl4Title => 'Especialista no Setup';

  @override
  String get lvl5Title => 'Leitor de Manuais';

  @override
  String get lvl6Title => 'Movimentador de Meeples';

  @override
  String get lvl7Title => 'Guarda-Fichas';

  @override
  String get lvl8Title => 'Explorador de Mecânicas';

  @override
  String get lvl9Title => 'Jogador de Gateway';

  @override
  String get lvl10Title => 'O Barão do Papelão';

  @override
  String get lvl11Title => 'Caçador de Combos';

  @override
  String get lvl12Title => 'Defensor do Sleeves';

  @override
  String get lvl13Title => 'Organizador de Caixas';

  @override
  String get lvl14Title => 'Contador de Pontos';

  @override
  String get lvl15Title => 'Estrategista de Terça-Feira';

  @override
  String get lvl16Title => 'Campeão do Desempate';

  @override
  String get lvl17Title => 'Mago do Deckbuilding';

  @override
  String get lvl18Title => 'Vítima da Paralisia de Análise';

  @override
  String get lvl19Title => 'Rei do Blefe';

  @override
  String get lvl20Title => 'Titã da Pontuação';

  @override
  String get lvl21Title => 'Especialista em Alocação';

  @override
  String get lvl22Title => 'Dominador de Territórios';

  @override
  String get lvl23Title => 'General do Controle de Área';

  @override
  String get lvl24Title => 'Otimizador de Turnos';

  @override
  String get lvl25Title => 'Quebrador de Regra Mestre';

  @override
  String get lvl26Title => 'Punidor de Kingmakers';

  @override
  String get lvl27Title => 'Matemático do Tabuleiro';

  @override
  String get lvl28Title => 'Imperador do Eurogame';

  @override
  String get lvl29Title => 'Lenda do Ameritrash';

  @override
  String get lvl30Title => 'Arquiteto do Tabuleiro';

  @override
  String get lvl31Title => 'Especialista em Expansões';

  @override
  String get lvl32Title => 'Pintor de Miniaturas';

  @override
  String get lvl33Title => 'Apoiador do Kickstarter';

  @override
  String get lvl34Title => 'Caçador de Exclusividades';

  @override
  String get lvl35Title => 'Curador da Estante';

  @override
  String get lvl36Title => 'Dono da Prateleira da Vergonha';

  @override
  String get lvl37Title => 'Oráculo do Financiamento';

  @override
  String get lvl38Title => 'Acumulador de Campanhas';

  @override
  String get lvl39Title => 'Monarca da Coleção';

  @override
  String get lvl40Title => 'O Completista Absoluto';

  @override
  String get lvl41Title => 'Beta Tester Sagrado';

  @override
  String get lvl42Title => 'Criador de Táticas Obscuras';

  @override
  String get lvl43Title => 'Enciclopédia de Regras';

  @override
  String get lvl44Title => 'Árbitro Imparcial';

  @override
  String get lvl45Title => 'Sábio do Tabuleiro';

  @override
  String get lvl46Title => 'Vidente das Jogadas';

  @override
  String get lvl47Title => 'Host Supremo';

  @override
  String get lvl48Title => 'O Designer de Sombras';

  @override
  String get lvl49Title => 'O Meeple Dourado Encarnado';

  @override
  String get lvl50Title => 'Divindade das Peças de Madeira';

  @override
  String get reviewGame => 'Avaliar Jogo';

  @override
  String get rateThisGame => 'Dê sua nota:';

  @override
  String get communityReviews => 'Avaliações da Comunidade';

  @override
  String ratingsCount(Object count) {
    return '$count Avaliações';
  }

  @override
  String get reviewHint => 'Escreva seu comentário (Opcional)...';

  @override
  String get submitReview => 'Enviar Avaliação';

  @override
  String get syncCompleted => 'Sincronização concluída';

  @override
  String get recordMatch => 'Registrar Partida';

  @override
  String get notifications => 'Notificações';

  @override
  String get noNotifications => 'Nenhuma notificação';

  @override
  String get notifLevelUpTitle => 'Nível Subiu!';

  @override
  String notifLevelUpMsg(Object level, Object rank) {
    return 'Você alcançou o Nível $level: $rank!';
  }

  @override
  String get notifAchievementTitle => 'Conquista Desbloqueada!';

  @override
  String notifAchievementMsg(Object title) {
    return 'Você desbloqueou: $title';
  }

  @override
  String get notifPrestigeTitle => 'PRESTÍGIO DESBLOQUEADO! ⭐';

  @override
  String get notifPrestigeMsg =>
      'Você ascendeu! Seu nível foi resetado, mas sua glória cresce.';

  @override
  String get notifFriendRequestTitle => 'Novo Pedido de Amizade';

  @override
  String notifFriendRequestMsg(Object name) {
    return '$name quer ser seu amigo!';
  }

  @override
  String get notifMatchVictoryTitle => 'VITÓRIA!';

  @override
  String get notifMatchVictoryMsg => 'Resultado da partida: VITÓRIA!';

  @override
  String get notifMatchDefeatTitle => 'DERROTA';

  @override
  String get notifMatchDefeatMsg => 'Resultado da partida: DERROTA';

  @override
  String get categoriesLabel => 'CATEGORIAS';

  @override
  String get mechanicsLabel => 'MECÂNICAS';

  @override
  String get bggRatingLabel => 'BGG RATING';

  @override
  String get timeLabel => 'TEMPO';

  @override
  String get playersLabel => 'JOGADORES';

  @override
  String get aboutThisGame => 'Sobre este Jogo';

  @override
  String get classificationLabel => 'Classificação';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get familyLabel => 'Família';

  @override
  String get integrationsLabel => 'Integrações';

  @override
  String get reimplementsLabel => 'Reimplementa';

  @override
  String get translate => 'Traduzir para Português';

  @override
  String get showOriginal => 'Ver Original';

  @override
  String get premiumTitle => 'MeepleSync Premium';

  @override
  String get premiumSubtitle =>
      'Eleve sua experiência de jogo ao próximo nível.';

  @override
  String get premiumFeature1Title => 'Partidas Ilimitadas';

  @override
  String get premiumFeature1Desc =>
      'Registre todas as suas partidas sem restrições.';

  @override
  String get premiumFeature2Title => 'Estatísticas Avançadas';

  @override
  String get premiumFeature2Desc => 'Gráficos detalhados do seu desempenho.';

  @override
  String get premiumFeature3Title => 'Sincronização Prioritária';

  @override
  String get premiumFeature3Desc =>
      'Seus dados sempre salvos e seguros na nuvem.';

  @override
  String get premiumMonthlyPlan => 'Plano Mensal';

  @override
  String get premiumAnnualPlan => 'Plano Anual';

  @override
  String get premiumMonthlyPrice => 'R\$ 9,90 / mês';

  @override
  String get premiumAnnualPrice => 'R\$ 79,90 / ano';

  @override
  String get premiumMonthlyDesc => 'Ideal para quem joga ocasionalmente.';

  @override
  String get premiumAnnualDesc => 'Economize 33% e apoie o projeto!';

  @override
  String get premiumBestValue => 'MELHOR VALOR';

  @override
  String get premiumSubscribeButton => 'Assinar Agora';

  @override
  String get registrationEmailConfirmation =>
      'Por favor, confirme sua conta no e-mail informado.';

  @override
  String get matchLimitTitle => 'Limite de Partidas Atingido';

  @override
  String get matchLimitMessage =>
      'Você pode participar de apenas 5 partidas com uma conta gratuita. Assine o Pro para registrar mais!';

  @override
  String matchLimitFriendMessage(Object username) {
    return '$username atingiu o limite de partidas gratuitas e não pode ser adicionado.';
  }

  @override
  String get upgradeNow => 'Assinar Agora';
}
