import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Test Wikipedia/Wikidata Concept', () async {
    // Search for "Catan"
    final q = 'Catan';
    final url = 'https://www.wikidata.org/w/api.php?action=wbsearchentities&search=$q&language=en&format=json';
    print('Testing Wikidata Search: $url');
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final search = data['search'] as List;
        if (search.isNotEmpty) {
          final id = search.first['id'];
          print('Found Entity ID: $id (${search.first['label']})');
          
          // Get Details (Image P18)
          final detailsUrl = 'https://www.wikidata.org/w/api.php?action=wbgetclaims&entity=$id&property=P18&format=json';
          final res2 = await http.get(Uri.parse(detailsUrl));
          final claims = json.decode(res2.body)['claims']['P18'];
          if (claims != null && claims.isNotEmpty) {
             final filename = claims[0]['mainsnak']['datavalue']['value'];
             print('Found Image File: $filename');
             // Convert to URL?
             // Need MD5 hash logic for Commons URL, or use special Commons API.
             // Easier: Use MediaWiki API with files.
          } else {
             print('No P18 (Image) found for this entity.');
          }
        }
      }
    } catch (e) { print(e); }
  });

  test('Test iTunes Search API', () async {
    final q = 'Catan';
    final url = 'https://itunes.apple.com/search?term=$q&media=software&limit=1';
    print('\nTesting iTunes Search: $url');
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['resultCount'] > 0) {
          final item = data['results'][0];
          print('Found App: ${item['trackName']}');
          print('Artwork 100: ${item['artworkUrl100']}');
          print('Artwork 512: ${item['artworkUrl512']}');
          print('Screenshots: ${item['screenshotUrls']?.length} found');
        }
      }
    } catch (e) { print(e); }
  });
}
