import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:app_board_game_hub/services/gamification_service.dart';
import 'package:app_board_game_hub/database/database.dart';

void main() {
  late AppDatabase db;
  late GamificationService service;

  setUp(() async {
    // Banco em memória para testes limpos
    db = AppDatabase(NativeDatabase.memory());
    service = GamificationService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('GamificationService - XP & Level Logic', () {
    test('getXpRequiredForLevel retorna valores corretos', () {
      expect(GamificationService.getXpRequiredForLevel(0), 0);
      expect(GamificationService.getXpRequiredForLevel(1), 100);
      expect(GamificationService.getXpRequiredForLevel(2), 1100); // 100 + 1000
    });

    test('getLevel retorna o nível correto para o XP', () {
      expect(GamificationService.getLevel(50), 0);
      expect(GamificationService.getLevel(100), 1);
      expect(GamificationService.getLevel(1099), 1);
      expect(GamificationService.getLevel(1100), 2);
    });

    test('getProgressToNextLevel retorna percentual correto', () {
      expect(GamificationService.getProgressToNextLevel(600), 0.5);
      expect(GamificationService.getProgressToNextLevel(100), 0.0);
    });
  });

  group('GamificationService - Operações de Banco', () {
    const String userId = 'user-123';

    test('addXp atualiza o usuário e gera notificação ao subir de nível', () async {
      // 1. Criar usuário inicial
      await db.usersDao.createUser(UsersCompanion.insert(
        id: Value(userId),
        username: 'Test User',
        email: 'test@test.com',
        password: 'password',
        xp: const Value(100), // Lvl 1
      ));

      // 2. Adicionar XP (1000 XP extras levam ao nível 2)
      final newXp = await service.addXp(userId, 1000);

      // 3. Verificar resultados
      expect(newXp, 1100);
      
      final updatedUser = await db.usersDao.getUserById(userId);
      expect(GamificationService.getLevel(updatedUser!.xp), 2);

      final notifications = await db.notificationsDao.getNotifications(userId);
      expect(notifications.any((n) => n.title.contains('LEVEL UP')), isTrue);
    });

    test('prestigeUser reseta XP e incrementa prestige no nível 50', () async {
      final int maxLevelXp = GamificationService.getXpRequiredForLevel(50);
      
      await db.usersDao.createUser(UsersCompanion.insert(
        id: Value(userId),
        username: 'Pro Player',
        email: 'pro@test.com',
        password: 'password',
        xp: Value(maxLevelXp),
      ));

      await service.prestigeUser(userId);

      final user = await db.usersDao.getUserById(userId);
      expect(user!.xp, 0);
      expect(user.prestige, 1);
    });
  });
}
