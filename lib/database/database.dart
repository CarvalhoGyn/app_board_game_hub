import 'dart:io';
import 'dart:core' hide Match;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
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
}

class UserAchievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get achievementId => text()(); // e.g. 'first_win'
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<Set<Column>> get uniqueKeys => [{userId, achievementId}];
}

class Games extends Table {
  IntColumn get id => integer().autoIncrement()();

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
}

@DataClassName('MatchRow')
class Matches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(Games, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text().nullable()();
  TextColumn get scoringType => text().withDefault(const Constant('competitive'))(); // 'competitive' or 'cooperative'
  @ReferenceName('createdMatches')
  IntColumn get creatorId => integer().nullable().references(Users, #id)();
}

class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get matchId => integer().references(Matches, #id)();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get score => integer().nullable()();
  IntColumn get rank => integer().nullable()(); // NEW: Position (1, 2, 3...)
  RealColumn get matchRating => real().nullable()(); // NEW: Rating 0.0 - 5.0
  BoolColumn get isWinner => boolean().withDefault(const Constant(false))();
}

class UserGameCollections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get gameId => integer().references(Games, #id)();
  TextColumn get collectionType => text()(); // 'wishlist' or 'owned'
  DateTimeColumn get addedAt => dateTime()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, gameId, collectionType},
  ];
}

class Friendships extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('sentFriendships')
  IntColumn get userId => integer().references(Users, #id)();
  @ReferenceName('receivedFriendships')
  IntColumn get friendId => integer().references(Users, #id)();
  TextColumn get status => text()(); // 'pending', 'accepted', 'rejected'
  DateTimeColumn get requestedAt => dateTime()();
  DateTimeColumn get respondedAt => dateTime().nullable()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, friendId},
  ];
}


class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text()(); // friend_request, match_result, system
  TextColumn get title => text()();
  TextColumn get message => text()();
  IntColumn get relatedId => integer().nullable()(); // ID of match or friendship
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Reviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get gameId => integer().references(Games, #id)();
  RealColumn get rating => real()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<Set<Column>> get uniqueKeys => [{userId, gameId}];
}

@DriftDatabase(
  tables: [Users, Games, Matches, Players, UserGameCollections, Friendships, Notifications, Reviews, UserAchievements],
  daos: [UsersDao, GamesDao, MatchesDao, UserGameCollectionsDao, FriendshipsDao, NotificationsDao, ReviewsDao, UserAchievementsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 11;

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
      }
    );
  }
}

@DriftAccessor(tables: [UserAchievements])
class UserAchievementsDao extends DatabaseAccessor<AppDatabase> with _$UserAchievementsDaoMixin {
  UserAchievementsDao(AppDatabase db) : super(db);

  Future<void> unlockAchievement(int userId, String achievementId) {
    return into(userAchievements).insert(
       UserAchievementsCompanion(
          userId: Value(userId),
          achievementId: Value(achievementId),
          unlockedAt: Value(DateTime.now())
       ),
       mode: InsertMode.insertOrIgnore
    );
  }
  
  Future<List<UserAchievement>> getAchievements(int userId) {
     return (select(userAchievements)..where((u) => u.userId.equals(userId))).get();
  }
  
  Future<bool> hasAchievement(int userId, String achievementId) async {
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
    required int userId,
    required String type,
    required String title,
    required String message,
    int? relatedId,
  }) {
    return into(notifications).insert(NotificationsCompanion.insert(
      userId: userId,
      type: type,
      title: title,
      message: message,
      relatedId: Value(relatedId),
    ));
  }

  Future<List<Notification>> getNotifications(int userId) {
    return (select(notifications)
          ..where((n) => n.userId.equals(userId))
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();
  }

  Future<int> getUnreadCount(int userId) {
    var count = notifications.id.count();
    return (selectOnly(notifications)
          ..where(notifications.userId.equals(userId) & notifications.isRead.equals(false))
          ..addColumns([count]))
        .map((row) => row.read(count))
        .getSingle()
        .then((value) => value ?? 0);
  }

  Future<void> markAsRead(int notificationId) {
    return (update(notifications)
      ..where((n) => n.id.equals(notificationId))
    ).write(const NotificationsCompanion(isRead: Value(true)));
  }
  
  Future<void> markAllAsRead(int userId) {
    return (update(notifications)
      ..where((n) => n.userId.equals(userId))
    ).write(const NotificationsCompanion(isRead: Value(true)));
  }
}

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<int> createUser(UsersCompanion user) => into(users).insert(user);
  Future<User?> getUserByEmail(String email) => (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
  Future<User?> getUserById(int id) => (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  Future<User?> login(String identifier, String password) => 
      (select(users)..where((u) => (u.email.equals(identifier) | u.username.equals(identifier)) & u.password.equals(password))).getSingleOrNull();
  
  Future<List<User>> searchUsersByNickname(String query) {
    return (select(users)
          ..where((u) => u.username.upper().contains(query.toUpperCase()))
          ..limit(20))
        .get();
  }

  Future<void> updateUser(int id, UsersCompanion user) {
    return (update(users)..where((u) => u.id.equals(id))).write(user);
  }
}

@DriftAccessor(tables: [UserGameCollections, Games])
class UserGameCollectionsDao extends DatabaseAccessor<AppDatabase> with _$UserGameCollectionsDaoMixin {
  UserGameCollectionsDao(super.db);

  Future<void> addToWishlist(int userId, int gameId) async {
    await into(userGameCollections).insert(
      UserGameCollectionsCompanion(
        userId: Value(userId),
        gameId: Value(gameId),
        collectionType: const Value('wishlist'),
        addedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> addToCollection(int userId, int gameId) async {
    await into(userGameCollections).insert(
      UserGameCollectionsCompanion(
        userId: Value(userId),
        gameId: Value(gameId),
        collectionType: const Value('owned'),
        addedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> removeFromCollection(int userId, int gameId, String type) {
    return (delete(userGameCollections)
          ..where((c) => 
              c.userId.equals(userId) & 
              c.gameId.equals(gameId) & 
              c.collectionType.equals(type)))
        .go();
  }

  Future<List<Game>> getWishlist(int userId) async {
    final query = select(userGameCollections).join([
      innerJoin(games, games.id.equalsExp(userGameCollections.gameId)),
    ])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('wishlist'));

    return query.map((row) => row.readTable(games)).get();
  }

  Future<List<Game>> getOwnedGames(int userId) async {
    final query = select(userGameCollections).join([
      innerJoin(games, games.id.equalsExp(userGameCollections.gameId)),
    ])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('owned'));

    return query.map((row) => row.readTable(games)).get();
  }

  Future<bool> isInWishlist(int userId, int gameId) async {
    final result = await (select(userGameCollections)
          ..where((c) => 
              c.userId.equals(userId) & 
              c.gameId.equals(gameId) & 
              c.collectionType.equals('wishlist')))
        .getSingleOrNull();
    return result != null;
  }

  Future<bool> isOwned(int userId, int gameId) async {
    final result = await (select(userGameCollections)
          ..where((c) => 
              c.userId.equals(userId) & 
              c.gameId.equals(gameId) & 
              c.collectionType.equals('owned')))
        .getSingleOrNull();
    return result != null;
  }

  Future<int> getWishlistCount(int userId) async {
    final countExp = userGameCollections.id.count();
    final query = selectOnly(userGameCollections)
      ..addColumns([countExp])
      ..where(userGameCollections.userId.equals(userId) & 
              userGameCollections.collectionType.equals('wishlist'));
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<int> getOwnedCount(int userId) async {
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

  Future<void> sendFriendRequest(int userId, int friendId) async {
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

  Future<void> acceptFriendRequest(int requestId) async {
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

  Future<void> rejectFriendRequest(int requestId) {
    return (update(friendships)..where((f) => f.id.equals(requestId))).write(
      FriendshipsCompanion(
        status: const Value('rejected'),
        respondedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<User>> getFriends(int userId) async {
    final query = select(friendships).join([
      innerJoin(users, users.id.equalsExp(friendships.friendId)),
    ])
      ..where(friendships.userId.equals(userId) & 
              friendships.status.equals('accepted'));

    return query.map((row) => row.readTable(users)).get();
  }

  Future<List<FriendshipWithUser>> getPendingRequests(int userId) async {
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

  Future<int> getFriendCount(int userId) async {
    final countExp = friendships.id.count();
    final query = selectOnly(friendships)
      ..addColumns([countExp])
      ..where(friendships.userId.equals(userId) & 
              friendships.status.equals('accepted'));
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<String?> getFriendshipStatus(int userId, int friendId) async {
    final result = await (select(friendships)
          ..where((f) => 
              (f.userId.equals(userId) & f.friendId.equals(friendId)) |
              (f.userId.equals(friendId) & f.friendId.equals(userId)))
          ..limit(1))
        .getSingleOrNull();
    return result?.status;
  }
}

@DriftAccessor(tables: [Games])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(super.db);

  Future<int> createGame(GamesCompanion game) => into(games).insert(game);
  Future<List<Game>> getAllGames() => select(games).get();
  Future<Game?> getGameById(int id) => (select(games)..where((g) => g.id.equals(id))).getSingleOrNull();
  Future<Game?> getGameByBggId(int bggId) => (select(games)..where((g) => g.bggId.equals(bggId))).getSingleOrNull();

  Future<void> upsertGame(GamesCompanion game) async {
    await into(games).insertOnConflictUpdate(game);
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

  Future<int> createMatch(MatchesCompanion match, List<PlayersCompanion> matchPlayers) async {
    return transaction(() async {
      final matchId = await into(matches).insert(match);
      for (var player in matchPlayers) {
        await into(players).insert(player.copyWith(matchId: Value(matchId)));
      }
      return matchId;
    });
  }

  Future<List<MatchWithDetails>> getMatchesForUser(int userId) async {
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
      );
    }).get();
  }

  Future<List<MatchWithDetails>> getRecentMatches() async {
    final query = select(matches).join([
      innerJoin(games, games.id.equalsExp(matches.gameId)),
    ]);

    return query.map((row) {
      return MatchWithDetails(
        match: row.readTable(matches),
        game: row.readTable(games),
      );
    }).get();
  }

  Future<Map<String, dynamic>> getUserStats(int userId) async {
    final matchCount = await (select(players)..where((p) => p.userId.equals(userId))).get();
    final winCount = await (select(players)..where((p) => p.userId.equals(userId) & p.isWinner.equals(true))).get();
    
    // This is simple for now, can be expanded to join with Games for more details
    return {
      'matches': matchCount.length,
      'wins': winCount.length,
    };
  }

  Future<MatchWithDetails?> getMatchWithDetails(int matchId) async {
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

  Future<List<PlayerWithUser>> getPlayersForMatch(int matchId) async {
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

  Future<void> updatePlayerResult(int playerId, int rank, bool isWinner, double? rating) {
    return (update(players)..where((p) => p.id.equals(playerId))).write(
      PlayersCompanion(
        rank: Value(rank),
        isWinner: Value(isWinner),
        matchRating: Value(rating),
      ),
    );
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

  Future<List<Game>> getRecommendedGames(int userId, int maxCount) async {
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
}

@DriftAccessor(tables: [Reviews, Users])
class ReviewsDao extends DatabaseAccessor<AppDatabase> with _$ReviewsDaoMixin {
  ReviewsDao(super.db);

  Future<void> addReview(ReviewsCompanion review) => into(reviews).insertOnConflictUpdate(review);
  
  Future<List<ReviewWithUser>> getReviewsForGame(int gameId) async {
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

class ReviewWithUser {
  final Review review;
  final User user;
  ReviewWithUser({required this.review, required this.user});
}

class MatchWithDetails {
  final MatchRow match;
  final Game game;

  MatchWithDetails({required this.match, required this.game});
}

class PlayerWithUser {
  final Player player;
  final User user;

  PlayerWithUser({required this.player, required this.user});
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
