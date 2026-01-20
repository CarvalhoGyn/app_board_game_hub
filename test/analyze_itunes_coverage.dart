import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:csv/csv.dart';

void main() {
  test('Analyze iTunes Coverage for Board Games', () async {
    final file = File('assets/data/boardgames_ranks.csv');
    if (!await file.exists()) {
      print('CSV file not found!');
      return;
    }

    final input = await file.readAsString();
    // Simple parsing (assuming standard CSV)
    final List<List<dynamic>> rows = const CsvToListConverter(eol: '\n').convert(input);
    
    // Structure: id, name, year, rank, average, bayes_average, users_rated, url, thumbnail
    // Assuming Row 0 is header.
    
    // Filter for valid ranks
    final validGames = rows.skip(1).where((r) => r.length > 1 && r[1].toString().isNotEmpty).toList();
    
    print('Total Games in CSV: ${validGames.length}');
    
    // Strategy: Test Top 20 and Random 20
    final top20 = validGames.take(20).toList();
    final randomWithSeed = Random(42);
    final random20 = List.generate(20, (_) => validGames[randomWithSeed.nextInt(validGames.length)]);
    
    final testSet = [...top20, ...random20];
    print('Testing ${testSet.length} games (Top 20 + Random 20)...');
    
    int hits = 0;
    
    for (var game in testSet) {
      final name = game[1].toString();
      // Clean name (remove punctuation?)
      final cleanName = name.replaceAll(RegExp(r'[:\-]'), ' ');
      
      final url = 'https://itunes.apple.com/search?term=${Uri.encodeComponent(cleanName)}&media=software&limit=1';
      
      try {
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          if (data['resultCount'] > 0) {
            hits++;
            print('✅ FOUND: $name -> ${data['results'][0]['trackName']}');
          } else {
             print('❌ MISSING: $name');
          }
        }
      } catch (e) {
        print('Error processing $name: $e');
      }
      
      // Be nice to API
      await Future.delayed(const Duration(milliseconds: 200));
    }
    
    print('\n--- RESULTS ---');
    print('Total Tested: ${testSet.length}');
    print('Found: $hits');
    print('Coverage: ${(hits / testSet.length * 100).toStringAsFixed(1)}%');
  });
}
