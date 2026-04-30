import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:drift/drift.dart';
import '../database/database.dart';

class GamesRepository {
  final SupabaseClient _supabase;
  final GamesDao _gamesDao;

  GamesRepository(this._gamesDao, [SupabaseClient? supabase]) 
      : _supabase = supabase ?? Supabase.instance.client;

  /// Performs a Hybrid Search (Local + Remote).
  /// 1. Searches Local DB.
  /// 2. Searches Supabase (Cloud).
  /// 3. Merges results (deduplicating by ID/BGG_ID, preferring Local).
  Future<List<Game>> searchGames(String query) async {
    if (query.isEmpty) return [];

    // 1. Local Search
    final localResults = await _gamesDao.searchGames(query);
    final localIds = localResults.map((g) => g.id).toSet();
    final localBggIds = localResults.where((g) => g.bggId != null).map((g) => g.bggId!).toSet();

    List<Game> remoteGames = [];

    // 2. Remote Search (if network available)
    // We catch errors so offline search still works
    try {
      final response = await _supabase
          .from('games')
          .select()
          .ilike('name', '%$query%') // Simple substring search
          .limit(20); // Fetch top 20 matches from cloud

      // Convert JSON to Game objects
      for (final row in response) {
        final r = row as Map<String, dynamic>;
        
        // Convert Snake_Case (Supabase) to Game object
        // We use a helper similar to Sync Service logic
        final game = _mapRemoteToGame(r);
        
        // Deduplicate: Don't add if we already have it locally
        if (!localIds.contains(game.id) && 
            (game.bggId == null || !localBggIds.contains(game.bggId))) {
          remoteGames.add(game);
        }
      }
    } catch (e) {
      debugPrint('GameRepository: Remote search failed: $e');
      // Continue with just local results
    }

    // 3. Merge
    return [...localResults, ...remoteGames];
  }

  /// Caches a Game to Local DB. 
  /// Use this when a user selects a "Remote" game to interact with it.
  Future<void> cacheGame(Game game) async {
    // Convert Game to Companion
    final companion = GamesCompanion(
      id: Value(game.id),
      bggId: Value(game.bggId),
      name: Value(game.name),
      description: Value(game.description),
      imageUrl: Value(game.imageUrl),
      minPlayers: Value(game.minPlayers),
      maxPlayers: Value(game.maxPlayers),
      yearPublished: Value(game.yearPublished),
      rank: Value(game.rank),
      rating: Value(game.rating),
      isEnriched: Value(game.isEnriched),
      minPlaytime: Value(game.minPlaytime),
      maxPlaytime: Value(game.maxPlaytime),
      minAge: Value(game.minAge),
      categories: Value(game.categories),
      mechanics: Value(game.mechanics),
      type: Value(game.type),
      families: Value(game.families),
      integrations: Value(game.integrations),
      reimplementations: Value(game.reimplementations),
    );

    await _gamesDao.upsertGame(companion);
  }

  // --- Helpers ---

  Game _mapRemoteToGame(Map<String, dynamic> data) {
    // Map remote keys (snake_case) to Drift generated Game keys
    return Game(
      id: data['id'],
      bggId: data['bgg_id'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['image_url'],
      minPlayers: data['min_players'],
      maxPlayers: data['max_players'],
      yearPublished: data['year_published'],
      rank: data['rank'],
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
      isEnriched: data['is_enriched'] ?? false,
      minPlaytime: data['min_playtime'],
      maxPlaytime: data['max_playtime'],
      minAge: data['min_age'],
      categories: data['categories'],
      mechanics: data['mechanics'],
      type: data['type'],
      families: data['families'],
      integrations: data['integrations'],
      reimplementations: data['reimplementations'],
    );
  }
}
