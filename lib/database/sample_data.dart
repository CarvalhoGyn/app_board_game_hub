import 'package:drift/drift.dart';
import 'database.dart';
import 'csv_importer.dart';

class SampleData {
  static Future<void> insertSampleData(AppDatabase db) async {
    // Import games from CSV if table is empty
    await CsvImporter.importGamesIfEmpty(db);

    final userCount = await (db.select(db.users)..limit(1)).get();
    if (userCount.isNotEmpty) return;

    // Insert Sample Games
    await db.gamesDao.createGame(const GamesCompanion(
      name: Value('Catan'),
      description: Value('Build settlements, roads, and cities on the island of Catan.'),
      imageUrl: Value('https://lh3.googleusercontent.com/aida-public/AB6AXuDuR7tIWQKHg-SYh8Kn_GrJAQIQO_W-tKXZpjJ4byVcw0rlKqnLFOloA3VTcXL1Nvxdk5hfwy_wi54FuKCPsbguMzndThZfd0pk7ZYGzHfmZqbMpOf0qBvs4FJT8A8n6lPVDwM5UlIwHKJhUPtlsEWwAoswTPqQKhTSvwDAMVUAobwn7R0xYjc1ZDCGMx0BglL44QXnmEFrEgbHPSuW9f1UA7o3GoTHYeshF5MSIGgFvWLjaiKQ-QWcJFBg_QlLTJ4Nb5PMF4M7kA'),
      minPlayers: Value(3),
      maxPlayers: Value(4),
    ));

    await db.gamesDao.createGame(const GamesCompanion(
      name: Value('Wingspan'),
      description: Value('Discover and attract the best birds to your wildlife preserves.'),
      imageUrl: Value('https://lh3.googleusercontent.com/aida-public/AB6AXuCKBYu7w8PN3JoWaw6f-17qaZ1qdIs15Cm0tqlvXCH6CDpJl5L0LQZ5MhL4XELw7ATogtCZNfupTFEN4jMfiFtAdXK3k5NmBCvIMS-sbErx6YPd4M7i56aVa56471pqXOxfRdAGpBcnyvtDaAj8spLrldc2vmlPm-ckRkW-_EAO42BFp6u-T5CqvEHo4stAAg0ngmbZbtm63brt9aJsJoMlTmlSD0JecyVEEQrXeXNPvtYujewrXKgxXabrdnvZqdREnjJXP0Bq6A'),
      minPlayers: Value(1),
      maxPlayers: Value(5),
    ));

    await db.gamesDao.createGame(const GamesCompanion(
      name: Value('Gloomhaven'),
      description: Value('Tactical combat in a persistent world of shifting motives.'),
      imageUrl: Value('https://lh3.googleusercontent.com/aida-public/AB6AXuCjBn-F4dYfIcArK1uh_xouSwFNeS19sZKYnGNaqE9zFE38vfYPuouy34Lp--yrJkeK39wEDJt1WBnig4emwYYVBM59htd68_LAbZJA6GhrsDTb7k-lQQVgVu_9KcEqBn3bOPSgfR6rocEZ60ra-xPavtz7in_s8eJEuhJBrp2oADCjn-0-RqzvuiwdRsyoifxd90PHLRMj9kJoin4NpZ5npnt4anVgUvDNXOdDaNdZesSvZS1wxj4i-tAp5SCaSuljgSAknwzpIg'),
      minPlayers: Value(1),
      maxPlayers: Value(4),
    ));

    // Insert a Sample User
    await db.usersDao.createUser(const UsersCompanion(
      username: Value('AlexHunter'),
      email: Value('alex@boardgame.com'),
      password: Value('password123'),
      avatarUrl: Value('https://lh3.googleusercontent.com/aida-public/AB6AXuDQLQVlm2VJVuMiq-VGurWTUzXy0Fd_yOQcQNHKZ_54Dt7F0VtYJ3BAWAnkRAS5bwHO5nWOf9oxa92RVVIqdVq6H17OAF8WHGxGWMuS2-P6hEnZd0qF3TZLnpE6e_KYOTk_kqUYwCX-ip5lt5hM_f0jEqYuDK03Bq-f3poq2G7ZlhI36SVtxBVk9XN7ABU0s7JwzwisC-c0JbqdrX-UYi1liVrJpg56fWeiOkggXd-Wile9InrQob5ZPjRnLr258gwGDJkfiKftiQ'),
    ));
  }
}
