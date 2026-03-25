import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../widgets/staggered_slide_fade.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import 'game_details.dart';

class TopGamesScreen extends StatefulWidget {
  const TopGamesScreen({super.key});

  @override
  State<TopGamesScreen> createState() => _TopGamesScreenState();
}

class _TopGamesScreenState extends State<TopGamesScreen> {
  bool _isLoading = true;
  List<GameStats> _stats = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final matchesDao = context.read<MatchesDao>();
    try {
      final results = await matchesDao.getTopPlayedGames(5);
      if (mounted) {
        setState(() {
          _stats = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading top games: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Top 5 Jogos', // We can add this to Arb later if needed
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stats.isEmpty
              ? _buildEmptyState(theme, l10n, mutedColor)
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: _stats.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final stat = _stats[index];
                    return StaggeredSlideFade(
                      index: index,
                      child: _buildStatCard(context, stat, index + 1, theme, mutedColor),
                    );
                  },
                ),
    );
  }

  Widget _buildStatCard(BuildContext context, GameStats stat, int rank, ThemeData theme, Color mutedColor) {
    final game = stat.game;
    
    // Medal colors
    Color medalColor;
    if (rank == 1) medalColor = const Color(0xFFFFD700); // Gold
    else if (rank == 2) medalColor = const Color(0xFFC0C0C0); // Silver
    else if (rank == 3) medalColor = const Color(0xFFCD7F32); // Bronze
    else medalColor = theme.primaryColor.withOpacity(0.5);

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GameDetails(game: game))),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game Image with Rank Badge
                Stack(
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(game.imageUrl ?? 'https://via.placeholder.com/100?text=${game.name}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: medalColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
                          ],
                        ),
                        child: Text(
                          '#$rank',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Game Stats Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildMiniStat(Icons.casino_outlined, '${stat.matchCount} partidas', theme),
                            const SizedBox(width: 16),
                            _buildMiniStat(Icons.people_outline, '${stat.totalPlayers} jogadores', theme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Arrow Icon
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right, color: mutedColor.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.primaryColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n, Color mutedColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.query_stats, size: 80, color: mutedColor.withOpacity(0.2)),
          const SizedBox(height: 24),
          Text(
            'Nenhuma partida registrada ainda.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Comece a jogar para ver as estatísticas!',
            style: TextStyle(color: mutedColor),
          ),
        ],
      ),
    );
  }
}
