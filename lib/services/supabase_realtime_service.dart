import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../database/database.dart';
import 'supabase_sync_service.dart';

/// Manages Supabase Realtime subscriptions for live updates.
/// Listens to `notifications` and `friendships` table changes for the
/// current user and keeps the local Drift DB in sync instantly.
class SupabaseRealtimeService extends ChangeNotifier {
  final AppDatabase _db;
  final SupabaseClient _supabase;

  RealtimeChannel? _channel;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  /// Set to true while an event is being processed so listeners can show loaders.
  bool _hasPendingUpdate = false;
  bool get hasPendingUpdate => _hasPendingUpdate;

  SupabaseRealtimeService(this._db)
      : _supabase = Supabase.instance.client;

  /// Subscribe to realtime changes. Call this after the user logs in.
  Future<void> subscribe(String userId) async {
    // Unsubscribe any previous channel first
    await unsubscribe();

    debugPrint('Realtime: Subscribing for user $userId');

    _channel = _supabase
        .channel('user_realtime_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => _onNotificationInsert(payload),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'friendships',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'friend_id',
            value: userId,
          ),
          callback: (payload) => _onFriendshipInsert(payload, userId),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'friendships',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => _onFriendshipUpdate(payload),
        )
        // Also listen for updates where I am the recipient (friend_id)
        // e.g. when the sender adds me back or status changes
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'friendships',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'friend_id',
            value: userId,
          ),
          callback: (payload) => _onFriendshipUpdate(payload),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'match_players',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => _onMatchPlayerInsert(payload),
        )
        .subscribe();

    // Refresh initial unread count
    await _refreshUnreadCount(userId);
  }

  /// Unsubscribe from all channels. Call on logout.
  Future<void> unsubscribe() async {
    if (_channel != null) {
      debugPrint('Realtime: Unsubscribing');
      await _supabase.removeChannel(_channel!);
      _channel = null;
    }
    _unreadCount = 0;
  }

  Future<void> _onNotificationInsert(PostgresChangePayload payload) async {
    try {
      debugPrint('Realtime: New notification received');
      _hasPendingUpdate = true;
      notifyListeners();

      final data = payload.newRecord;
      final syncService = SupabaseSyncService(_db);
      final camelData = syncService.toCamelCaseMapPublic(data);

      // insertOnConflictUpdate is idempotent by primary key (id) — safe against duplicates
      await _db.into(_db.notifications).insertOnConflictUpdate(Notification.fromJson(camelData));

      await _refreshUnreadCount(camelData['userId'] as String? ?? '');
    } catch (e) {
      debugPrint('Realtime: Error processing notification: $e');
    } finally {
      _hasPendingUpdate = false;
      notifyListeners();
    }
  }

  Future<void> _onFriendshipInsert(PostgresChangePayload payload, String currentUserId) async {
    await _handleFriendshipRecord(payload.newRecord, 'insert');
  }

  Future<void> _onFriendshipUpdate(PostgresChangePayload payload) async {
    await _handleFriendshipRecord(payload.newRecord, 'update');
  }

  Future<void> _handleFriendshipRecord(Map<String, dynamic> data, String eventType) async {
    try {
      debugPrint('Realtime: Friendship $eventType received');
      _hasPendingUpdate = true;
      notifyListeners();

      final syncService = SupabaseSyncService(_db);
      final camelData = syncService.toCamelCaseMapPublic(data);

      // Ensure both users exist locally to avoid empty joins in UI
      if (camelData.containsKey('userId')) {
        await syncService.ensureLocalUserPublic(camelData['userId'] as String);
      }
      if (camelData.containsKey('friendId')) {
        await syncService.ensureLocalUserPublic(camelData['friendId'] as String);
      }

      await _db.into(_db.friendships).insertOnConflictUpdate(Friendship.fromJson(camelData));
      
      debugPrint('Realtime: Friendship $eventType processed successfully');
    } catch (e) {
      debugPrint('Realtime: Error processing friendship $eventType: $e');
    } finally {
      _hasPendingUpdate = false;
      notifyListeners();
    }
  }

  Future<void> _onMatchPlayerInsert(PostgresChangePayload payload) async {
    try {
      debugPrint('Realtime: Match player insert received');
      _hasPendingUpdate = true;
      notifyListeners();

      final data = payload.newRecord;
      final syncService = SupabaseSyncService(_db);
      final camelData = syncService.toCamelCaseMapPublic(data);

      final matchId = camelData['matchId'] as String?;
      if (matchId != null) {
        // 1. Ensure Match details (and game) exist locally
        await syncService.ensureLocalMatchPublic(matchId);
        
        // 2. INTEGRITY GUARD: Check if player already exists local with different userId
        // This prevents Realtime events (which might be shadowed by RLS) from corrupting local data.
        final existing = await (_db.select(_db.players)..where((p) => p.id.equals(camelData['id']))).getSingleOrNull();
        if (existing != null && existing.userId != camelData['userId']) {
           debugPrint('Realtime INTEGRITY: Blocking userId change for player ${existing.id} from ${existing.userId} to ${camelData['userId']}');
           if (camelData['userId'] == _supabase.auth.currentUser?.id && existing.userId != _supabase.auth.currentUser?.id) {
              return; // Discard Realtime update as well
           }
        }

        // 3. Insert the player record itself
        await _db.into(_db.players).insertOnConflictUpdate(Player.fromJson(camelData));
        
        debugPrint('Realtime: Match $matchId and player record synced successfully');
      }
    } catch (e) {
      debugPrint('Realtime: Error processing match player insert: $e');
    } finally {
      _hasPendingUpdate = false;
      notifyListeners();
    }
  }

  Future<void> _refreshUnreadCount(String userId) async {
    if (userId.isEmpty) return;
    _unreadCount = await _db.notificationsDao.getUnreadCount(userId);
    notifyListeners();
  }

  /// Call this to refresh badge count after marking notifications as read.
  Future<void> refreshBadge(String userId) => _refreshUnreadCount(userId);
}
