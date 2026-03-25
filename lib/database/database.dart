import 'dart:io';
import 'dart:core' hide Match;
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

class Users extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get username => text().withLength(min: 3, max: 20).unique()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get country => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get prestige => integer().withDefault(const Constant(0))();
  TextColumn get title => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class UserAchievements extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get achievementId => text()(); // e.g. 'first_win'
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<Set<Column>> get uniqueKeys => [{userId, achievementId}];
}

class Games extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  IntColumn get bggId => integer().nullable().unique()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get minPlayers => integer().nullable()();
  IntColumn get maxPlayers => integer().nullable()();
  IntColumn get yearPublished => integer().nullable()();
  IntColumn get rank => integer().nullable()();
  RealColumn get rating => real().nullable()();
  BoolColumn get isEnriched => boolean().withDefault(const Constant(false))();
  
  // Extra fields from BGG enrichment
  IntColumn get minPlaytime => integer().nullable()();
  IntColumn get maxPlaytime => integer().nullable()();
  IntColumn get minAge => integer().nullable()();
  TextColumn get categories => text().nullable()();
  TextColumn get mechanics => text().nullable()();
  
  // New columns for v7 migration (HTML scraping data)
  TextColumn get type => text().nullable()();
  TextColumn get families => text().nullable()();
  TextColumn get integrations => text().nullable()();
  TextColumn get reimplementations => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MatchRow')
class Matches extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get gameId => text().references(Games, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text().nullable()();
  TextColumn get scoringType => text().withDefault(const Constant('competitive'))(); // 'competitive' or 'cooperative'
  @ReferenceName('createdMatches')
  TextColumn get creatorId => text().nullable().references(Users, #id)();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Players extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get matchId => text().references(Matches, #id)();

  TextColumn get userId => text().references(Users, #id)();
  IntColumn get score => integer().nullable()();
  IntColumn get rank => integer().nullable()(); // NEW: Position (1, 2, 3...)
  RealColumn get matchRating => real().nullable()(); // NEW: Rating 0.0 - 5.0
  BoolColumn get isWinner => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class UserGameCollections extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get gameId => text().references(Games, #id)();
  TextColumn get collectionType => text()(); // 'wishlist' or 'owned'
  DateTimeColumn get addedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, gameId, collectionType},
  ];
}

class Friendships extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @ReferenceName('sentFriendships')
  TextColumn get userId => text().references(Users, #id)();
  @ReferenceName('receivedFriendships')
  TextColumn get friendId => text().references(Users, #id)();
  TextColumn get status => text()(); // 'pending', 'accepted', 'rejected'
  DateTimeColumn get requestedAt => dateTime()();
  DateTimeColumn get respondedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, friendId},
  ];
}


class Notifications extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get type => text()(); // friend_request, match_result, system
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get relatedId => text().nullable()(); // ID of match or friendship or user (polymorphic)
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()(); // 'matches', 'players', 'users', etc. -- Renamed from tableName to avoid conflict
  TextColumn get action => text()(); // 'INSERT', 'UPDATE', 'DELETE'
  TextColumn get payload => text()(); // JSON string
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // 'PENDING', 'RETRY', 'FAILED'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

class Reviews extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get gameId => text().references(Games, #id)();
  RealColumn get rating => real()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [{userId, gameId}];
}

@DriftDatabase(
  tables: [Users, Games, Matches, Players, UserGameCollections, Friendships, Notifications, Reviews, UserAchievements, SyncQueue],
  daos: [UsersDao, GamesDao, MatchesDao, UserGameCollectionsDao, FriendshipsDao, NotificationsDao, ReviewsDao, UserAchievementsDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 16;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
         if (from < 2) {
           await m.addColumn(games, games.rank);
         }
         if (from < 3) {
            await m.addColumn(games, games.minPlaytime);
            await m.addColumn(games, games.maxPlaytime);
            await m.addColumn(games, games.minAge);
            await m.addColumn(games, games.categories);
            await m.addColumn(games, games.mechanics);
            await m.addColumn(games, games.isEnriched);
         }
         if (from < 4) {
             await m.createTable(userGameCollections);
         }
         if (from < 5) {
             await m.createTable(friendships);
         }
         if (from < 6) {
           await m.createTable(notifications);
         }
         if (from < 7) {
            await m.createTable(reviews);
         }
         if (from < 8) { // Migration to v8
           await m.addColumn(users, users.latitude);
           await m.addColumn(users, users.longitude);
         }
         if (from < 9) { // Migration to v9
           await m.addColumn(matches, matches.creatorId);
         }
         if (from < 10) { // Migration to v10
            await m.addColumn(users, users.xp);
            await m.addColumn(users, users.title);
            await m.createTable(userAchievements);
         }
         if (from < 11) { // Migration to v11
            await m.addColumn(users, users.prestige);
         }
         if (from < 12) { // Migration to v12
            await m.createTable(syncQueue);
         }
         if (from < 14) { // Migration to v14
            // Note: Changing ID types is complex in SQLite. 
            // For development, we might need to recreate tables or use complex migration.
            // Since we are in dev/refactor phase, we might rely on destructive rebuild if needed,
            // or we accept potential breakage of existing local data.
            // Ideally: Create new tables, copy data transforming IDs, drop old, rename new.
            // For now, implementing basic column Alter if possible or assuming clean slate/reinstall.
         }
         if (from < 16) {
           await m.deleteTable('reviews');
           await m.createTable(reviews);
         }
      }
    );
  }
}

@DriftAccessor(tables: [UserAchievements])
class UserAchievementsDao extends DatabaseAccessor<AppDatabase> with _$UserAchievementsDaoMixin {
  UserAchievementsDao(AppDatabase db) : super(db);

  Future<void> unlockAchievement(String userId, String achievementId) async {
    final companion = UserAchievementsCompanion(
       userId: Value(userId),
       achievementId: Value(achievementId),
       unlockedAt: Value(DateTime.now())
    );
    final rowId = await into(userAchievements).insert(
       companion,
       mode: InsertMode.insertOrIgnore
    );
    
    // Enqueue for cloud sync (assuming Supabase handles uniqueness natively)
    await attachedDatabase.syncQueueDao.enqueue(
      entity: 'user_achievements',
      action: 'INSERT',
      payload: jsonEncode({
         'user_id': userId,
         'achievement_id': achievementId,
         'unlocked_at': companion.unlockedAt.value.toIso8601String()
      }),
    );
  }
  
  Future<List<UserAchievement>> getAchievements(String userId) {
     return (select(userAchievements)..where((u) => u.userId.equals(userId))).get();
  }
  
  Future<bool> hasAchievement(String userId, String achievementId) async {
     final result = await (select(userAchievements)
        ..where((u) => u.userId.equals(userId) & u.achievementId.equals(achievementId))
     ).getSingleOrNull();
     return result != null;
  }
}

@DriftAccessor(tables: [Notifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase> with _$NotificationsDaoMixin {
  NotificationsDao(AppDatabase db) : super(db);

  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    String? relatedId,
  }) {
    return into(notifications).insert(NotificationsCompanion.insert(
      userId: userId,
      type: type,
      title: title,
      message: message,
      relatedId: Value(relatedId),
    ));
  }

  Future<List<Notification>> getNotifications(String userId) {
    return (select(notifications)
          ..where((n) => n.userId.equals(userId))
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();
  }

  Future<int> getUnreadCount(String userId) {
    var count = notifications.id.count();
    return (selectOnly(notifications)
          ..where(notifications.userId.equals(userId) & notifications.isRead.equals(false))
          ..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle()
        .then((value) => value ?? 0);
  }

  Future<void> markAsRead(String notificationId) async {
    await (update(notifications)..where((n) => n.id.equals(notificationId)))
        .write(const NotificationsCompanion(isRead: Value(true)));

    final row = await (select(notifications)..where((n) => n.id.equals(notificationId))).getSingleOrNull();
    if (row != null) {
      await db.syncQueueDao.enqueue(
        entity: 'notifications',
        action: 'UPDATE',
        payload: jsonEncode(row.toJson()),
      );
    }
  }

  Future<void> markAllAsRead(String userId) async {
    await (update(notifications)..where((n) => n.userId.equals(userId)))
        .write(const NotificationsCompanion(isRead: Value(true)));

    final all = await (select(notifications)..where((n) => n.userId.equals(userId))).get();
    for (var row in all) {
      await db.syncQueueDao.enqueue(
        entity: 'notifications',
        action: 'UPDATE',
        payload: jsonEncode(row.toJson()),
      );
    }
  }
}

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<String> createUser(UsersCompanion user) async {
    final row = await into(users).insertReturning(user);
    return row.id;
  }
  Future<User?> getUserByEmail(String email) => (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
  Future<User?> getUserById(String id) => (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  Future<User?> login(String identifier, String password) => 
      (select(users)..where((u) => (u.email.equals(identifier) | u.username.equals(identifier)) & u.password.equals(password))).getSingleOrNull();
  
  Future<List<User>> searchUsersByNickname(String query) {
    return (select(users)
          ..where((u) => u.username.upper().contains(query.toUpperCase()))
          ..limit(20))
        .get();
  }

  Future<void> updateUser(String id, UsersCompanion user) async {
    await (update(users)..where((u) => u.id.equals(id))).write(user);
    
    final payload = <String, dynamic>{'id': id};
    if (user.xp.present) payload['xp'] = user.xp.value;
    if (user.avatarUrl.present) payload['avatar_url'] = user.avatarUrl.value;
    if (user.firstName.present) payload['first_name'] = user.firstName.value;
    if (user.lastName.present) payload['last_name'] = user.lastName.value;
    if (user.username.present) payload['username'] = user.username.value;
    if (user.prestige.present) payload['prestige'] = user.prestige.value;
    
    await attachedDatabase.syncQueueDao.enqueue(
      entity: 'profiles',
      action: 'UPDATE',
      payload: jsonEncode(payload),
    );
  }

  Future<void> upsertUser(User user) async {
    await into(users).insertOnConflictUpdate(user);
  }
}

@DriftAccessor(tables: [UserGameCollections, Games])
class UserGameCollectionsDao extends DatabaseAccessor<AppDatabase> with _$UserGameCollectionsDaoMixin {
  UserGameCollectionsDao(super.db);

  Future<void> addToWishlist(String userId, String gameId) async {
    final row = await into(userGameCollections).insertReturning(
      UserGameCollectionsCompanion(
        userId: Value(userId),
        gameId: Value(gameId),
        collectionType: const Value('wishlist'),
        addedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrReplace,
    );
    
    await db.syncQueueDao.enqueue(
      entity: 'user_collections',
      action: 'INSERT',
      payload: jsonEncode(row.toJson()),
    );
  }

  Future<void> addToCollection(String userId, String gameId) async {
    final row = await into(userGameCollections).insertReturning(
      UserGameCollectionsCompanion(
        userId: Value(userId),
        gameId: Value(gameId),
        collectionType: const Value('owned'),
        addedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrReplace,
    );
    
    await db.syncQueueDao.enqueue(
      entity: 'user_collections',
      action: 'INSERT',
      payload: jsonEncode(row.toJson()),
    );
  }

  Future<void> removeFromCollection(String userId, String gameId, String type) async {
    // We need the ID for sync delete, so we select first
    final row = await (select(userGameCollections)
      ..where((c) => 
          c.userId.equals(userId) & 
          c.gameId.equals(gameId) & 
          c.collectionType.equals(type))).getSingleOrNull();

    if (row != null) {
      await (delete(userGameCollections)..where((c) => c.id.equals(row.id))).go();
      
      await db.syncQueueDao.enqueue(
        entity: 'user_collections',
        action: 'DELETE',
        payload: jsonEncode({'id': row.id}),
      );
    }
  }

  // --- ONLINE-FIRST HELPERS (No Sync Queue) ---
  
  Future<void> saveLocalCollectionItem(UserGameCollection item) async {
    await into(userGameCollections).insert(item, mode: InsertMode.insertOrReplace);
  }
  
  Future<void> deleteLocalCollectionItem(String id) async {
    await (delete(userGameCollections)..where((c) => c.id.equals(id))).go();
  }

  Future<List<Game>> getWishlist(String userId) async {
    final query = select(userGameCollections).join([
      innerJoin(games, games.id.equalsExp(userGameCollections.gameId)),
    ])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('wishlist'));

    return query.map((row) => row.readTable(games)).get();
  }

  Future<List<Game>> getOwnedGames(String userId) async {
    final query = select(userGameCollections).join([
      innerJoin(games, games.id.equalsExp(userGameCollections.gameId)),
    ])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('owned'));

    return query.map((row) => row.readTable(games)).get();
  }

  Future<bool> isInWishlist(String userId, String gameId) async {
    final result = await (select(userGameCollections)
          ..where((c) => 
              c.userId.equals(userId) & 
              c.gameId.equals(gameId) & 
              c.collectionType.equals('wishlist')))
        .getSingleOrNull();
    return result != null;
  }

  Future<bool> isOwned(String userId, String gameId) async {
    final result = await (select(userGameCollections)
          ..where((c) => 
              c.userId.equals(userId) & 
              c.gameId.equals(gameId) & 
              c.collectionType.equals('owned')))
        .getSingleOrNull();
    return result != null;
  }

  Future<int> getWishlistCount(String userId) async {
    final countExp = userGameCollections.id.count();
    final query = selectOnly(userGameCollections)
      ..addColumns([countExp])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('wishlist'));
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<int> getOwnedCount(String userId) async {
    final countExp = userGameCollections.id.count();
    final query = selectOnly(userGameCollections)
      ..addColumns([countExp])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('owned'));
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}

@DriftAccessor(tables: [Friendships, Users])
class FriendshipsDao extends DatabaseAccessor<AppDatabase> with _$FriendshipsDaoMixin {
  FriendshipsDao(super.db);

  Future<void> sendFriendRequest(String userId, String friendId) async {
    await into(friendships).insert(
      FriendshipsCompanion.insert(
        userId: userId,
        friendId: friendId,
        status: 'pending',
        requestedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore,
    );
    
    // Create notification for the friend
    final sender = await db.usersDao.getUserById(userId);
    if (sender != null) {
      await db.notificationsDao.createNotification(
        userId: friendId,
        type: 'friend_request',
        title: 'New Friend Request',
        message: '${sender.username} wants to be your friend!',
        relatedId: userId,
      );
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    final friendship = await (select(friendships)..where((f) => f.id.equals(requestId))).getSingle();

    await (update(friendships)..where((f) => f.id.equals(requestId))).write(
      FriendshipsCompanion(
        status: const Value('accepted'),
        respondedAt: Value(DateTime.now()),
      ),
    );
    
    // Create reverse friendship for bidirectional relationship
    await into(friendships).insert(
      FriendshipsCompanion.insert(
        userId: friendship.friendId,
        friendId: friendship.userId,
        status: 'accepted',
        requestedAt: DateTime.now(),
        respondedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    // Create notification for the sender
    final user = await db.usersDao.getUserById(friendship.friendId);
    if (user != null) {
      await db.notificationsDao.createNotification(
        userId: friendship.userId,
        type: 'friend_request',
        title: 'Friend Request Accepted',
        message: '${user.username} accepted your friend request!',
        relatedId: friendship.friendId,
      );
    }
  }

  Future<void> rejectFriendRequest(String requestId) {
    return (update(friendships)..where((f) => f.id.equals(requestId))).write(
      FriendshipsCompanion(
        status: const Value('rejected'),
        respondedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<User>> getFriends(String userId) async {
    final query = select(users).join([
      innerJoin(friendships, 
        (friendships.userId.equalsExp(users.id) & friendships.friendId.equals(userId)) |
        (friendships.friendId.equalsExp(users.id) & friendships.userId.equals(userId))
      ),
    ])
      ..where(friendships.status.equals('accepted'));

    return query.map((row) => row.readTable(users)).get();
  }

  Future<List<FriendshipWithUser>> getPendingRequests(String userId) async {
    final query = select(friendships).join([
      innerJoin(users, users.id.equalsExp(friendships.userId)),
    ])
      ..where(friendships.friendId.equals(userId) & 
              friendships.status.equals('pending'));

    return query.map((row) {
      return FriendshipWithUser(
        friendship: row.readTable(friendships),
        user: row.readTable(users),
      );
    }).get();
  }

  Future<int> getFriendCount(String userId) async {
    final countExp = friendships.id.count();
    final query = selectOnly(friendships)
      ..addColumns([countExp])
      ..where((friendships.userId.equals(userId) | friendships.friendId.equals(userId)) & 
              friendships.status.equals('accepted'));
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<String?> getFriendshipStatus(String userId, String friendId) async {
    final result = await (select(friendships)
          ..where((f) => 
              (f.userId.equals(userId) & f.friendId.equals(friendId)) |
              (f.userId.equals(friendId) & f.friendId.equals(userId)))
          ..limit(1))
        .getSingleOrNull();
    return result?.status;
  }

  // --- ONLINE-FIRST HELPERS (No Sync Queue) ---
  
  Future<void> saveLocalFriendship(Friendship f) async {
    await into(friendships).insert(f, mode: InsertMode.insertOrReplace);
  }
  
  Future<void> updateLocalFriendshipStatus(String id, String status, DateTime? respondedAt) async {
    await (update(friendships)..where((f) => f.id.equals(id))).write(
      FriendshipsCompanion(
        status: Value(status),
        respondedAt: Value(respondedAt),
      ),
    );
  }
}

@DriftAccessor(tables: [Games])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(super.db);

  Future<String> createGame(GamesCompanion game) async {
    return transaction(() async {
      final row = await into(games).insertReturning(game);
      
      await db.syncQueueDao.enqueue(
        entity: 'games',
        action: 'INSERT',
        payload: jsonEncode(row.toJson()),
      );
      
      return row.id;
    });
  }
  Future<List<Game>> getAllGames() => select(games).get();
  Future<Game?> getGameById(String id) => (select(games)..where((g) => g.id.equals(id))).getSingleOrNull();
  Future<Game?> getGameByBggId(int bggId) => (select(games)..where((g) => g.bggId.equals(bggId))).getSingleOrNull();

  Future<void> upsertGame(GamesCompanion game) async {
    await transaction(() async {
      await into(games).insertOnConflictUpdate(game);
      // We don't easily get the row back from insertOnConflictUpdate in generic Drift without query.
      // But we can approximate functionality or just skip sync for update if assuming it exists?
      // Better to fetch and sync.
      
      // Note: upsertGame is often used for bulk or cache. Syncing every upsert might be noisy.
      // But for consistency we should.
      // Let's implement a 'safe' enqueue if ID is known.
      if (game.id.present) {
         final row = await (select(games)..where((g) => g.id.equals(game.id.value))).getSingle();
         await db.syncQueueDao.enqueue(
            entity: 'games',
            action: 'INSERT', // Treat as Upsert intent
            payload: jsonEncode(row.toJson()),
         );
      }
    });
  }

  Future<List<Game>> searchGames(String query) {
    return (select(games)
          ..where((g) => g.name.upper().contains(query.toUpperCase()))
          ..limit(20))
        .get();
  }

  Future<int> getGameCount() async {
    final countExp = games.id.count();
    final query = selectOnly(games)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}

@DriftAccessor(tables: [Matches, Players, Users, Games])
class MatchesDao extends DatabaseAccessor<AppDatabase> with _$MatchesDaoMixin {
  MatchesDao(super.db);
  
  // --- ONLINE-FIRST HELPERS (No Sync Queue) ---
  
  Future<void> saveLocalMatch(MatchRow match, List<Player> matchPlayers) async {
    await transaction(() async {
       await into(matches).insert(match, mode: InsertMode.insertOrReplace);
       for (var player in matchPlayers) {
          await into(players).insert(player, mode: InsertMode.insertOrReplace);
       }
    });
  }

  Future<String> createMatch(MatchesCompanion match, List<PlayersCompanion> matchPlayers) async {
    return transaction(() async {
      final matchRow = await into(matches).insertReturning(match);
      final matchId = matchRow.id;
      for (var player in matchPlayers) {
        await into(players).insert(player.copyWith(matchId: Value(matchId)));
      }
      // Queue for Sync
      await db.syncQueueDao.enqueue(
        entity: 'matches',
        action: 'INSERT',
        payload: jsonEncode(matchRow.toJson()),
      );
      
      // Players are technically separate inserts, but for Matches we might want to sync them together?
      // Or sync purely by table. Simpler to sync by table.
      for (var player in matchPlayers) {
        final p = player.copyWith(matchId: Value(matchId));
        final playerRow = await into(players).insertReturning(p);
        
        await db.syncQueueDao.enqueue(
           entity: 'match_players',
           action: 'INSERT',
           payload: jsonEncode(playerRow.toJson()),
        );
      }
      return matchId;
    });
  }

  Future<List<MatchWithDetails>> getMatchesForUser(String userId) async {
    // Join matches -> players (filter by user) -> games
    final query = select(matches).join([
       innerJoin(games, games.id.equalsExp(matches.gameId)),
       innerJoin(players, players.matchId.equalsExp(matches.id)), 
    ])..where(players.userId.equals(userId))
      ..orderBy([OrderingTerm.desc(matches.date)]);
      
    // Map to MatchWithDetails. Note: this returns one row per player-match combo if we aren't careful, 
    // but players table has one entry per user per match, so filtering by userId ensures unique matches.
    return query.map((row) {
      return MatchWithDetails(
        match: row.readTable(matches),
        game: row.readTable(games),
        player: row.readTableOrNull(players),
      );
    }).get();
  }

  Stream<List<MatchWithDetails>> watchMatchesForUser(String userId) {
    final query = select(matches).join([
       innerJoin(games, games.id.equalsExp(matches.gameId)),
       innerJoin(players, players.matchId.equalsExp(matches.id)), 
    ])..where(players.userId.equals(userId))
      ..orderBy([OrderingTerm.desc(matches.date)]);
      
    return query.watch().map((rows) {
      return rows.map((row) {
        return MatchWithDetails(
          match: row.readTable(matches),
          game: row.readTable(games),
          player: row.readTableOrNull(players),
        );
      }).toList();
    });
  }

  Future<List<MatchWithDetails>> getRecentMatches() async {
    final query = select(matches).join([
      innerJoin(games, games.id.equalsExp(matches.gameId)),
    ]);

    return query.map((row) {
      return MatchWithDetails(
        match: row.readTable(matches),
        game: row.readTable(games),
        player: null, // Recent matches don't filter by a specific player context by default
      );
    }).get();
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final matchCount = await (select(players)..where((p) => p.userId.equals(userId))).get();
    final winCount = await (select(players)..where((p) => p.userId.equals(userId) & p.isWinner.equals(true))).get();
    
    // This is simple for now, can be expanded to join with Games for more details
    return {
      'matches': matchCount.length,
      'wins': winCount.length,
    };
  }

  Future<MatchWithDetails?> getMatchWithDetails(String matchId) async {
    final query = select(matches).join([
      innerJoin(games, games.id.equalsExp(matches.gameId)),
    ])..where(matches.id.equals(matchId));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return MatchWithDetails(
      match: row.readTable(matches),
      game: row.readTable(games),
    );
  }

  Future<List<PlayerWithUser>> getPlayersForMatch(String matchId) async {
    final query = (select(players).join([
      innerJoin(users, users.id.equalsExp(players.userId)),
    ])..where(players.matchId.equals(matchId)));

    return query.map((row) {
      return PlayerWithUser(
        player: row.readTable(players),
        user: row.readTable(users),
      );
    }).get();
  }

  Future<void> updatePlayerResult(String playerId, int rank, bool isWinner, double? rating) async {
    await (update(players)..where((p) => p.id.equals(playerId))).write(
      PlayersCompanion(
        rank: Value(rank),
        isWinner: Value(isWinner),
        matchRating: Value(rating),
      ),
    );

    final playerRow = await (select(players)..where((p) => p.id.equals(playerId))).getSingleOrNull();
    if (playerRow != null) {
       await db.syncQueueDao.enqueue(
          entity: 'match_players',
          action: 'UPDATE',
          payload: jsonEncode(playerRow.toJson()),
       );
    }
  }

  Future<List<Game>> getTrendingGames(int limit) async {
    final countExp = matches.id.count();
    final query = selectOnly(matches)
      ..addColumns([matches.gameId, countExp])
      ..groupBy([matches.gameId])
      ..orderBy([OrderingTerm.desc(countExp)])
      ..limit(limit);
    
    final results = await query.get();
    final gameIds = results.map((row) => row.read(matches.gameId)!).toList();
    
    if (gameIds.isEmpty) return [];
    
    return (select(games)..where((g) => g.id.isIn(gameIds))).get();
  }

  Future<List<Game>> getRecommendedGames(String userId, int maxCount) async {
    // 1. Get games user has played
    // 1. Get games user has played
    final playedGameIds = await (selectOnly(players)
      ..addColumns([matches.gameId])
      ..where(players.userId.equals(userId))
      ..join([
         innerJoin(matches, matches.id.equalsExp(players.matchId))
      ])
    ).map((row) => row.read(matches.gameId)!).get();
    
    // Unique game IDs
    final uniquePlayedIds = playedGameIds.toSet(); // Set for O(1) lookup

    // 2. Get types of those games
    List<String> userTypes = [];
    if (uniquePlayedIds.isNotEmpty) {
       final types = await (selectOnly(games)
         ..addColumns([games.type])
         ..where(games.id.isIn(uniquePlayedIds.toList()) & games.type.isNotNull())
       ).map((row) => row.read(games.type)).get();
       userTypes = types.where((t) => t != null).cast<String>().toSet().toList();
    }
    
    // 3. Find games with similar types or high popularity not played by user
    // STRATEGY: Fetch widely (Top 100) and filter purely in Dart to avoid ANY Drift SQL expression issues.
    
    // Fetch top 100 rated games
    final candidates = await (select(games)
      ..orderBy([(g) => OrderingTerm.desc(g.rating)])
      ..limit(100)
    ).get();
    
    List<Game> results = [];
    
    // Filter candidates: Must NOT be played
    final unplayedCandidates = candidates.where((g) => !uniquePlayedIds.contains(g.id)).toList();
    
    if (userTypes.isNotEmpty) {
       // Priority 1: Games with matching Type
       final typeMatches = unplayedCandidates.where((g) => g.type != null && userTypes.contains(g.type)).toList();
       results.addAll(typeMatches);
       
       // Remove matches from candidates to avoid duplicates in fallback
       for (var m in typeMatches) {
          unplayedCandidates.removeWhere((c) => c.id == m.id);
       }
    }
    
    // Fill remaining spots with highest rated remaining unplayed candidates
    if (results.length < maxCount) {
       final remaining = maxCount - results.length;
       results.addAll(unplayedCandidates.take(remaining));
    }
    
    return results.take(maxCount).toList();
  }

  Future<List<GameStats>> getTopPlayedGames(int limit) async {
    final matchCountExp = matches.id.count(distinct: true);
    final totalPlayersExp = players.id.count();

    final query = selectOnly(matches).join([
      innerJoin(games, games.id.equalsExp(matches.gameId)),
      innerJoin(players, players.matchId.equalsExp(matches.id)),
    ])
      ..addColumns([games.id, matchCountExp, totalPlayersExp])
      ..groupBy([games.id])
      ..orderBy([OrderingTerm.desc(matchCountExp)])
      ..limit(limit);

    final results = await query.get();
    
    // We also need the game data. Since selectOnly with join and group by 
    // can be tricky with full table reads, we'll fetch stats and then the games or join carefully.
    // In Drift, readTable only works if the table is added to columns.
    
    // Alternative approach:
    List<GameStats> stats = [];
    for (final row in results) {
      final gId = row.read(games.id); // This will work if games.id is added
      if (gId == null) continue;
      
      final game = await (select(games)..where((g) => g.id.equals(gId))).getSingle();
      stats.add(GameStats(
        game: game,
        matchCount: row.read(matchCountExp) ?? 0,
        totalPlayers: row.read(totalPlayersExp) ?? 0,
      ));
    }
    return stats;
  }
}

@DriftAccessor(tables: [Reviews, Users])
class ReviewsDao extends DatabaseAccessor<AppDatabase> with _$ReviewsDaoMixin {
  ReviewsDao(super.db);

  Future<void> saveLocalReview(Review review) async {
    await into(reviews).insertOnConflictUpdate(review);
  }

  Future<void> addReview(ReviewsCompanion review) async {
    // Standard offline-first fallback if needed, but primary is via SupabaseSyncService
    return transaction(() async {
      await into(reviews).insertOnConflictUpdate(review);
      
      final row = await (select(reviews)
        ..where((r) => r.userId.equals(review.userId.value) & r.gameId.equals(review.gameId.value))
      ).getSingle();

      await db.syncQueueDao.enqueue(
        entity: 'reviews',
        action: 'INSERT',
        payload: jsonEncode(row.toJson()),
      );
    });
  }
  
  Future<List<ReviewWithUser>> getReviewsForGame(String gameId) async {
    final query = select(reviews).join([
      innerJoin(users, users.id.equalsExp(reviews.userId)),
    ])..where(reviews.gameId.equals(gameId))
      ..orderBy([OrderingTerm.desc(reviews.createdAt)]);

    return query.map((row) {
      return ReviewWithUser(
        review: row.readTable(reviews),
        user: row.readTable(users),
      );
    }).get();
  }
}

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<void> enqueue({
    required String entity,
    required String action, // INSERT, UPDATE, DELETE
    required String payload, // JSON
  }) async {
    await into(syncQueue).insert(
      SyncQueueCompanion.insert(
        entity: entity,
        action: action,
        payload: payload,
        status: const Value('PENDING'),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<SyncQueueData>> getPendingItems() => 
    (select(syncQueue)..where((s) => s.status.equals('PENDING'))).get();

  Future<void> markAsCompleted(int id) =>
    (delete(syncQueue)..where((s) => s.id.equals(id))).go();

  Future<void> markAsFailed(int id) =>
    (update(syncQueue)..where((s) => s.id.equals(id))).write(const SyncQueueCompanion(status: Value('FAILED')));

  Future<void> retryFailedItems() {
    return (update(syncQueue)..where((s) => s.status.equals('FAILED')))
      .write(const SyncQueueCompanion(status: Value('PENDING')));
  }
}

class ReviewWithUser {
  final Review review;
  final User user;
  ReviewWithUser({required this.review, required this.user});
}

class MatchWithDetails {
  final MatchRow match;
  final Game game;
  final Player? player;

  MatchWithDetails({required this.match, required this.game, this.player});
}

class PlayerWithUser {
  final Player player;
  final User user;

  PlayerWithUser({required this.player, required this.user});
}

class GameStats {
  final Game game;
  final int matchCount;
  final int totalPlayers;

  GameStats({
    required this.game,
    required this.matchCount,
    required this.totalPlayers,
  });
}

class FriendshipWithUser {
  final Friendship friendship;
  final User user;

  FriendshipWithUser({required this.friendship, required this.user});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    final cachebase = await getTemporaryDirectory();
    sqlite3.tempDirectory = cachebase.path;

    return NativeDatabase.createInBackground(file);
  });
}
