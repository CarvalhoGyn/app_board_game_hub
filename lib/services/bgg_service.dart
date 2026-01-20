import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

class BggService {
  static const String _baseUrl = 'https://boardgamegeek.com/xmlapi2';

  Future<GamesCompanion?> fetchGameDetails(int bggId) async {
    // ABANDON API - Use HTML Scraping exclusively as requested
    return _fetchFromHtml(bggId);
  }

  Future<GamesCompanion?> _fetchFromHtml(int bggId) async {
    try {
      final response = await http.get(
        Uri.parse('https://boardgamegeek.com/boardgame/$bggId'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'text/html',
        }
      );

      if (response.statusCode == 200) {
        final body = response.body;
        // Parse Title - Expect "Name | BoardGameGeek" schema to avoid Captcha pages
        final titleReg = RegExp(r'<title>(.*?) \| BoardGameGeek<\/title>');
        final nameMatch = titleReg.firstMatch(body);
        
        if (nameMatch == null) {
          // Likely a Cloudflare challenge or invalid page
          throw Exception('Invalid Page Content (Captcha/Block)'); 
        }

        var name = nameMatch.group(1) ?? 'Unknown Game';
        // Clean up title artifacts
        name = name.replaceAll(RegExp(r'\s*\|\s*Board\s*Game.*', caseSensitive: false), '')
                   .replaceAll(RegExp(r'\s*\|\s*BoardGameGeek', caseSensitive: false), '')
                   .trim();

        // Parse Image
        final imgReg = RegExp(r'<meta property="og:image" content="([^"]+)"');
        final imgMatch = imgReg.firstMatch(body);
        final imageUrl = imgMatch?.group(1);

        if (imageUrl == null || imageUrl.isEmpty) {
           throw Exception('No Image Found in HTML');
        }

        // Parse Description
        final descReg = RegExp(r'<meta property="og:description" content="([^"]+)"');
        final descMatch = descReg.firstMatch(body);
        var description = descMatch?.group(1) ?? '';
        
        // Decode HTML entities
        description = description.replaceAll('&quot;', '"').replaceAll('&amp;', '&').replaceAll('&#039;', "'");

        // Attempt to parse stats from JSON-LD or JS variables often found in BGG HTML
        // Patterns: "minplayers":"1", "minplaytime":"60", etc.
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

        // BGG often puts "yearpublished":"2015"
        final year = tryParseStat('yearpublished');
        
        // Parse Categories, Mechanics, Type, Family using GEEK.geekitemPreload JSON
        // This is much more reliable than regex scraping
        Set<String> categoriesList = {};
        Set<String> mechanicsList = {};
        Set<String> typesList = {};
        Set<String> familiesList = {};
        Set<String> integrationsList = {};
        Set<String> reimplementationsList = {};
        var fullDescription = description;

        bool jsonParsed = false;
        try {
           final jsonStart = body.indexOf('GEEK.geekitemPreload = ');
           if (jsonStart != -1) {
              // Extract until the specific next variable assignment "GEEK.geekitemSettings ="
              // This avoids issues with semicolons inside strings
              var jsonEnd = body.indexOf('GEEK.geekitemSettings =', jsonStart);
              if (jsonEnd == -1) {
                 // Fallback to looking for end of script tag if settings var not found
                 jsonEnd = body.indexOf('</script>', jsonStart);
              }
              
              if (jsonEnd != -1) {
                  // Find the last semicolon before the end marker to properly close the statement
                  var lastSemi = body.lastIndexOf(';', jsonEnd);
                  if (lastSemi != -1 && lastSemi > jsonStart) {
                      final jsonString = body.substring(jsonStart + 23, lastSemi);
                      final jsonData = jsonDecode(jsonString);
                      final item = jsonData['item'];
                      
                      if (item != null) {
                          // Description
                          if (item['description'] != null) {
                              fullDescription = item['description'];
                              // Clean HTML tags and entities
                              fullDescription = fullDescription.replaceAll(RegExp(r'<[^>]*>'), ' ').trim();
                              fullDescription = fullDescription.replaceAll('&quot;', '"').replaceAll('&amp;', '&').replaceAll('&#039;', "'").replaceAll('&nbsp;', ' ');
                          }

                          final links = item['links'];
                          if (links != null) {
                              void extract(String key, Set<String> target) {
                                  if (links[key] is List) {
                                      for (var obj in links[key]) {
                                          if (obj['name'] != null) target.add(obj['name']);
                                      }
                                  }
                              }
                              
                              extract('boardgamecategory', categoriesList);
                              extract('boardgamemechanic', mechanicsList);
                              extract('boardgamefamily', familiesList);
                              extract('boardgamesubdomain', typesList); // Type
                              extract('boardgameintegration', integrationsList);
                              extract('reimplements', reimplementationsList);
                              jsonParsed = true;
                          }
                      }
                  }
              }
           } 
        } catch (e) {
           debugPrint('Error parsing BGG JSON: $e');
           // Continue to regex fallback
        }

        if (!jsonParsed) {
             debugPrint('GEEK.geekitemPreload not found or failed, falling back to regex');
             // Fallback Regex (Previous implementation)
             Set<String> extractLinks(String type) {
                final reg = RegExp(r'href="/' + type + r'/\d+/[^"]+">\s*([^<]+)\s*</a>', caseSensitive: false);
                return reg.allMatches(body).map((m) => m.group(1)?.trim() ?? '').where((s) => s.isNotEmpty).toSet();
             }
             
             // Context-aware extraction for "Integrates With" and "Reimplements"
             Set<String> extractSectionLinks(String sectionHeader) {
                final headerPos = body.indexOf(sectionHeader);
                if (headerPos == -1) return {};
                final chunk = body.substring(headerPos, (headerPos + 2000).clamp(0, body.length));
                final reg = RegExp(r'href="/boardgame/\d+/[^"]+">\s*([^<]+)\s*</a>', caseSensitive: false);
                return reg.allMatches(chunk).map((m) => m.group(1)?.trim() ?? '').where((s) => s.isNotEmpty).toSet();
             }

             categoriesList = extractLinks('boardgamecategory');
             mechanicsList = extractLinks('boardgamemechanic');
             typesList = extractLinks('boardgametype');
             familiesList = extractLinks('boardgamefamily');
             integrationsList = extractSectionLinks('Integrates With');
             reimplementationsList = extractSectionLinks('Reimplements');

             // Simple scraping for description if JSON missing
             final editDescReg = RegExp(r'id="editdesc"[^>]*>([\s\S]*?)</div>', caseSensitive: false);
             final editDescMatch = editDescReg.firstMatch(body);
             if (editDescMatch != null) {
                  fullDescription = editDescMatch.group(1)?.trim() ?? description;
                  fullDescription = fullDescription.replaceAll(RegExp(r'<[^>]*>'), '').trim();
             }
        }

        debugPrint('HTML Scraping Results (JSON-LD: $jsonParsed):');
        debugPrint(' - Categories: ${categoriesList.length}');
        debugPrint(' - Mechanics: ${mechanicsList.length}');
        debugPrint(' - Types: ${typesList.length}');
        debugPrint(' - Families: ${familiesList.length}');
        debugPrint(' - Integrations: ${integrationsList.length}');
        debugPrint(' - Reimplementations: ${reimplementationsList.length}');

        final categories = categoriesList.join(', ');
        final mechanics = mechanicsList.join(', ');
        final type = typesList.join(', ');
        final families = familiesList.join(', ');
        final integrations = integrationsList.join(', ');
        final reimplementations = reimplementationsList.join(', ');

        return GamesCompanion(
          bggId: Value(bggId),
          name: Value(name),
          description: Value(fullDescription),
          imageUrl: Value(imageUrl),
          minPlayers: Value(minPlayers),
          maxPlayers: Value(maxPlayers),
          minPlaytime: Value(minPlaytime),
          maxPlaytime: Value(maxPlaytime),
          minAge: Value(minAge),
          yearPublished: Value(year),
          categories: Value(categories),
          mechanics: Value(mechanics),
          type: Value(type),
          families: Value(families),
          integrations: Value(integrations),
          reimplementations: Value(reimplementations),
          isEnriched: const Value(true), 
        );
      }
    } catch (e) {
      print('HTML Scraping failed: $e');
    }
    return null;
  }

  Future<List<BggSearchResult>> searchGames(String query) async {
    try {
      final safeQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse('$_baseUrl/search?query=$safeQuery&type=boardgame'),
        headers: {
          'User-Agent': 'BoardGameHub/1.0 (App for cataloging games)',
          'Accept': 'application/xml',
        },
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return document.findAllElements('item').map((item) {
          final id = int.tryParse(item.getAttribute('id') ?? '') ?? 0;
          final name = item.findElements('name').firstOrNull?.getAttribute('value') ?? 'Unknown';
          final year = item.findElements('yearpublished').firstOrNull?.getAttribute('value');
          
          return BggSearchResult(id: id, name: name, year: year);
        }).toList();
      }
    } catch (e) {
      print('Error searching BGG: $e');
    }
    return [];
  }
}

class BggSearchResult {
  final int id;
  final String name;
  final String? year;

  BggSearchResult({required this.id, required this.name, this.year});
}
