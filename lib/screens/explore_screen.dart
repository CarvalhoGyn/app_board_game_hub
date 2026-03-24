import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'game_details.dart';
import '../widgets/shared_bottom_nav.dart';
import '../widgets/staggered_slide_fade.dart';
import '../services/games_repository.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Game> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;
  late GamesRepository _repository;

  @override
  void initState() {
    super.initState();
    // Initialize Repository
    final dao = context.read<GamesDao>();
    _repository = GamesRepository(dao);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    
    // Use Hybrid Search
    final results = await _repository.searchGames(query);
    
    if (!mounted) return;
    setState(() {
      _isSearching = true; 
      _searchResults = results;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(theme, l10n),
            _buildSearchBar(theme, l10n),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isSearching 
                    ? _buildSearchResults(theme, l10n) 
                    : _buildEmptyState(theme, l10n),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 1),
    );
  }

  // ... (Header and SearchBar omitted as they don't change much, but included in previous context)
  
  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.explore, color: theme.primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Text(
            l10n.exploreTitle,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          )),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, AppLocalizations l10n) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          autofocus: true,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
          decoration: InputDecoration(
            hintText: l10n.searchPlaceholder,
            hintStyle: TextStyle(color: mutedColor),
            prefixIcon: Icon(Icons.search, color: mutedColor, size: 24),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: Icon(Icons.clear, color: mutedColor),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 64,
              color: mutedColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.emptySearchTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.emptySearchSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: mutedColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme, AppLocalizations l10n) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: mutedColor),
            const SizedBox(height: 16),
            Text(
              l10n.noResults,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noResultsSubtitle,
              style: TextStyle(color: mutedColor),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final game = _searchResults[index];
        return StaggeredSlideFade(
          index: index,
          child: _buildGameCard(game, theme, l10n),
        );
      },
    );
  }

  Widget _buildGameCard(Game game, ThemeData theme, AppLocalizations l10n) {
    final rating = game.rating?.toStringAsFixed(1) ?? 'N/A';
    final players = game.minPlayers != null 
        ? l10n.playersCount(game.minPlayers!, game.maxPlayers!) 
        : 'Board Game';
    final time = game.maxPlaytime != null ? ' • ${game.maxPlaytime} min' : '';
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return GestureDetector(
      onTap: () async {
        // Cache the game locally when selected!
        // This ensures that if the user adds it to collection or logs a match,
        // the foreign key constraint (game_id) will be satisfied.
        await _repository.cacheGame(game);
        
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameDetails(game: game)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    game.imageUrl ?? 'https://via.placeholder.com/80?text=${game.name}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$players$time',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: theme.primaryColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (game.rank != null)
                        Text(
                          l10n.rankLabel(game.rank!),
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: mutedColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
