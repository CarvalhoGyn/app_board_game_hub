import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:app_board_game_hub/services/games_repository.dart';
import 'package:app_board_game_hub/database/database.dart';
import 'package:drift/native.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder<List<Map<String, dynamic>>> {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {}

void main() {
  late AppDatabase db;
  late GamesRepository repository;
  late MockSupabaseClient mockSupabase;
  late MockPostgrestQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;
  late MockPostgrestTransformBuilder mockTransformBuilder;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    mockSupabase = MockSupabaseClient();
    mockQueryBuilder = MockPostgrestQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
    mockTransformBuilder = MockPostgrestTransformBuilder();

    repository = GamesRepository(db.gamesDao, mockSupabase);

    // Default setup for chain calls
    registerFallbackValue(const Map<String, dynamic>());
    when(() => mockSupabase.from(any())).thenReturn(mockQueryBuilder);
    when(() => mockQueryBuilder.select(any())).thenReturn(mockFilterBuilder);
    when(() => mockFilterBuilder.ilike(any(), any())).thenReturn(mockFilterBuilder);
    when(() => mockFilterBuilder.limit(any())).thenAnswer((_) async => []);
  });

  tearDown(() async {
    await db.close();
  });

  group('GamesRepository - Hybrid Search', () {
    const String query = 'Catan';

    test('Deve retornar apenas resultados locais se a busca remota falhar', () async {
      // Setup Local
      await db.gamesDao.createGame(const GamesCompanion.insert(
        id: Value('local-1'),
        name: 'Catan (Local)',
      ));

      // Setup Remote (Fail)
      when(() => mockFilterBuilder.limit(any())).thenThrow(Exception('Network Fail'));

      final results = await repository.searchGames(query);

      expect(results.length, 1);
      expect(results.first.name, 'Catan (Local)');
    });

    test('Deve mesclar e remover duplicatas entre local e remoto', () async {
      // Setup Local (Catan com BGG_ID 13)
      await db.gamesDao.createGame(const GamesCompanion.insert(
        id: Value('l1'),
        name: 'Catan',
        bggId: Value(13),
      ));

      // Setup Remote (Catan com BGG_ID 13 e outro jogo Carcassonne)
      final List<Map<String, dynamic>> remoteData = [
        {
          'id': 'r1',
          'name': 'Catan',
          'bgg_id': 13, // Duplicate BGG ID
        },
        {
          'id': 'r2',
          'name': 'Carcassonne',
          'bgg_id': 824,
        }
      ];

      when(() => mockFilterBuilder.limit(any())).thenAnswer((_) async => remoteData);

      final results = await repository.searchGames(query);

      // Esperado: Catan (Local) + Carcassonne (Remote). O Catan remoto é descartado por duplicidade de BGG ID.
      expect(results.length, 2);
      expect(results.any((g) => g.id == 'l1'), isTrue);
      expect(results.any((g) => g.id == 'r2'), isTrue);
      expect(results.any((g) => g.id == 'r1'), isFalse);
    });
  });

  group('GamesRepository - Cache', () {
    test('Deve salvar um jogo remoto no banco local (cacheGame)', () async {
      final remoteGame = Game(
        id: 'remote-123',
        name: 'Gloomhaven',
        bggId: 174430,
        isEnriched: true,
      );

      await repository.cacheGame(remoteGame);

      final cached = await db.gamesDao.getGameById('remote-123');
      expect(cached, isNotNull);
      expect(cached!.name, 'Gloomhaven');
    });
  });
}
