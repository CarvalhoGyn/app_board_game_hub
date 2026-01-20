import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

void main() {
  final header = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  };

  test('Test BGG V1 and WWW', () async {
    const id = 1927;
    
    // Test 1: V2 with WWW
    print('\n--- TEST 1: V2 API with WWW ---');
    try {
      final url = 'https://www.boardgamegeek.com/xmlapi2/thing?id=$id&stats=1';
      print('GET $url');
      final res = await http.get(Uri.parse(url), headers: header);
      print('Status: ${res.statusCode}');
    } catch (e) { print('Error: $e'); }

    // Test 2: V1 API
    print('\n--- TEST 2: V1 API ---');
    try {
      final url = 'https://boardgamegeek.com/xmlapi/boardgame/$id?stats=1';
      print('GET $url');
      final res = await http.get(Uri.parse(url), headers: header);
      print('Status: ${res.statusCode}');
      if (res.statusCode == 200) {
        print('Sample V1 Body: ${res.body.substring(0, 100)}');
      }
    } catch (e) { print('Error: $e'); }

    // Test 3: V1 API with WWW
    print('\n--- TEST 3: V1 API with WWW ---');
    try {
      final url = 'https://www.boardgamegeek.com/xmlapi/boardgame/$id?stats=1';
      print('GET $url');
      final res = await http.get(Uri.parse(url), headers: header);
      print('Status: ${res.statusCode}');
    } catch (e) { print('Error: $e'); }
  });
}
