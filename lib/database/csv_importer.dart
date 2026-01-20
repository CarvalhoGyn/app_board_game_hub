import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'database.dart';

class CsvImporter {
  static Future<String> importGamesIfEmpty(AppDatabase db) async {
    final gamesDao = db.gamesDao;
    // Check if we already have BGG games imported
    final bggGamesCount = await (db.selectOnly(db.games)
      ..addColumns([db.games.bggId.count()])
      ..where(db.games.bggId.isNotNull()))
      .map((row) => row.read(db.games.bggId.count()))
      .getSingle();

    if ((bggGamesCount ?? 0) > 50) { // Keep forced threshold low for now
      return 'Skipped: Already has $bggGamesCount BGG games.';
    }

    try {
      String csvData = await rootBundle.loadString('assets/data/boardgames_ranks.csv');
      
      // Normalize newlines to ensure parser works correctly
      if (!csvData.contains('\n') && csvData.contains('\r')) {
        csvData = csvData.replaceAll('\r', '\n');
      }
      
      // Explicitly set EOL to \n after normalization, and field delimiter to comma
      final List<List<dynamic>> rows = const CsvToListConverter(
        fieldDelimiter: ',', 
        eol: '\n',
        shouldParseNumbers: true,
      ).convert(csvData);

      if (rows.isEmpty) return 'Error: CSV file is empty after parsing.';

      // Skip header
      final dataRows = rows.skip(1);
      
      // Batch inserts for performance
      final batchSize = 1000;
      List<GamesCompanion> batch = [];
      int importedCount = 0;

      for (var row in dataRows) {
        if (row.length < 6) continue;

        try {
          final bggId = int.tryParse(row[0].toString());
          final name = row[1].toString();
          final year = int.tryParse(row[2].toString());
          final rank = int.tryParse(row[3].toString());
          final rating = double.tryParse(row[5].toString());

          if (bggId != null && name.isNotEmpty) {
            batch.add(GamesCompanion.insert(
              bggId: Value(bggId),
              name: name,
              yearPublished: Value(year),
              rank: Value(rank),
              rating: Value(rating),
            ));
          }
        } catch (e) {
          // print('Error parsing row: $row. Error: $e');
        }

        if (batch.length >= batchSize) {
          await db.batch((b) {
            b.insertAll(db.games, batch, mode: InsertMode.insertOrReplace);
          });
          importedCount += batch.length;
          batch.clear();
        }
      }

      if (batch.isNotEmpty) {
        await db.batch((b) {
          b.insertAll(db.games, batch, mode: InsertMode.insertOrReplace);
        });
        importedCount += batch.length;
      }
      
      if (importedCount == 0) {
        final firstRow = rows.length > 1 ? rows[1].toString() : 'No data rows';
        return 'Failed: 0 games imported. Rows: ${rows.length}. 1st Row Len: ${rows.length > 1 ? rows[1].length : 0}. Content: ${firstRow.substring(0, firstRow.length > 50 ? 50 : firstRow.length)}...';
      }

      return 'Success: Imported $importedCount games.';
    } catch (e) {
      return 'Error importing CSV: $e';
    }
  }
}
