import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_board_game_hub/services/subscription_service.dart';
import 'package:app_board_game_hub/database/database.dart';
import 'package:app_board_game_hub/services/supabase_sync_service.dart';

class MockUsersDao extends Mock implements UsersDao {}
class MockMatchesDao extends Mock implements MatchesDao {}
class MockSupabaseSyncService extends Mock implements SupabaseSyncService {}

void main() {
  late SubscriptionService service;
  late MockUsersDao mockUsersDao;
  late MockMatchesDao mockMatchesDao;
  late MockSupabaseSyncService mockSyncService;

  setUp(() {
    service = SubscriptionService();
    mockUsersDao = MockUsersDao();
    mockMatchesDao = MockMatchesDao();
    mockSyncService = MockSupabaseSyncService();
  });

  group('SubscriptionService - Match Participation Limits', () {
    const userId = 'user-123';

    test('Usuários Premium podem participar sem limite', () async {
      final premiumUser = User(
        id: userId,
        username: 'Pro Player',
        email: 'pro@test.com',
        password: 'pass',
        xp: 0,
        prestige: 0,
        isPremium: true,
        termsAccepted: true,
      );

      when(() => mockUsersDao.getUserById(userId)).thenAnswer((_) async => premiumUser);

      final canPlay = await service.canParticipateInMatch(
        userId: userId,
        usersDao: mockUsersDao,
        matchesDao: mockMatchesDao,
        syncService: mockSyncService,
      );

      expect(canPlay, isTrue);
      verifyNever(() => mockMatchesDao.countMatchesForUser(any()));
    });

    test('Usuários Free podem participar se tiverem menos de 10 partidas (local)', () async {
      final freeUser = User(
        id: userId,
        username: 'Free Player',
        email: 'free@test.com',
        password: 'pass',
        xp: 0,
        prestige: 0,
        isPremium: false,
        termsAccepted: true,
      );

      when(() => mockUsersDao.getUserById(userId)).thenAnswer((_) async => freeUser);
      when(() => mockMatchesDao.countMatchesForUser(userId)).thenAnswer((_) async => 5);

      final canPlay = await service.canParticipateInMatch(
        userId: userId,
        usersDao: mockUsersDao,
        matchesDao: mockMatchesDao,
        syncService: mockSyncService,
        isLocalOnly: true,
      );

      expect(canPlay, isTrue);
    });

    test('Usuários Free NÃO podem participar se atingirem o limite de 10 partidas', () async {
      final freeUser = User(
        id: userId,
        username: 'Free Player',
        email: 'free@test.com',
        password: 'pass',
        xp: 0,
        prestige: 0,
        isPremium: false,
        termsAccepted: true,
      );

      when(() => mockUsersDao.getUserById(userId)).thenAnswer((_) async => freeUser);
      when(() => mockMatchesDao.countMatchesForUser(userId)).thenAnswer((_) async => 10);

      final canPlay = await service.canParticipateInMatch(
        userId: userId,
        usersDao: mockUsersDao,
        matchesDao: mockMatchesDao,
        syncService: mockSyncService,
        isLocalOnly: true,
      );

      expect(canPlay, isFalse);
    });
  });
}
