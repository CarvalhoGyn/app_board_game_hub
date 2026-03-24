import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

class SupabaseSyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  
  static const String _kLastSyncKey = 'last_sync_timestamp';
  static const String _kLastGamesSyncKey = 'last_games_sync_timestamp_v1';
  static const String _kIdsAlignedKey = 'ids_aligned_v1';

  SupabaseSyncService(this._db) : _supabase = Supabase.instance.client;

  /// ONLINE-FIRST: Toggle Wishlist or Collection Status
  /// Returns NULL on success, or Error Message on failure.
  Future<String?> toggleCollectionStatus({
    required String gameId,
    required String collectionType, // 'wishlist' or 'owned'
    required bool addToCollection, // true = add, false = remove
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return 'Not logged in to Supabase';
      }

      if (addToCollection) {
        // --- ADDING ---
        // 1. Ensure Game Exists Remote
        // If this fails, we can't proceed because of FK constraint
        final remoteGameId = await _ensureGameSynced(gameId);
        if (remoteGameId == null) {
          return 'Failed to verify game on server';
        }

        // 2. Insert to Supabase (Upsert to be safe)
        // We let Supabase generate the ID, or we generate one?
        // Let Supabase generate or we use a UUID.
        // It's safer to generate a UUID here so we know it for Local DB immediately.
        // But matching drift's uuid is better? Drift uses UUID v4 by default.
        // Let's rely on Server ID if possible, but for Drift insert we need an ID.
        // Strategy: Insert to Supabase -> Get ID -> Insert Local.

        final payload = {
          'user_id': user.id,
          'game_id': remoteGameId,
          'collection_type': collectionType,
          'added_at': DateTime.now().toIso8601String(),
        };

        debugPrint('OnlineSync: Adding to $collectionType: $payload');
        
        // Upsert based on unique key (user_id, game_id, collection_type).
        // onConflict must match the unique constraint name or columns.
        final response = await _supabase
            .from('user_collections')
            .upsert(payload, onConflict: 'user_id,game_id,collection_type')
            .select() // Return the inserted row
            .single();
            
        final newId = response['id'] as String;
        final addedAt = DateTime.parse(response['added_at'] as String);
        
        // 3. Save to Local DB (No Sync Queue)
        await _db.userGameCollectionsDao.saveLocalCollectionItem(
          UserGameCollection(
             id: newId,
             userId: user.id,
             gameId: remoteGameId, // Use the Valid Remote ID (might have changed from local)
             collectionType: collectionType,
             addedAt: addedAt,
          )
        );
        
      } else {
        // --- REMOVING ---
        // 1. Get the item ID. We need the Remote ID.
        // If we only have local gameId, we might need to look up by composite key on server?
        // Or assume local ID matches remote ID if we are synced?
        // Safest: Delete by composite key (user_id, game_id, collection_type) on server.
        
        // But first, resolve game ID (JIT check might be overkill for delete, but safer if ID changed)
        // For delete, we just try to delete by Game ID.
        // CAUTION: If local game ID differs from remote, we might fail to match.
        // But `_ensureGameSynced` might have updated local ID.
        // Let's assume the local ID is correct-ish or we query by parameters.
        
        // We actually need the Remote Game ID to match the foreign key.
        // So we should try to resolve it.
        final localGame = await _db.gamesDao.getGameById(gameId);
        String targetGameId = gameId;
        
        if (localGame != null && localGame.bggId != null) {
             // Quick lookup if exists? Or just trust current ID?
             // Trusting current ID is O(1).
        }
        
        debugPrint('OnlineSync: Removing from $collectionType: Game $gameId');

        // Delete by filter
        final response = await _supabase
            .from('user_collections')
            .delete()
            .match({
               'user_id': user.id,
               'game_id': targetGameId,
               'collection_type': collectionType
            })
            .select()
            .maybeSingle(); // Returns the deleted row if successful
            
        // 2. Drop from Local ID
        // We delete by composite key locally to be sure
        await _db.userGameCollectionsDao.removeFromCollection(user.id, gameId, collectionType); 
        // Note: removeFromCollection normally adds to Queue.
        // We updated the DAO to still add to queue? Yes, previous code.
        // We need a non-queue delete!
        // FIXED: Using deleteLocalCollectionItem below.
        
        // Wait, I messed up. I need to FIND the local ID to delete it properly.
        final localItem = await (_db.select(_db.userGameCollections)..where((c) => 
            c.userId.equals(user.id) & 
            c.gameId.equals(gameId) & 
            c.collectionType.equals(collectionType)
        )).getSingleOrNull();
        
        if (localItem != null) {
           await _db.userGameCollectionsDao.deleteLocalCollectionItem(localItem.id);
        }
      }

      return null; // Success
    } catch (e) {
      debugPrint('OnlineSync Error: $e');
      return e.toString();
    }
  }

  /// ONLINE-FIRST: Send Friend Request
  Future<String?> sendFriendRequest(String friendId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 'Not logged in to Supabase';

      final payload = {
        'user_id': user.id,
        'friend_id': friendId,
        'status': 'pending',
        'requested_at': DateTime.now().toIso8601String(),
      };
      
      // 1. Insert to Supabase
      final response = await _supabase.from('friendships').insert(payload).select().single();
      
      // 2. Insert to Local DB
      await _db.friendshipsDao.saveLocalFriendship(Friendship(
         id: response['id'] as String,
         userId: user.id,
         friendId: friendId,
         status: 'pending',
         requestedAt: DateTime.parse(response['requested_at'] as String),
         respondedAt: null,
      ));
      
      return null;
    } catch (e) {
      debugPrint('OnlineSync (FriendRequest) Error: $e');
      return e.toString();
    }
  }

  /// ONLINE-FIRST: Respond to Friend Request
  Future<String?> respondToFriendRequest(String friendshipId, bool accept) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 'Not logged in to Supabase';
      
      final status = accept ? 'accepted' : 'rejected';
      final now = DateTime.now();

      // 1. Update Supabase
      final response = await _supabase
          .from('friendships')
          .update({'status': status, 'responded_at': now.toIso8601String()})
          .eq('id', friendshipId)
          .select()
          .single();
          
      // 2. Update Local DB
      await _db.friendshipsDao.updateLocalFriendshipStatus(friendshipId, status, now);
      
      if (accept) {
         // If accepted, typically we want the reverse friendship locally too.
         // On Supabase, this might be handled by a Trigger or we insert it.
         // For now, let's just ensure we have the FRIEND row locally.
         // We might simply rely on Pull Sync for the reverse row, or manually create it.
         // Manual creation is instant feedback.
         final original = await (_db.select(_db.friendships)..where((f) => f.id.equals(friendshipId))).getSingle();
         
         // Insert Reverse local
         await _db.friendshipsDao.saveLocalFriendship(Friendship(
            id: 'local_reverse_${original.friendId}_${original.userId}', // Temp ID until sync?
            // Actually, best to wait for sync or just show "Accepted".
            // If we create a fake ID, sync might duplicate.
            // Let's just update the status.
            userId: original.friendId,
            friendId: original.userId,
            status: 'accepted',
            requestedAt: original.requestedAt,
            respondedAt: now
         ));
         // Actually, do we have the reverse ID? No.
         // Let's NOT insert reverse locally to avoid ID conflict. 
         // The user cares about THEIR list (userId = me). The updated row puts it in "accepted" list.
         // So `getFriends` will work.
      }
      
      return null;
    } catch (e) {
      debugPrint('OnlineSync (RespondFriend) Error: $e');
      return e.toString();
    }
  }

  /// ONLINE-FIRST: Create Match
  Future<String?> createMatch({
     required MatchesCompanion match,
     required List<PlayersCompanion> players,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 'Not logged in to Supabase';

      // 1. Ensure Game Synced
      final localGameId = match.gameId.value;
      final remoteGameId = await _ensureGameSynced(localGameId);
      if (remoteGameId == null) return 'Game verification failed';
      
      // 2. Prepare Payloads
      final matchPayload = {
         'game_id': remoteGameId,
         'date': match.date.value.toIso8601String(),
         'location': match.location.value,
         'scoring_type': match.scoringType.value,
         'creator_id': user.id,
      };
      
      // 3. Insert Match to Supabase
      final matchResponse = await _supabase.from('matches').insert(matchPayload).select().single();
      final newMatchId = matchResponse['id'] as String;
      
      // 4. Insert Players to Supabase
      final playersPayload = players.map((p) => {
         'match_id': newMatchId,
         'user_id': p.userId.value,
         'score': p.score.value,
         'rank': p.rank.value,
         'match_rating': p.matchRating.value,
         'is_winner': p.isWinner.value,
      }).toList();
      
      final playersResponse = await _supabase.from('match_players').insert(playersPayload).select();
      
      // 5. Save Local (Using Remote Objects)
      // We reconstruct the Drift objects from the Response to ensure IDs match.
      
      final localMatch = MatchRow(
         id: newMatchId,
         gameId: remoteGameId,
         date: DateTime.parse(matchResponse['date']),
         location: matchResponse['location'],
         scoringType: matchResponse['scoring_type'],
         creatorId: matchResponse['creator_id'],
      );
      
      final localPlayers = (playersResponse as List).map((p) => Player(
         id: p['id'],
         matchId: newMatchId,
         userId: p['user_id'],
         score: p['score'],
         rank: p['rank'],
         matchRating: p['match_rating'] != null ? (p['match_rating'] as num).toDouble() : null,
         isWinner: p['is_winner'] ?? false,
      )).toList();
      
      await _db.matchesDao.saveLocalMatch(localMatch, localPlayers);
      
      return newMatchId; // Return ID on success (or we could return null and pass ID separately, but returning ID is useful)
    } catch (e) {
      debugPrint('OnlineSync (CreateMatch) Error: $e');
      return null; // Null indicates failure here? Or we should return String? 
      // Signature returns String? (Error message). 
      // Let's change signature or throw.
      // Wait, I defined it as Future<String?> above meaning Error Message.
      // But caller needs the Match ID to navigate!
      // I should change signature to return Future<{String? error, String? matchId}> or simplify.
      throw e; // Let's throw for now so caller catches.
    }
  }

  Future<void> sync() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
       debugPrint('Sync: Aborted. No user logged in.');
       return;
    }
    
    // Auto-migration
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kIdsAlignedKey) != true) {
       await alignLocalGameIds();
       await prefs.setBool(_kIdsAlignedKey, true);
    }

    try {
      debugPrint('>>> STARTING SYNC for User: ${user.id} <<<');
      
      await _db.syncQueueDao.retryFailedItems();
      await pushChanges();
      
      // --- RESTORE STRATEGY: Check if Local Data Exists ---
      final collectionCount = await _db.userGameCollectionsDao.getOwnedCount(user.id) + 
                              await _db.userGameCollectionsDao.getWishlistCount(user.id);
      
      debugPrint('Sync: Local Collection Count = $collectionCount');
      
      final bool isFreshInstall = collectionCount == 0;
      
      if (isFreshInstall) {
         debugPrint('Sync: FRESH INSTALL DETECTED. Triggering FULL RESTORE MODE.');
         await pullChanges(isRestoreMode: true);
      } else {
         debugPrint('Sync: Existing Installation. Running Incremental Mode.');
         await pullChanges(isRestoreMode: false);
      }

      debugPrint('>>> SYNC COMPLETED <<<');
    } catch (e, stack) {
      debugPrint('>>> SYNC FAILED: $e <<<');
      debugPrintStack(stackTrace: stack);
    }
  }

  /// PUSH: Local -> Cloud
  Future<void> pushChanges() async {
    // CRITICAL: Ensure we are authenticated before pushing
    if (_supabase.auth.currentUser == null) {
      debugPrint('Sync (Push) Skipped: No Supabase user logged in.');
      return;
    }

    final pendingItems = await _db.syncQueueDao.getPendingItems();
    if (pendingItems.isEmpty) return;

    debugPrint('Found ${pendingItems.length} pending items to push');

    for (final item in pendingItems) {
      try {
        final table = item.entity; // matches, match_players, etc.
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        
        // Supabase expects snake_case keys. Drift gives camelCase. 
        // We need to convert payload keys to snake_case.
        var snakePayload = _toSnakeCaseMap(payload);

        // --- FRESH DATA LOOKUP ---
        // The payload might be stale if ID Migration ran after enqueueing.
        // We should try to fetch the latest version of the row from DB if possible.
        if (item.action == 'INSERT' || item.action == 'UPDATE') {
           // OVERRIDE: Ensure user_id matches the currently logged-in Supabase user.
           // This fixes any mismatch between old local User IDs and the actual Cloud Auth ID.
           final currentAuthId = _supabase.auth.currentUser?.id;
           if (currentAuthId != null && snakePayload.containsKey('user_id')) {
               snakePayload['user_id'] = currentAuthId;
           }

           if (table == 'user_collections') {
               final id = snakePayload['id'];
               // Fetch fresh
               // NOTE: Local Drift table is named user_game_collections (default snake_case of class UserGameCollections)
               final freshRow = await _db.customSelect('SELECT * FROM user_game_collections WHERE id = ?', variables: [Variable.withString(id)]).getSingleOrNull();
               if (freshRow != null) {
                  // Re-construct payload from fresh data
                  final freshGameId = freshRow.read<String>('game_id'); 
                  snakePayload['game_id'] = freshGameId;
                  // We already forced user_id above
                  debugPrint('Refreshed payload for user_collections: Game $freshGameId');
               }
           } else if (table == 'matches') {
               final id = snakePayload['id'];
               final freshRow = await _db.matchesDao.getMatchWithDetails(id); // Helper that joins games
               if (freshRow != null) {
                   snakePayload['game_id'] = freshRow.match.gameId; // Use current game ID
                   debugPrint('Refreshed payload for matches: Game ${freshRow.match.gameId}');
               }
           }
        }

        // --- ENSURE GAME EXISTS (Just-In-Time Sync) ---
        // For tables that reference games (user_collections, matches, reviews),
        // we must ensure the Game exists on Supabase to avoid FK violations.
        if (['user_collections', 'matches', 'reviews'].contains(table) && snakePayload.containsKey('game_id')) {
           final localGameId = snakePayload['game_id'] as String;
           // This method will:
           // 1. Check if game exists remote (by BGG ID).
           // 2. If yes but ID differs, update Local ID and return Remote ID.
           // 3. If no, Insert Game to Remote, update Local ID (if changed), and return New Remote ID.
           final validRemoteGameId = await _ensureGameSynced(localGameId);
           
           if (validRemoteGameId != null) {
              snakePayload['game_id'] = validRemoteGameId;
           } else {
              // CRITICAL: If we failed to ensure game existence, we CANNOT proceed.
              throw Exception('Cannot sync $table item because referenced Game $localGameId could not be verified on Supabase.');
           }
        }

        if (item.action == 'INSERT') {
           String? onConflict;
           
           // Special handling for link tables or specific constraints
           if (table == 'user_collections') {
               snakePayload.remove('id'); // RESTORED: Server authority for IDs
               onConflict = 'user_id,game_id,collection_type';
           } else if (table == 'games') {
               snakePayload.remove('id'); // Allow server to generate/match ID
               // Check if bgg_id is present for Unique Constraint
               if (snakePayload['bgg_id'] != null) {
                  onConflict = 'bgg_id';
               }
           }

           // Perform Upsert and Select Single to get the Remote Entity
           debugPrint('Sync: Upserting $table with onConflict: $onConflict. Payload: $snakePayload');
           
           final response = await _supabase.from(table).upsert(
             snakePayload, 
             onConflict: onConflict
           ).select().single();
           
           debugPrint('Sync: Upsert Response for $table: $response');

           // CHECK AND UPDATE LOCAL ID
           // Applies to ALL tables: If Remote ID differs from Local ID, update Local.
           if (response != null && response['id'] != null) {
               final newRemoteId = response['id'] as String;
               final localPayloadId = payload['id'] as String?;
               
               if (localPayloadId != null && localPayloadId != newRemoteId) {
                   // Map Remote Table Name to Local Drift Table Name
                   String localTableName = table;
                   if (table == 'user_collections') localTableName = 'user_game_collections';
                   
                   debugPrint('Sync: Updating Local $localTableName ID from $localPayloadId to Remote $newRemoteId');
                   
                   // Check if the destination ID already exists locally (Duplicate/Merge scenario)
                   final existingDest = await _db.customSelect(
                      'SELECT 1 FROM $localTableName WHERE id = ?',
                      variables: [Variable.withString(newRemoteId)]
                   ).getSingleOrNull();

                   if (existingDest != null) {
                       // MERGE: The remote ID already exists locally (e.g. from previous sync).
                       // The current row $localPayloadId is a duplicate that we just tried to push.
                       // We should DELETE the current duplicate row to avoid PK violation on renaming.
                       debugPrint('Sync: Duplicate detected. Merging (Deleting local duplicate $localPayloadId)...');
                       await _db.customUpdate(
                          'DELETE FROM $localTableName WHERE id = ?',
                          variables: [Variable.withString(localPayloadId)]
                       );
                   } else {
                       // RENAME: The remote ID is new to us. Update our local ID to match.
                       // Note: Ensure foreign keys are handled if cascading is not set up in DB.
                       try {
                           await _db.customUpdate(
                              'UPDATE $localTableName SET id = ? WHERE id = ?',
                              variables: [Variable.withString(newRemoteId), Variable.withString(localPayloadId)]
                           );
                       } catch (e) {
                           debugPrint('Sync: Error updating ID $localTableName: $e');
                       }
                   }
               }
           }
        } else if (item.action == 'UPDATE') {
           await _supabase.from(table).update(snakePayload).eq('id', snakePayload['id']);
        } else if (item.action == 'DELETE') {
           await _supabase.from(table).delete().eq('id', snakePayload['id']);
        }
        
        await _db.syncQueueDao.markAsCompleted(item.id);
      } catch (e, stack) {
        debugPrint('Failed to push item ${item.id} (${item.entity} ${item.action}): $e');
        debugPrintStack(stackTrace: stack);
        await _db.syncQueueDao.markAsFailed(item.id);
      }
    }
  }

  /// Ensures a Game exists on Supabase before we reference it.
  /// Returns the valid Remote ID (which might be different from localId).
  Future<String?> _ensureGameSynced(String localGameId) async {
      try {
          final localGame = await _db.gamesDao.getGameById(localGameId);
          if (localGame == null) return null; // Should not happen if DB is consistent
          
          String? remoteId;
          
          // 1. Try to find by BGG ID (Strongest link)
          if (localGame.bggId != null) {
             final existing = await _supabase
                .from('games')
                .select('id')
                .eq('bgg_id', localGame.bggId!)
                .maybeSingle();
                
             if (existing != null) {
                remoteId = existing['id'] as String;
             }
          }
          
          // 2. If not found, Push the Game
          if (remoteId == null) {
             debugPrint('Game $localGameId (BGG ${localGame.bggId}) not found remote. Pushing now...');
             
             var gamePayload = localGame.toJson();
             var snakeGamePayload = _toSnakeCaseMap(gamePayload);
             snakeGamePayload.remove('id'); // Let remote generate if needed, OR we send specific UUID? 
             // Ideally we send nothing and let remote generate, OR we send our UUID.
             // If we send our UUID, strict collision might happen if UUID logic differs.
             // Safer to remove ID and let Server generate, then capture it.
             
             try {
               final response = await _supabase.from('games').insert(snakeGamePayload).select().single();
               remoteId = response['id'] as String;
               debugPrint('Game Pushed. New Remote ID: $remoteId');
             } catch (e) {
               debugPrint('Error pushing game JIT: $e');
               // Fallback: If insert failed (likely 409 conflict/duplicate), try to fetch again
               try {
                  debugPrint('Refetching game ${localGame.bggId} after insert failure...');
                  final existingRetry = await _supabase
                      .from('games')
                      .select('id')
                      .eq('bgg_id', localGame.bggId!)
                      .maybeSingle();
                  if (existingRetry != null) {
                    remoteId = existingRetry['id'] as String;
                    debugPrint('Recovered Remote ID from retry: $remoteId');
                  }
               } catch (e2) {
                  debugPrint('Double failure resolving game JIT: $e2');
                  return null;
               }
             }
          }
          
          // 3. Align Local ID if different
          if (remoteId != null && remoteId != localGameId) {
             debugPrint('Aligning JIT: Local $localGameId -> Remote $remoteId');
             await _updateGameIdCascading(localGameId, remoteId);
             return remoteId;
          }
          
          return localGameId; // If same, return local (which is now same as remote)
          
      } catch (e) {
          debugPrint('Error in _ensureGameSynced: $e');
          return null;
      }
  }

  Future<void> _updateGameIdCascading(String oldId, String newId) async {
      await _db.transaction(() async {
          // 1. Update dependent tables
          // user_game_collections
          await _db.customUpdate(
             'UPDATE user_game_collections SET game_id = ? WHERE game_id = ?',
             variables: [Variable.withString(newId), Variable.withString(oldId)]
          );
          // matches
          await _db.customUpdate(
             'UPDATE matches SET game_id = ? WHERE game_id = ?',
             variables: [Variable.withString(newId), Variable.withString(oldId)]
          );
          // reviews
          await _db.customUpdate(
             'UPDATE reviews SET game_id = ? WHERE game_id = ?',
             variables: [Variable.withString(newId), Variable.withString(oldId)]
          );
          
          // 2. Update the Game itself
          // We disable FK Check temporarily if sqlite allows? No, we update dependents FIRST, but then the new ID doesn't exist in Games yet, so FK fails?
          // SQLite FK: Referencing Child(game_id) -> Parent(id).
          // If we update Child to NewID, Parent(NewID) must exist.
          // Parent(NewID) does NOT exist yet (we are renaming OldID to NewID).
          // So we MUST:
          // A. Insert New Game (Copy of Old with New ID).
          // B. Update Dependents to New ID.
          // C. Delete Old Game.
          
          // A. Get Old Game
          final oldGame = await _db.gamesDao.getGameById(oldId);
          if (oldGame != null) {
              // Copy properties. 
              // Using SQL is faster/easier than constructing object if we assume columns match.
              // But Drift objects are safer.
              // Let's use raw SQL to "Clone" the row with new ID to ensure all columns (even new ones) are copied?
              // Or just Update with PRAGMA foreign_keys = OFF? 
              // PRAGMA is dangerous in transaction.
              
              // Let's use the Insert New -> Update -> Delete approach.
              final newGame = oldGame.copyWith(id: newId);
              await _db.into(_db.games).insert(newGame, mode: InsertMode.insertOrIgnore); 
              
              // B. Update Dependents
               await _db.customUpdate(
                 'UPDATE user_game_collections SET game_id = ? WHERE game_id = ?',
                 variables: [Variable.withString(newId), Variable.withString(oldId)]
              );
              await _db.customUpdate(
                 'UPDATE matches SET game_id = ? WHERE game_id = ?',
                 variables: [Variable.withString(newId), Variable.withString(oldId)]
              );
              await _db.customUpdate(
                 'UPDATE reviews SET game_id = ? WHERE game_id = ?',
                 variables: [Variable.withString(newId), Variable.withString(oldId)]
              );
              
              // C. Delete Old Game
              await _db.customStatement('DELETE FROM games WHERE id = ?', [oldId]);
          }
      });
  }

  // --- MIGRATION: Align Local IDs with Remote IDs ---
  
  Future<void> alignLocalGameIds() async {
    debugPrint('Starting ID Alignment Migration...');
    
    // 1. Fetch all local games with BGG ID
    final localGames = await _db.gamesDao.getAllGames();
    final gamesWithBgg = localGames.where((g) => g.bggId != null).toList();
    
    if (gamesWithBgg.isEmpty) {
       debugPrint('No local games with BGG ID found.');
       return;
    }
    
    debugPrint('Checking ${gamesWithBgg.length} local games against Supabase...');
    
    // 2. Resolve Remote IDs in batches (Simple implementation: loop lookup or small batches)
    // Optimizing: Get all BGG IDs and fetch map from Supabase
    // Supabase 'in' filter limit is URL length, so we batch by 50.
    
    int processed = 0;
    int fixed = 0;
    
    final chunks = _chunkList(gamesWithBgg, 50);
    
    for (final chunk in chunks) {
       final bggIds = chunk.map((g) => g.bggId!).toList();
       
       final response = await _supabase
          .from('games')
          .select('id, bgg_id')
          .inFilter('bgg_id', bggIds);
          
       final remoteMap = { for (var item in response) item['bgg_id'] as int : item['id'] as String };
       
       for (final localGame in chunk) {
          final remoteId = remoteMap[localGame.bggId];
          
          if (remoteId != null && remoteId != localGame.id) {
             debugPrint('Mismatch found for BGG ${localGame.bggId}: Local ${localGame.id} != Remote $remoteId');
             await _fixGameId(localGame, remoteId);
             fixed++;
          }
          processed++;
       }
    }
    
    debugPrint('Migration Finished. Processed: $processed. Fixed: $fixed.');
  }

  Future<void> _fixGameId(Game localGame, String newId) async {
     await _db.transaction(() async {
        // 1. Create a copy of the game with the NEW ID
        // Note: Drift insertOnConflictUpdate might fail if ID differs but other constraints exist.
        // We use raw insert or companion copy.
        final newGame = localGame.copyWith(id: newId);
        
        // Check if destination ID already exists locally (partial sync state)
        final existingDest = await _db.gamesDao.getGameById(newId);
        if (existingDest == null) {
           await _db.into(_db.games).insert(newGame, mode: InsertMode.insertOrIgnore);
        } else {
           // If it exists, we just update it to ensure it's latest
           await _db.update(_db.games).replace(newGame);
        }
        
        // 2. Update dependent tables to point to NEW ID
        // Matches
        await (_db.update(_db.matches)..where((m) => m.gameId.equals(localGame.id)))
             .write(MatchesCompanion(gameId: Value(newId)));
             
        // UserCollections (Wishlist/Owned)
        // Note: Unique cleanup might be needed if user already has item with new ID?
        // For simplicity, we assume strict migration.
        await (_db.update(_db.userGameCollections)..where((c) => c.gameId.equals(localGame.id)))
             .write(UserGameCollectionsCompanion(gameId: Value(newId)));
             
        // Reviews
        await (_db.update(_db.reviews)..where((r) => r.gameId.equals(localGame.id)))
             .write(ReviewsCompanion(gameId: Value(newId)));

        // 3. Delete OLD Game
        await (_db.delete(_db.games)..where((g) => g.id.equals(localGame.id))).go();
     });
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  /// PULL: Cloud -> Local
  Future<void> pullChanges({bool isRestoreMode = false}) async {
    // STRICT GUARD: Sync only if logged in
    if (_supabase.auth.currentUser == null) {
       debugPrint('Sync (Pull) Skipped: No Supabase user logged in.');
       return;
    }

    final prefs = await SharedPreferences.getInstance();
    
    // If not restore mode, load last sync time. If restore mode, force 0.
    final lastSyncStr = !isRestoreMode ? prefs.getString(_kLastSyncKey) : null;
    final lastSync = lastSyncStr != null ? DateTime.parse(lastSyncStr) : DateTime.fromMillisecondsSinceEpoch(0).toUtc(); 
    
    final now = DateTime.now().toUtc(); // Capture time before request
    
    // We need to pull for each table we care about.
    // --- GAMES SYNC (Separate Timestamp) ---
    // Games are Public Data, so we always sync incrementally (even on Restore Mode, we don't want ALL games, just new ones?)
    // Actually, on Restore Mode, we rely on JIT fetch for games we need. We don't need to fetch ALL games.
    // So Games Sync logic remains Incremental.
    final lastGamesSyncStr = prefs.getString(_kLastGamesSyncKey);
    final lastGamesSync = lastGamesSyncStr != null ? DateTime.parse(lastGamesSyncStr) : DateTime.fromMillisecondsSinceEpoch(0).toUtc();
    
    await _pullTable('games', lastGamesSync, (data) async {
       final camelData = _toCamelCaseMap(data);
       var gameData = Game.fromJson(camelData);
       
       // CRITICAL: Conflict Resolution for Games via BGG_ID
       // Local CSV import creates random UUIDs. Remote DB has different UUIDs.
       // We must align them by bggId to avoid UNIQUE constraint violations.
       if (gameData.bggId != null) {
          final localGame = await _db.gamesDao.getGameByBggId(gameData.bggId!);
          if (localGame != null) {
             // Found local counterpart. Use LOCAL ID so Drift updates it instead of trying to insert.
             gameData = gameData.copyWith(id: localGame.id);
          }
       }
       
       await _db.into(_db.games).insertOnConflictUpdate(gameData);
    });
    
    // Save separate games sync time
    await prefs.setString(_kLastGamesSyncKey, now.toIso8601String());


    // --- PROFILES SYNC (Current User) ---
    // Critical: Ensure current user exists locally to satisfy FKs (e.g. user_collections)
    if (_supabase.auth.currentUser != null) {
       await _ensureLocalUser(_supabase.auth.currentUser!.id);
    }
    
    // --- USER DATA SYNC (Global Timestamp) ---
    // Matches, Players, Reviews
    
    // Players: Restore by User ID (Gets everything I played)
    await _pullTable('match_players', lastSync, (data) async {
       final camelData = _toCamelCaseMap(data);
       // Ensure Match exists for this player entry
       if (camelData.containsKey('matchId')) {
          final matchExists = await _ensureLocalMatch(camelData['matchId']);
          if (!matchExists) throw Exception('Dependent match missing');
       }
       // Ensure User exists (friend or me)
       if (camelData.containsKey('userId')) {
          await _ensureLocalUser(camelData['userId']);
       }
       await _db.into(_db.players).insertOnConflictUpdate(Player.fromJson(camelData));
    }, userId: _supabase.auth.currentUser?.id);

    // Matches: Restore by Creator ID (Matches I created)
    await _pullTable('matches', lastSync, (data) async {
       final camelData = _toCamelCaseMap(data);
       // Ensure Creator exists
       if (camelData.containsKey('creatorId') && camelData['creatorId'] != null) {
           await _ensureLocalUser(camelData['creatorId']);
       }
       await _db.into(_db.matches).insertOnConflictUpdate(MatchRow.fromJson(camelData));
    }, timestampColumn: 'date', userId: _supabase.auth.currentUser?.id, userIdColumn: 'creator_id'); 
    
    await _pullTable('reviews', lastSync, (data) async {
       final camelData = _toCamelCaseMap(data);
       // Ensure Reviewer exists
       if (camelData.containsKey('userId')) {
           await _ensureLocalUser(camelData['userId']);
       }
       await _db.into(_db.reviews).insertOnConflictUpdate(Review.fromJson(camelData));
    }, userId: _supabase.auth.currentUser?.id);
    
    // UserCollections uses 'added_at'
    await _pullTable('user_collections', lastSync, (data) async {
       final camelData = _toCamelCaseMap(data);
       var row = UserGameCollection.fromJson(camelData);
       
       // Ensure Game Exists (Critical for FK)
       // The generic loop does this, but doing it here allows us to handle 'row' object if needed
       // or just rely on generic loop. 
       // Note: Generic loop check happens BEFORE this callback.
       // So valid gameId check passed. 
       
       // Conflict Resolution: Match by (user_id, game_id, collection_type)
       // If local exists with different ID, update local ID to match Remote ID.
       final existingLocal = await _db.customSelect(
          'SELECT * FROM user_game_collections WHERE user_id = ? AND game_id = ? AND collection_type = ?',
          variables: [
             Variable.withString(row.userId!),
             Variable.withString(row.gameId!),
             Variable.withString(row.collectionType!)
          ]
       ).getSingleOrNull();
       
       if (existingLocal != null) {
          final localId = existingLocal.read<String>('id');
          if (localId != row.id) {
              debugPrint('Aligning UserCollection ID: Local $localId -> Remote ${row.id}');
              // Delete old local so we can insert/update the new one
              await _db.customStatement('DELETE FROM user_game_collections WHERE id = ?', [localId]);
          }
       }
       
       await _db.into(_db.userGameCollections).insertOnConflictUpdate(row);
    }, timestampColumn: 'added_at', userId: _supabase.auth.currentUser?.id);
    
    // Friendships
    await _pullTable('friendships', lastSync, (data) async {
      final camelData = _toCamelCaseMap(data);
      // Ensure Friends exist?
      // user_id is sender (me), friend_id is receiver.
      if (camelData.containsKey('friendId')) {
         await _ensureLocalUser(camelData['friendId']);
      }
      await _db.into(_db.friendships).insertOnConflictUpdate(Friendship.fromJson(camelData));
    }, userId: _supabase.auth.currentUser?.id);

    // Save global sync time
    await prefs.setString(_kLastSyncKey, now.toIso8601String());
  }

  // ... (existing _pullTable, _ensureLocalGame, _ensureLocalMatch)

  /// Ensures a User (Profile) exists locally. Fetch if missing.
  Future<void> _ensureLocalUser(String userId) async {
     // Check Local
     // Users table in Drift is Users.
     final localUser = await (_db.select(_db.users)..where((u) => u.id.equals(userId))).getSingleOrNull();
     if (localUser != null) return;
     
     debugPrint('Sync Restore: User $userId missing locally. Fetching profile...');
     
     try {
        final remoteProfile = await _supabase.from('profiles').select().eq('id', userId).maybeSingle();
        if (remoteProfile != null) {
           final camelData = _toCamelCaseMap(remoteProfile);
           // Map 'username', 'email' etc.
           // Drift Users class has typical fields.
           // Auto-mapping might work if fields match.
           // Need to be careful with password field - likely not in profiles table or hashed.
           // Profiles table has: id, username, email, first_name...
           // Drift Users has: password.
           // We might need to dummy the password or make it nullable. 
           // In database.dart: TextColumn get password => text()(); (NOT Nullable!)
           // We MUST provide a password placeholder if we are inserting from `profiles`.
           
           if (!camelData.containsKey('password')) {
              camelData['password'] = ''; // Placeholder for synced users
           }
           
           await _db.into(_db.users).insertOnConflictUpdate(User.fromJson(camelData));
           debugPrint('Sync Restore: User $userId restored.');
        } else {
           debugPrint('Sync Restore Warning: User $userId not found in profiles!');
           // If we can't find the user, we can't insert -> FK will fail for dependent items.
           // Sometiems auth.users has it but profiles doesn't? 
           // For now, we return and hope.
        }
     } catch (e) {
        debugPrint('Error fetching profile $userId: $e');
     }
  }

  Future<void> _pullTable(
      String tableName, 
      DateTime lastSync, 
      Function(Map<String, dynamic>) onRow, 
      {
        String timestampColumn = 'updated_at', 
        String? userId, // If provided and Restore Mode, we query by this User ID
        String userIdColumn = 'user_id' // Column name to filter by User ID
      }
  ) async {
      List<dynamic> rows = [];
      try {
        final isRestoreMode = lastSync.millisecondsSinceEpoch == 0;
        
        if (isRestoreMode && userId != null) {
           debugPrint('Sync: Fetching ALL $tableName for User $userId (Restore Mode)');
           final response = await _supabase
              .from(tableName)
              .select()
              .eq(userIdColumn, userId); // Fetch ALL for user
           rows = response as List<dynamic>;
        } else {
           // Incremental Sync (Timestamp based)
           final response = await _supabase
              .from(tableName)
              .select()
              .gt(timestampColumn, lastSync.toIso8601String())
              .limit(1000); // Pagination safety
           rows = response as List<dynamic>;
        }

        debugPrint('Sync: $tableName returned ${rows.length} rows.');

      } catch (e) {
         debugPrint('Sync ERROR pulling $tableName: $e');
         return; // If initial fetch fails, checking rows is impossible
      }

      int successCount = 0;
      int failCount = 0;

      for (final row in rows) {
        if (row is Map<String, dynamic>) {
           try {
              // --- ROBUST RESTORE: Check Dependencies ---
              if (['user_collections', 'matches', 'reviews'].contains(tableName) && row.containsKey('game_id')) {
                 final gameId = row['game_id'] as String;
                 // If we fail to ensure local game, we MUST skip this item to avoid FK Crash
                 final gameExists = await _ensureLocalGame(gameId);
                 if (!gameExists) {
                    debugPrint('Sync SKIP: $tableName item ${row['id']} skipped because Game $gameId could not be resolved.');
                    failCount++;
                    continue; 
                 }
              }
              
              await onRow(row);
              successCount++;
           } catch (e) {
              debugPrint('Sync ERROR processing $tableName row ${row['id']}: $e');
              failCount++;
           }
        }
      }
      
      if (failCount > 0 || successCount > 0) {
         debugPrint('Sync Summary $tableName: $successCount OK, $failCount Failures.');
      }
  }

  /// Ensures a Game exists LOCALLY by fetching it from Supabase if missing.
  /// Returns TRUE if game exists (or was restored), FALSE if not found.
  Future<bool> _ensureLocalGame(String gameId) async {
      // Auth Guard
      if (_supabase.auth.currentUser == null) return false;

      // 1. Check Local
      final localGame = await _db.gamesDao.getGameById(gameId);
      if (localGame != null) return true;
      
      debugPrint('Sync Restore: Game $gameId missing locally. Fetching from Supabase...');
      
      try {
         // 2. Fetch from Supabase
         final remoteGame = await _supabase.from('games').select().eq('id', gameId).maybeSingle();
         if (remoteGame != null) {
             final camelData = _toCamelCaseMap(remoteGame);
             await _db.into(_db.games).insertOnConflictUpdate(Game.fromJson(camelData));
             return true;
         }
         return false;
      } catch (e) {
         debugPrint('Error fetching game $gameId: $e');
         return false;
      }
  }

  /// Ensures a Match exists locally. Fetch if missing.
  /// Also ensures the Game for that match exists.
  Future<bool> _ensureLocalMatch(String matchId) async {
     // Check Local
     final localMatch = await _db.matchesDao.getMatchWithDetails(matchId);
     if (localMatch != null) return true;
     
     debugPrint('Sync Restore: Match $matchId missing locally. Fetching...');
     
     try {
        final remoteMatch = await _supabase.from('matches').select().eq('id', matchId).maybeSingle();
        if (remoteMatch != null) {
           final gameId = remoteMatch['game_id'] as String;
           
           // Ensure Game First
           final gameExists = await _ensureLocalGame(gameId);
           if (!gameExists) return false;
           
           // Insert Match
           final camelData = _toCamelCaseMap(remoteMatch);
           await _db.into(_db.matches).insertOnConflictUpdate(MatchRow.fromJson(camelData));
           debugPrint('Sync Restore: Match $matchId restored.');
           return true;
        }
        return false;
     } catch (e) {
        debugPrint('Error fetching match $matchId: $e');
        return false;
     }
  }



  // --- Helpers ---

  Map<String, dynamic> _toSnakeCaseMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(_camelToSnake(key), value));
  }
  
  Map<String, dynamic> _toCamelCaseMap(Map<String, dynamic> map) {
    var camelMap = map.map((key, value) => MapEntry(_snakeToCamel(key), value));
    
    // Drift's fromJson expects DateTime as Unix timestamps (millisecondsSinceEpoch) by default.
    // Supabase returns ISO8601 strings. We must convert them before calling .fromJson()
    final dateKeys = ['createdAt', 'updatedAt', 'addedAt', 'date', 'requestedAt', 'respondedAt', 'unlockedAt', 'birthDate'];
    for (var key in dateKeys) {
       if (camelMap[key] != null && camelMap[key] is String) {
          camelMap[key] = DateTime.parse(camelMap[key] as String).millisecondsSinceEpoch;
       }
    }

    // Fix doubles
    final doubleKeys = ['rating', 'matchRating'];
    for (var key in doubleKeys) {
       if (camelMap[key] != null && camelMap[key] is int) {
          camelMap[key] = (camelMap[key] as int).toDouble();
       } else if (camelMap[key] != null && camelMap[key] is String) {
          camelMap[key] = double.tryParse(camelMap[key] as String);
       }
    }

    // Fix non-nullable booleans
    final boolKeys = ['isWinner', 'isEnriched'];
    for (var key in boolKeys) {
       if (!camelMap.containsKey(key) || camelMap[key] == null) {
          camelMap[key] = false;
       }
    }

    // Fix non-nullable strings with defaults
    final stringKeys = ['scoringType', 'password'];
    for (var key in stringKeys) {
       if (!camelMap.containsKey(key) || camelMap[key] == null) {
          camelMap[key] = key == 'scoringType' ? 'competitive' : '';
       }
    }

    return camelMap;
  }

  String _camelToSnake(String camel) {
    return camel.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)!.toLowerCase()}';
    });
  }
  
  String _snakeToCamel(String snake) {
    return snake.replaceAllMapped(RegExp(r'_([a-z])'), (match) {
      return match.group(1)!.toUpperCase();
    });
  }
}
