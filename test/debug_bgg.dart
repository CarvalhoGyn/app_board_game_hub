import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

void main() {
  test('Fetch Munchkin (1927) from BGG', () async {
    const id = 1927;
    const url = 'https://boardgamegeek.com/xmlapi2/thing?id=$id&stats=1';
    
    print('Fetching $url ...');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'BoardGameHub/1.0 (testing@example.com)'},
      );
      print('Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('Body length: ${response.body.length}');
        print('Body snippet: ${response.body.substring(0, 200)}');
        
        final document = XmlDocument.parse(response.body);
        final item = document.findAllElements('item').firstOrNull;
        
        if (item == null) {
          print('FAIL: No <item> found.');
        } else {
          final name = item.findElements('name')
              .firstWhere((e) => e.getAttribute('type') == 'primary', orElse: () => item.findElements('name').first)
              .getAttribute('value');
          print('SUCCESS: Found game name: $name');
          
          final image = item.findElements('image').firstOrNull?.innerText;
          final thumb = item.findElements('thumbnail').firstOrNull?.innerText;
          print('Image: $image');
          print('Thumb: $thumb');
        }
      } else {
        print('FAIL: Non-200 status.');
      }
    } catch (e) {
      print('EXCEPTION: $e');
    }
  });
}
