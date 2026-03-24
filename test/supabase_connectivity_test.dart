import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';
import 'package:app_board_game_hub/env/env.dart';

void main() {
  test('Supabase Connectivity Test', () async {
    print('Testing connection to: ${Env.supabaseUrl}');

    final client = SupabaseClient(Env.supabaseUrl, Env.supabaseAnonKey);

    try {
      // Attempt to fetch something simple. 
      // If the table doesn't exist or RLS blocks it, we might get an error, 
      // but a specific PostgreSQL/Supabase error confirms connectivity.
      // 'profiles' table should exist.
      final response = await client.from('profiles').select().limit(1);
      
      print('Connection Successful!');
      print('Response data: $response');
      
      expect(true, isTrue); // Pass if no exception
    } catch (e) {
      print('Connection Failed.');
      print('Error: $e');
      fail('Could not connect to Supabase: $e');
    }
  });
}
