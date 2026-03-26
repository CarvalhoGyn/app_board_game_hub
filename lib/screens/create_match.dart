import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'record_match_score.dart';
import 'package:drift/drift.dart' as drift;
import '../providers/user_session.dart';
import 'profile_dashboard.dart';
import 'game_catalog.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import '../services/supabase_sync_service.dart';
import '../services/games_repository.dart';
import 'paywall_screen.dart';
import '../services/subscription_service.dart';

class CreateMatch extends StatefulWidget {
  final Game? initialGame;
  const CreateMatch({super.key, this.initialGame});

  @override
  State<CreateMatch> createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final _gameController = TextEditingController(text: 'Catan');
  final _dateController = TextEditingController(text: 'Today');
  
  List<Game> _availableGames = [];
  Game? _selectedGame;
  List<User> _selectedPlayers = [];

  User? _startingPlayer;
  String _scoringType = 'competitive';

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    final gamesDao = context.read<GamesDao>();
    final games = await gamesDao.getAllGames();
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;

    if (mounted) {
      setState(() {
        _availableGames = games;
        _availableGames = games;
        if (widget.initialGame != null) {
          _selectedGame = widget.initialGame;
          // Auto-detect scoring type
          if (widget.initialGame!.mechanics?.toLowerCase().contains('cooperative') == true || 
              widget.initialGame!.mechanics?.toLowerCase().contains('co-op') == true) {
            _scoringType = 'cooperative';
          }
        } else if (games.isNotEmpty) {
          _selectedGame = games.first;
        }
        if (currentUser != null) {
          _selectedPlayers = [currentUser];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: _buildAppBar(context, theme, l10n),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGameSelector(theme, l10n),
              const SizedBox(height: 16),
              if (_selectedGame != null) _buildScoringModeSelector(theme, l10n),
              const SizedBox(height: 8),
              _buildPlayersSection(theme, l10n),
              const SizedBox(height: 24),
              _buildRandomizerSection(theme, l10n),
              const SizedBox(height: 100), // Space for sticky bottom button
            ],
          ),
        ),
      ),
      bottomSheet: _buildStickyFooter(context, theme, l10n),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
      elevation: 0,
      leadingWidth: 100, // Increased to accommodate German "Abbrechen"
      leading: TextButton(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameCatalog()));
          }
        },
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(l10n.cancel, style: TextStyle(color: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ),
      title: Text(l10n.newMatchTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      centerTitle: true,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
    );
  }

  Widget _buildGameSelector(ThemeData theme, AppLocalizations l10n) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.gameLabel, style: TextStyle(color: mutedColor, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => _GameSearchSheet(
                onGameSelected: (game) {
                  setState(() {
                    _selectedGame = game;
                    // Auto-detect cooperative
                    if (game.mechanics?.toLowerCase().contains('cooperative') == true || 
                        game.mechanics?.toLowerCase().contains('co-op') == true) {
                      _scoringType = 'cooperative';
                    } else {
                      _scoringType = 'competitive';
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _selectedGame?.imageUrl != null
                      ? Image.network(
                          _selectedGame!.imageUrl!,
                          height: 64, width: 64, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(height: 64, width: 64, color: Colors.grey),
                        )
                      : Container(
                          height: 64, width: 64,
                          color: theme.colorScheme.surface,
                          child: Icon(Icons.videogame_asset, color: mutedColor),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SELECTED', style: TextStyle(color: theme.primaryColor, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      Text(
                        _selectedGame?.name ?? l10n.selectGameLabel,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: theme.colorScheme.onSurface.withOpacity(0.05), shape: BoxShape.circle),
                  child: Icon(Icons.search, color: mutedColor, size: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildScoringModeSelector(ThemeData theme, AppLocalizations l10n) {
     return Container(
       margin: const EdgeInsets.only(bottom: 24),
       padding: const EdgeInsets.all(4),
       decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
       ),
       child: Row(
          children: [
             Expanded(child: _buildModeOption(l10n.competitive, 'competitive', Icons.emoji_events, theme)),
             Expanded(child: _buildModeOption(l10n.cooperative, 'cooperative', Icons.group_work, theme)),
          ],
       ),
    );
  }

  Widget _buildModeOption(String label, String value, IconData icon, ThemeData theme) {
     final isSelected = _scoringType == value;
     final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
     return GestureDetector(
        onTap: () => setState(() => _scoringType = value),
        child: Container(
           padding: const EdgeInsets.symmetric(vertical: 12),
           decoration: BoxDecoration(
              color: isSelected ? theme.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
           ),
           child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(icon, color: isSelected ? theme.colorScheme.onPrimary : mutedColor, size: 18),
                 const SizedBox(width: 8),
                 Text(label, style: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : mutedColor,
                    fontWeight: FontWeight.bold,
                 )),
              ],
           ),
        ),
     );
  }

  void _showAddPlayerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UserSearchSheet(
        onUserSelected: (user) async {
          if (!_selectedPlayers.any((p) => p.id == user.id)) {
             // Validate Friend Limit (Supabase Global Check)
             final subscriptionService = context.read<SubscriptionService>();
             final usersDao = context.read<UsersDao>();
             final matchesDao = context.read<MatchesDao>();
             final syncService = context.read<SupabaseSyncService>();
             
             // Show subtle loader if needed, or just block
             final canJoin = await subscriptionService.canParticipateInMatch(
                userId: user.id,
                usersDao: usersDao,
                matchesDao: matchesDao,
                syncService: syncService,
             );

             if (!canJoin) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.matchLimitFriendMessage(user.username)),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
             }

            setState(() {
              _selectedPlayers.add(user);
            });
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildPlayersSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.whoIsPlaying, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Text('${_selectedPlayers.length}', style: TextStyle(color: theme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedPlayers.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: _showAddPlayerModal,
                  child: _buildAddPlayerButton(theme, l10n),
                );
              }
              final user = _selectedPlayers[index - 1];
              // Assuming first player in list is 'You' for now, or check ID
              final isYou = context.read<UserSession>().currentUser?.id == user.id;
              
                return GestureDetector(
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDashboard(userId: user.id)));
                   },
                   child: _buildPlayerItem(
                    user.username,
                    user.avatarUrl ?? 'https://i.pravatar.cc/150?u=${user.id}',
                    theme,
                    isYou: isYou,
                    isStarting: _startingPlayer?.id == user.id,
                  ),
                );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddPlayerButton(ThemeData theme, AppLocalizations l10n) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Column(
      children: [
        Container(
          height: 64, width: 64,
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), style: BorderStyle.none),
          ),
          child: Icon(Icons.add, color: mutedColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(l10n.add, style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPlayerItem(String name, String url, ThemeData theme, {bool isYou = false, bool isStarting = false}) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 64, width: 64,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                border: Border.all(
                  color: isStarting ? Colors.orange : (isYou ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.1)), 
                  width: isStarting ? 3 : 2
                )
              ),
              child: CircleAvatar(
                backgroundImage: url.startsWith('http') 
                    ? NetworkImage(url) 
                    : (File(url).existsSync() ? FileImage(File(url)) as ImageProvider : const NetworkImage('https://i.pravatar.cc/150')),
              ),
            ),
            if (isYou)
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: theme.scaffoldBackgroundColor, width: 2)),
                  child: Text('YOU', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ),
            if (isStarting)
               Positioned(
                 top: -8, right: 0,
                 child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    child: const Icon(Icons.star, color: Colors.white, size: 10),
                 ),
               ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: TextStyle(color: isStarting ? Colors.orange : (isYou ? theme.colorScheme.onSurface : mutedColor), fontSize: 12, fontWeight: isStarting ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  void _rollDice(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addPlayersWarning)));
      return;
    }
    
    final random = Random();
    final winnerIndex = random.nextInt(_selectedPlayers.length);
    final winner = _selectedPlayers[winnerIndex];
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    setState(() {
       _startingPlayer = winner;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(l10n.diceRolled, style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.startingPlayerIs, style: TextStyle(color: mutedColor)),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 32,
              backgroundImage: winner.avatarUrl != null 
                  ? (winner.avatarUrl!.startsWith('http') 
                      ? NetworkImage(winner.avatarUrl!) 
                      : (File(winner.avatarUrl!).existsSync() ? FileImage(File(winner.avatarUrl!)) as ImageProvider : null))
                  : null,
              backgroundColor: theme.colorScheme.surface,
              child: winner.avatarUrl == null ? Text(winner.username[0].toUpperCase(), style: const TextStyle(fontSize: 24)) : null, 
            ),
            const SizedBox(height: 8),
            Text(winner.username, style: TextStyle(color: theme.primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomizerSection(ThemeData theme, AppLocalizations l10n) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return GestureDetector(
      onTap: () => _rollDice(theme),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.whoStarts, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text(l10n.diceSubtitle, style: TextStyle(color: mutedColor, fontSize: 14)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 56, width: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFEA580C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.casino, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.rollButton, style: TextStyle(color: theme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, color: mutedColor, size: 16),
                const SizedBox(width: 8),
                Text(l10n.pickRandomPlayer, style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStickyFooter(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ElevatedButton(
        onPressed: () async {
          if (_selectedGame == null) return;

          final userSession = context.read<UserSession>();
          final matchesDao = context.read<MatchesDao>();
          final currentUser = userSession.currentUser;

          // MATCH LIMIT GUARD (MeepleSync Pro - Limit 5 Participation)
          if (!userSession.isPremium && currentUser != null) {
            final subService = context.read<SubscriptionService>();
            final usersDao = context.read<UsersDao>();
            final syncService = context.read<SupabaseSyncService>();

            final canProceed = await subService.canParticipateInMatch(
              userId: currentUser.id,
              usersDao: usersDao,
              matchesDao: matchesDao,
              syncService: syncService,
            );

            if (!canProceed) {
               if (!mounted) return;
               Navigator.push(context, MaterialPageRoute(builder: (context) => const PaywallScreen()));
               return;
            }
          }

          // Show loading
          showDialog(
             context: context,
             barrierDismissible: false,
             builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          try {
            final service = context.read<SupabaseSyncService>();
            
            // Validate IDs
            for (var p in _selectedPlayers) {
              if (p.id.isEmpty) {
                 Navigator.pop(context); // Dismiss loading
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Error: One or more players have an invalid ID.'), backgroundColor: Colors.redAccent),
                 );
                 return;
              }
            }

            // Online-First Match Creation
            final newMatchId = await service.createMatch(
              match: MatchesCompanion(
                gameId: drift.Value(_selectedGame!.id),
                date: drift.Value(DateTime.now()),
                location: const drift.Value(null),
                scoringType: drift.Value(_scoringType),
                creatorId: drift.Value(context.read<UserSession>().currentUser?.id),
              ),
              players: _selectedPlayers.map((u) {
                return PlayersCompanion(userId: drift.Value(u.id));
              }).toList(),
            );

            if (!mounted) return;
            Navigator.pop(context); // Dismiss loading

            if (newMatchId != null) {
               // Success
               context.read<SupabaseSyncService>().sync();
               Navigator.push(context, MaterialPageRoute(builder: (context) => RecordMatchScore(matchId: newMatchId)));
            } else {
               // Failure (null returned)
               // Note: createMatch returns null on error (or we could change it to return error string). 
               // Currently implemented to return null on catch.
               // Let's assume generic error if null.
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(l10n.error('Failed to create match online')), backgroundColor: Colors.redAccent),
               );
            }
          } catch (e) {
            if (!mounted) return;
            Navigator.pop(context); // Dismiss loading if error uncaught
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.error(e.toString())), backgroundColor: Colors.redAccent),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 8,
          shadowColor: theme.primaryColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.startMatch, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: theme.colorScheme.onPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _UserSearchSheet extends StatefulWidget {
  final Function(User) onUserSelected;

  const _UserSearchSheet({required this.onUserSelected});

  @override
  State<_UserSearchSheet> createState() => _UserSearchSheetState();
}

class _UserSearchSheetState extends State<_UserSearchSheet> {
  final _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;

  void _search(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => _users = []);
      return;
    }

    setState(() => _isLoading = true);
    final syncService = context.read<SupabaseSyncService>();
    final results = await syncService.searchGlobalUsers(query);
    
    if (mounted) {
      setState(() {
        _users = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: _search,
            autofocus: true,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: l10n.searchPlaceholder,
              hintStyle: TextStyle(color: mutedColor),
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor,
              prefixIcon: Icon(Icons.search, color: mutedColor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.surface,
                        backgroundImage: user.avatarUrl != null 
                            ? (user.avatarUrl!.startsWith('http') 
                                ? NetworkImage(user.avatarUrl!) 
                                : (File(user.avatarUrl!).existsSync() ? FileImage(File(user.avatarUrl!)) as ImageProvider : null))
                            : null,
                        child: user.avatarUrl == null ? Text(user.username.substring(0, 1).toUpperCase(), style: TextStyle(color: theme.primaryColor)) : null,
                      ),
                      title: Text(user.username, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      onTap: () => widget.onUserSelected(user),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}




// ... (Existing code)

class _GameSearchSheet extends StatefulWidget {
  final Function(Game) onGameSelected;

  const _GameSearchSheet({required this.onGameSelected});

  @override
  State<_GameSearchSheet> createState() => _GameSearchSheetState();
}

class _GameSearchSheetState extends State<_GameSearchSheet> {
  final _searchController = TextEditingController();
  late GamesRepository _repository;
  
  List<Game> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final dao = context.read<GamesDao>();
    _repository = GamesRepository(dao);
  }

  void _search(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    
    // Hybrid Search via Repository
    final results = await _repository.searchGames(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: _search,
            autofocus: true,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: l10n.searchPlaceholder,
              hintStyle: TextStyle(color: mutedColor),
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor,
              prefixIcon: Icon(Icons.search, color: mutedColor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.imageUrl != null 
                          ? Image.network(item.imageUrl!, width: 48, height: 48, fit: BoxFit.cover)
                          : Container(width: 48, height: 48, color: theme.colorScheme.surface, child: const Icon(Icons.videogame_asset)),
                      ),
                      title: Text(item.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.check_circle_outline, color: theme.primaryColor, size: 20),
                      onTap: () async {
                        // Cache and Select
                        await _repository.cacheGame(item);
                        widget.onGameSelected(item);
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
