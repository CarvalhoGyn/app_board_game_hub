import 'package:drift/drift.dart';
import '../database/database.dart';
import 'bgg_service.dart';

class DataEnrichmentService {
  final AppDatabase _db;
  final BggService _bggService;

  DataEnrichmentService(this._db) : _bggService = BggService();

  /// Enriches all games that haven't been enriched yet.
  /// [onProgress] callback returns (current, total)
  Future<void> enrichAllGames({Function(int current, int total, String gameName)? onProgress}) async {
    // 1. Get all games that need enrichment
    final gamesToEnrich = await (_db.select(_db.games)
      ..where((g) => g.isEnriched.equals(false) & g.bggId.isNotNull())
    ).get();

    if (gamesToEnrich.isEmpty) {
      onProgress?.call(0, 0, 'Done');
      return;
    }

    int completed = 0;
    int total = gamesToEnrich.length;

    for (final game in gamesToEnrich) {
      if (game.bggId == null) continue;

      onProgress?.call(completed + 1, total, game.name);

      try {
        // 2. Fetch details from BGG (via HTML scraping)
        final details = await _bggService.fetchGameDetails(game.bggId!);

        if (details != null) {
          // 3. Update the game in the database
          // We preserve the ID and other local fields, but overwrite enriched fields
          final update = GamesCompanion(
            description: details.description,
            imageUrl: details.imageUrl,
            minPlayers: details.minPlayers,
            maxPlayers: details.maxPlayers,
            minPlaytime: details.minPlaytime,
            maxPlaytime: details.maxPlaytime,
            minAge: details.minAge,
            yearPublished: details.yearPublished,
            categories: details.categories,
            mechanics: details.mechanics,
            type: details.type,
            families: details.families,
            integrations: details.integrations,
            reimplementations: details.reimplementations,
            isEnriched: const Value(true),
            rank: details.rank, // Update rank if available
            rating: details.rating, // Update rating if available
          );

          await (_db.update(_db.games)..where((g) => g.id.equals(game.id))).write(update);
        } else {
             // If fetch failed, maybe mark as attempted? For now we leave it to retry later.
             // Or we could set a flag "enrichmentFailed" if we had one.
        }

        // 4. Rate limiting to be polite (even with HTML scraping)
        await Future.delayed(const Duration(milliseconds: 1500)); // 1.5s delay
      } catch (e) {
        print('Failed to enrich ${game.name}: $e');
        // Continue to next game
      }

      completed++;
    }
  }
}
