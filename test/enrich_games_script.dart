import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_board_game_hub/env/env.dart';

// --- Configuration ---
const int BATCH_SIZE = 10;
const int DELAY_MS = 1500; // Polite delay between BGG requests
const bool VERBOSE = true;

Future<void> main() async {
  print('Starting Enrichment Script...');

  // 1. Initialize Supabase (Admin Mode)
  final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseServiceRoleKey);

  // 2. Fetch Unenriched Games
  // We prioritize games that have a BGG ID but are not enriched yet.
  final response = await supabase
      .from('games')
      .select('id, bgg_id, name')
      .eq('is_enriched', false)
      .not('bgg_id', 'is', 'null') // Syntax: .not('col', 'is', null) -> .filter('col', 'not.is', null) in Dart SDK
      .limit(BATCH_SIZE);

  // Note: Supabase Dart SDK 'not' filter usage: .neq('bgg_id', null) or filter('bgg_id', 'not.is', null)
  // Let's retry with a safer query if the above fails in runtime, but let's assume standard postgrest builder.
  // Actually, likely safer to treat response as List<Map>
  final List<dynamic> games = response as List<dynamic>;

  if (games.isEmpty) {
    print('No unenriched games found.');
    return;
  }

  print('Found ${games.length} games to enrich.');

  int successCount = 0;
  int failCount = 0;

  for (final game in games) {
    final id = game['id'];
    final bggId = game['bgg_id'] as int;
    final name = game['name'];

    print('[$successCount/$failCount] Enriching "$name" (BGG: $bggId)...');

    try {
      final details = await _fetchGameDetails(bggId);
      
      if (details != null) {
        // Update DB
        await supabase.from('games').update({
          ...details,
          'is_enriched': true,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', id);
        
        print('  -> Success.');
        successCount++;
      } else {
        print('  -> Failed to scrape.');
        failCount++;
      }
    } catch (e) {
      print('  -> Error: $e');
      failCount++;
    }

    // Rate Limiting
    sleep(Duration(milliseconds: DELAY_MS));
  }

  print('-----------------------------------');
  print('Batch Complete.');
  print('Success: $successCount');
  print('Failed:  $failCount');
}

// --- BGG Scraping Logic (Ported from Service) ---

Future<Map<String, dynamic>?> _fetchGameDetails(int bggId) async {
  try {
    final url = Uri.parse('https://boardgamegeek.com/boardgame/$bggId');
    final response = await http.get(url, headers: {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html',
    });

    if (response.statusCode != 200) return null;
    final body = response.body;

    // 1. Meta Tags (Regex)
    String description = '';
    String? imageUrl;

    final descMatch = RegExp(r'<meta property="og:description" content="([^"]+)"').firstMatch(body);
    if (descMatch != null) description = _decodeEntity(descMatch.group(1)!);

    final imgMatch = RegExp(r'<meta property="og:image" content="([^"]+)"').firstMatch(body);
    if (imgMatch != null) imageUrl = imgMatch.group(1);

    // 2. Stats (Regex)
    int? tryParseStat(String key) {
       final reg = RegExp('"$key"\\s*:\\s*"(\\d+)"', caseSensitive: false);
       final match = reg.firstMatch(body);
       return match != null ? int.tryParse(match.group(1)!) : null;
    }

    final minPlayers = tryParseStat('minplayers');
    final maxPlayers = tryParseStat('maxplayers');
    final minPlaytime = tryParseStat('minplaytime');
    final maxPlaytime = tryParseStat('maxplaytime');
    final minAge = tryParseStat('minage');
    final year = tryParseStat('yearpublished');

    // 3. JSON Extraction (GEEK.geekitemPreload)
    String? categories;
    String? mechanics;
    String? type;
    String? families;

    // Attempt to parse JSON blob for lists
    final jsonStart = body.indexOf('GEEK.geekitemPreload = ');
    if (jsonStart != -1) {
      int jsonEnd = body.indexOf('GEEK.geekitemSettings =', jsonStart);
      if (jsonEnd == -1) jsonEnd = body.indexOf('</script>', jsonStart);

      if (jsonEnd != -1) {
         final lastSemi = body.lastIndexOf(';', jsonEnd);
         if (lastSemi > jsonStart) {
            try {
              final jsonString = body.substring(jsonStart + 23, lastSemi);
              final data = jsonDecode(jsonString);
              final item = data['item'];
              
              if (item != null) {
                 if (item['description'] != null) {
                   description = item['description']
                      .replaceAll(RegExp(r'<[^>]*>'), ' ') // Clean tags
                      .replaceAll('&quot;', '"')
                      .trim();
                 }

                 final links = item['links'];
                 if (links != null) {
                    String join(String k) {
                      if (links[k] is List) {
                        return (links[k] as List).map((o) => o['name']).join(', ');
                      }
                      return '';
                    }
                    categories = join('boardgamecategory');
                    mechanics = join('boardgamemechanic');
                    type = join('boardgamesubdomain');
                    families = join('boardgamefamily');
                 }
              }
            } catch (e) {
              // JSON parse error, ignore
            }
         }
      }
    }

    return {
      'description': description,
      'image_url': imageUrl,
      'min_players': minPlayers,
      'max_players': maxPlayers,
      'min_playtime': minPlaytime,
      'max_playtime': maxPlaytime,
      'min_age': minAge,
      'year_published': year,
      'categories': categories,
      'mechanics': mechanics,
      'type': type,
      'families': families,
    };

  } catch (e) {
    print('Scraping error: $e');
    return null;
  }
}

String _decodeEntity(String s) {
  return s.replaceAll('&quot;', '"').replaceAll('&amp;', '&').replaceAll('&#039;', "'");
}
