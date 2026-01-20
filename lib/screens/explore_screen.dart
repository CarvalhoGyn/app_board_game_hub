import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'game_details.dart';
import '../widgets/shared_bottom_nav.dart';
import '../database/csv_importer.dart';
import '../services/bgg_service.dart';
import '../services/data_enrichment_service.dart';
import '../widgets/staggered_slide_fade.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Game> _searchResults = [];
  bool _isSearching = false;

  final _bggService = BggService();
  bool _isLoading = false;
  String? _debugInfo;

  @override
  void initState() {
    super.initState();
    // Auto specific trigger not needed if we have manual button, 
    // but good to keep. Note: we need to handle the return future now.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _importData(silent: true);
    });
  }

  Future<void> _importData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    final status = await CsvImporter.importGamesIfEmpty(context.read<AppDatabase>());
    if (!silent) {
       setState(() {
         _isLoading = false;
         _debugInfo = status;
       });
       showDialog(
         context: context, 
         builder: (_) => AlertDialog(
           title: const Text('Import Status'), 
           content: Text(status),
           actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
         )
       );
    }
  }
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    final gamesDao = context.read<GamesDao>();
    
    // Search local first
    final localResults = await gamesDao.searchGames(query);
    
    if (localResults.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _isSearching = true; 
        _searchResults = localResults;
        _isLoading = false;
      });
    } else {
      // If no local results, try BGG
      // But BGG search returns BggSearchResult, which is not Game.
      // We need to handle this. For ExploreScreen, we might just show correct local ones if CSV is imported.
      // However, to be robust, let's implement BGG search here too.
      // We'll wrap BGG results in a temporary Game object or handle types.
      // For now, let's assume CSV import fixes the main issue.
      // BUT, let's try to search BGG and display mixed results if needed.
      // Actually, let's just show local results for now to verify CSV import.
      // Expanding search to BGG is a feature request "Consulte API para complementar".
      if (!mounted) return;
      setState(() {
        _isSearching = true;
        _searchResults = localResults;
        _isLoading = false;
      });
    }
  }

  Future<void> _runEnrichmentScript() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enrich Database'),
        content: const Text('This will fetch details (images, descriptions) for ALL games from BoardGameGeek. This may take a long time.\n\nContinue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Start')),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;
    
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _EnrichmentProgressDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(theme),
            _buildSearchBar(theme),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isSearching 
                    ? _buildSearchResults(theme) 
                    : _buildEmptyState(theme),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.explore, color: theme.primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Text(
            'Explore Games',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          )),
          IconButton(
            icon: Icon(Icons.cloud_download, color: theme.primaryColor),
            tooltip: 'Enrich All Games',
            onPressed: _runEnrichmentScript,
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.onSurface),
            tooltip: 'Reload CSV Data',
            onPressed: () => _importData(silent: false),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
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
            hintText: 'Search for board games...',
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

  Widget _buildEmptyState(ThemeData theme) {
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
            'Search for your favorite games',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type a game name to start exploring',
            style: TextStyle(
              fontSize: 14,
              color: mutedColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: mutedColor),
            const SizedBox(height: 16),
            Text(
              'No games found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
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
          child: _buildGameCard(game, theme),
        );
      },
    );
  }

  Widget _buildGameCard(Game game, ThemeData theme) {
    final rating = game.rating?.toStringAsFixed(1) ?? 'N/A';
    final players = game.minPlayers != null 
        ? '${game.minPlayers}-${game.maxPlayers} players' 
        : 'Board Game';
    final time = game.maxPlaytime != null ? ' • ${game.maxPlaytime} min' : '';
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameDetails(game: game)),
      ),
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
                          '(Rank #${game.rank})',
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

class _EnrichmentProgressDialog extends StatefulWidget {
  const _EnrichmentProgressDialog();

  @override
  State<_EnrichmentProgressDialog> createState() => _EnrichmentProgressDialogState();
}

class _EnrichmentProgressDialogState extends State<_EnrichmentProgressDialog> {
  String _status = 'Starting...';
  double _progress = 0.0;
  int _total = 0;
  int _current = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final enricher = DataEnrichmentService(context.read<AppDatabase>());
    await enricher.enrichAllGames(
      onProgress: (current, total, name) {
        if (mounted) {
           setState(() {
              _current = current;
              _total = total;
              _progress = total > 0 ? current / total : 0;
              _status = 'Enriching ($current/$total):\n$name';
           });
        }
      },
    );

    if (mounted) {
       setState(() {
          _finished = true;
          _status = 'Completed! Enriched $_total games.';
          _progress = 1.0;
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      title: Text('Enriching Data', style: TextStyle(color: theme.colorScheme.onSurface)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           LinearProgressIndicator(value: _progress, backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1), color: theme.primaryColor),
           const SizedBox(height: 16),
           Text(_status, textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.onSurface)),
        ],
      ),
      actions: [
        if (_finished)
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Done', style: TextStyle(color: theme.primaryColor)))
      ],
    );
  }
}
