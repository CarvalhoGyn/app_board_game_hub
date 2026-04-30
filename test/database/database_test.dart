import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:app_board_game_hub/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('UsersDao Tests', () {
    const String userId = 'test-user-id';

    test('Deve criar e recuperar um usuário corretamente', () async {
      await db.usersDao.createUser(UsersCompanion.insert(
        id: Value(userId),
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
      ));

      final user = await db.usersDao.getUserById(userId);
      expect(user, isNotNull);
      expect(user!.username, 'testuser');
      expect(user.email, 'test@example.com');
    });

    test('Deve atualizar os dados de um usuário e gerar entrada no sync_queue', () async {
      await db.usersDao.createUser(UsersCompanion.insert(
        id: Value(userId),
        username: 'oldname',
        email: 'test@example.com',
        password: 'password123',
      ));

      await db.usersDao.updateUser(userId, const UsersCompanion(
        username: Value('newname'),
        xp: Value(500),
      ));

      final updatedUser = await db.usersDao.getUserById(userId);
      expect(updatedUser!.username, 'newname');
      expect(updatedUser.xp, 500);

      // Verificar se o sync_queue tem a tarefa de atualização
      final syncTasks = await db.syncQueueDao.getPendingItems();
      expect(syncTasks.any((t) => t.entity == 'profiles' && t.action == 'UPDATE'), isTrue);
    });
  });

  group('GamesDao Tests', () {
    test('Deve inserir e buscar jogos por nome (search)', () async {
      await db.gamesDao.createGame(GamesCompanion.insert(
        name: 'Catan',
        bggId: const Value(13),
      ));
      await db.gamesDao.createGame(GamesCompanion.insert(
        name: 'Carcassonne',
        bggId: const Value(822),
      ));

      final results = await db.gamesDao.searchGames('Catan');
      expect(results.length, 1);
      expect(results.first.name, 'Catan');

      final allResults = await db.gamesDao.searchGames('Ca');
      expect(allResults.length, 2);
    });
  });

  group('UserAchievementsDao Tests', () {
    test('Deve desbloquear conquistas e evitar duplicatas', () async {
      const String userId = 'user-1';
      const String achId = 'rank_1';

      await db.userAchievementsDao.unlockAchievement(userId, achId);
      final hasAch = await db.userAchievementsDao.hasAchievement(userId, achId);
      expect(hasAch, isTrue);

      final all = await db.userAchievementsDao.getAchievements(userId);
      expect(all.length, 1);

      // Tentar desbloquear novamente (não deve dar erro devido ao insertOrIgnore)
      await db.userAchievementsDao.unlockAchievement(userId, achId);
      final all2 = await db.userAchievementsDao.getAchievements(userId);
      expect(all2.length, 1);
    });
  });
}
