import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:app_board_game_hub/database/database.dart';
import 'package:app_board_game_hub/services/supabase_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder<List<Map<String, dynamic>>> {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

void main() {
  late AppDatabase db;
  late SupabaseSyncService service;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockPostgrestQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockQueryBuilder = MockPostgrestQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();

    service = SupabaseSyncService(db, mockSupabase);
    
    SharedPreferences.setMockInitialValues({});

    // Setup Auth
    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(User(
      id: 'user-123',
      appMetadata: {},
      userMetadata: {},
      aud: 'aud',
      createdAt: DateTime.now().toIso8601String(),
    ));

    // Setup Postgrest
    when(() => mockSupabase.from(any())).thenReturn(mockQueryBuilder);
    when(() => mockQueryBuilder.upsert(any(), onConflict: any(named: 'onConflict'), ignoreDuplicates: any(named: 'ignoreDuplicates'))).thenReturn(mockFilterBuilder);
    when(() => mockQueryBuilder.select(any())).thenReturn(mockFilterBuilder);
    when(() => mockFilterBuilder.single()).thenAnswer((invocation) async => {});
  });

  tearDown(() async {
    await db.close();
  });

  group('SupabaseSyncService - Push changes logic', () {
    test('Deve processar itens da SyncQueue e enviá-los ao Supabase', () async {
      // 1. Adicionar item à fila (Simulado via DAO)
      final payload = {'id': 'match-1', 'location': 'Home'};
      await db.syncQueueDao.enqueue(
        entity: 'matches',
        action: 'INSERT',
        payload: jsonEncode(payload),
      );

      // 2. Setup mock do Supabase para o retorno do insert/upsert
      when(() => mockFilterBuilder.single()).thenAnswer((_) async => {
        'id': 'match-1',
        'location': 'Home',
        'created_at': DateTime.now().toIso8601String(),
      });

      // 3. Executar pushChanges
      await service.pushChanges();

      // 4. Verificar se o item foi marcado como completo
      final pending = await db.syncQueueDao.getPendingItems();
      expect(pending.isEmpty, isTrue);

      // 5. Verificar se o Supabase foi chamado
      verify(() => mockSupabase.from('matches')).called(1);
    });
  });

  group('SupabaseSyncService - Game JIT Sync', () {
    test('_ensureGameSynced deve alinhar ID local com ID remoto', () async {
      const localId = 'local-uid';
      const remoteId = 'remote-uuid';
      const bggId = 123;

      // 1. Criar jogo local com ID temporário
      await db.gamesDao.createGame(const GamesCompanion.insert(
        id: Value(localId),
        name: 'Game Test',
        bggId: Value(bggId),
      ));

      // 2. Mockar Supabase para retornar o ID real (já existente no servidor)
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer((_) async => {'id': remoteId});

      // 3. Chamar sync global de push que dispara o align
      // (Aqui usamos o sync indiretamente ou o método privado se fosse público)
      // Como _ensureGameSynced é privado, vamos testar o efeito via criação de Match que o chama.
      
      await service.createMatch(
        match: const MatchesCompanion.insert(
          gameId: localId,
          date: Value.absent(),
        ),
        players: [],
      );

      // 4. Verificar se o ID local foi atualizado para o remoto
      final updatedGame = await db.gamesDao.getGameById(remoteId);
      final oldGame = await db.gamesDao.getGameById(localId);

      expect(updatedGame, isNotNull);
      expect(oldGame, isNull);
    });
  });
}
