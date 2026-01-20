import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Fetch BGG HTML Page', () async {
    const id = 1927;
    const url = 'https://boardgamegeek.com/boardgame/$id/munchkin'; // Canonical-ish URL
    
    print('GET $url');
    try {
      final res = await http.get(
        Uri.parse(url), 
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Referer': 'https://www.google.com/',
        }
      );
      print('Status: ${res.statusCode}');
      if (res.statusCode == 200) {
        // Look for og:image
        final body = res.body;
        final ogImageRegExp = RegExp(r'<meta property="og:image" content="([^"]+)"');
        final match = ogImageRegExp.firstMatch(body);
        if (match != null) {
          print('Found Image: ${match.group(1)}');
        } else {
          print('No og:image found.');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  });
}
