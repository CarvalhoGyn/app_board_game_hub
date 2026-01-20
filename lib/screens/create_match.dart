import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'record_match_score.dart';
import 'package:drift/drift.dart' as drift;
import '../providers/user_session.dart';
import '../services/bgg_service.dart';
import 'profile_dashboard.dart';
import 'game_catalog.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({super.key});

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
        if (games.isNotEmpty) {
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
    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGameSelector(theme),
              const SizedBox(height: 16),
              if (_selectedGame != null) _buildScoringModeSelector(theme),
              const SizedBox(height: 8),
              _buildPlayersSection(theme),
              const SizedBox(height: 24),
              _buildRandomizerSection(theme),
              const SizedBox(height: 100), // Space for sticky bottom button
            ],
          ),
        ),
      ),
      bottomSheet: _buildStickyFooter(context, theme),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
      elevation: 0,
      leadingWidth: 80,
      leading: TextButton(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            // If we are at root (tab navigation), go to Home
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameCatalog()));
          }
        },
        child: Text('Cancel', style: TextStyle(color: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
      ),
      title: Text('New Match', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      centerTitle: true,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
    );
  }

  Widget _buildGameSelector(ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game', style: TextStyle(color: mutedColor, fontSize: 14, fontWeight: FontWeight.w600)),
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
                        _selectedGame?.name ?? 'Select a Game',
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


  Widget _buildScoringModeSelector(ThemeData theme) {
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
             Expanded(child: _buildModeOption('Competitive', 'competitive', Icons.emoji_events, theme)),
             Expanded(child: _buildModeOption('Cooperative', 'cooperative', Icons.group_work, theme)),
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
        onUserSelected: (user) {
          if (!_selectedPlayers.any((p) => p.id == user.id)) {
            setState(() {
              _selectedPlayers.add(user);
            });
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildPlayersSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Who's playing?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
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
                  child: _buildAddPlayerButton(theme),
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

  Widget _buildAddPlayerButton(ThemeData theme) {
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
        Text('Add', style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.w500)),
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
    if (_selectedPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add players first!')));
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
        title: Text('Dice Rolled! 🎲', style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('The starting player is:', style: TextStyle(color: mutedColor)),
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomizerSection(ThemeData theme) {
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
                      Text('Who starts?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text("Don't argue, let the dice decide your fate.", style: TextStyle(color: mutedColor, fontSize: 14)),
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
                    Text('ROLL', style: TextStyle(color: theme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
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
                Text('Tap to pick a random player', style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStickyFooter(BuildContext context, ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ElevatedButton(
        onPressed: () async {
          if (_selectedGame == null) return;

          final matchesDao = context.read<MatchesDao>();
          try {
            // Simplified match creation for now - using a hardcoded user ID for demonstration
            // In a real app, you'd get the current user's ID
            final matchId = await matchesDao.createMatch(
              MatchesCompanion(
                gameId: drift.Value(_selectedGame!.id),
                date: drift.Value(DateTime.now()),
                location: const drift.Value(null),
                scoringType: drift.Value(_scoringType),
                creatorId: drift.Value(context.read<UserSession>().currentUser?.id),
              ),
              _selectedPlayers.map((u) => PlayersCompanion(userId: drift.Value(u.id))).toList(),
            );

            if (!mounted) return;
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecordMatchScore(matchId: matchId)));
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error starting match: $e'), backgroundColor: Colors.redAccent),
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
            Text('Start Match', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
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
    final usersDao = context.read<UsersDao>();
    final results = await usersDao.searchUsersByNickname(query);
    
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
              hintText: 'Search player...',
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


class _GameSearchSheet extends StatefulWidget {
  final Function(Game) onGameSelected;

  const _GameSearchSheet({required this.onGameSelected});

  @override
  State<_GameSearchSheet> createState() => _GameSearchSheetState();
}

class _GameSearchSheetState extends State<_GameSearchSheet> {
  final _searchController = TextEditingController();
  final _bggService = BggService();
  
  List<dynamic> _searchResults = []; // Can be Game or BggSearchResult
  bool _isLoading = false;

  void _search(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    final gamesDao = context.read<GamesDao>();
    
    // Parallel search
    final localFuture = gamesDao.searchGames(query);
    final remoteFuture = query.length > 2 ? _bggService.searchGames(query) : Future.value(<BggSearchResult>[]);
    
    final results = await Future.wait([localFuture, remoteFuture]);
    final localGames = results[0] as List<Game>;
    final remoteGames = results[1] as List<BggSearchResult>;

    // Filter remote games that are already in local (by name or BGG ID logic if available, simple name check for now)
    final existingNames = localGames.map((g) => g.name.toLowerCase()).toSet();
    final newRemoteGames = remoteGames.where((r) => !existingNames.contains(r.name.toLowerCase())).toList();

    if (mounted) {
      setState(() {
        _searchResults = [...localGames, ...newRemoteGames];
        _isLoading = false;
      });
    }
  }

  Future<void> _importAndSelect(BggSearchResult result) async {
    setState(() => _isLoading = true);
    
    try {
      final details = await _bggService.fetchGameDetails(result.id);
      if (details != null) {
        final gamesDao = context.read<GamesDao>();
        // Check if exists by BGG ID
        final existing = await gamesDao.getGameByBggId(result.id);
        
        Game selectedGame;
        if (existing != null) {
          selectedGame = existing;
        } else {
          final id = await gamesDao.createGame(details);
          selectedGame = (await gamesDao.getGameById(id))!;
        }
        
        widget.onGameSelected(selectedGame); // Callback handles pop
      } else {
         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load game details')));
         setState(() => _isLoading = false);
      }
    } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
         setState(() => _isLoading = false);
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

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
              hintText: 'Search game...',
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
                    
                    if (item is Game) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.imageUrl != null 
                            ? Image.network(item.imageUrl!, width: 48, height: 48, fit: BoxFit.cover)
                            : Container(width: 48, height: 48, color: theme.colorScheme.surface, child: const Icon(Icons.videogame_asset)),
                        ),
                        title: Text(item.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.check_circle, color: theme.primaryColor, size: 16),
                        onTap: () => widget.onGameSelected(item),
                      );
                    } else if (item is BggSearchResult) {
                      return ListTile(
                        leading: Container(
                          width: 48, height: 48, 
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Icon(Icons.cloud_download, color: mutedColor, size: 20),
                        ),
                        title: Text(item.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                        subtitle: item.year != null ? Text(item.year!, style: theme.textTheme.bodySmall?.copyWith(color: mutedColor)) : null,
                        trailing: Icon(Icons.public, color: mutedColor, size: 16),
                        onTap: () => _importAndSelect(item),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
          ),
        ],
      ),
    );
  }
}
