import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../services/ai_message_service.dart';
import 'game_catalog.dart';
import 'profile_dashboard.dart';
import '../providers/user_session.dart';
import '../services/gamification_service.dart';
import '../services/supabase_sync_service.dart';

class RecordMatchScore extends StatefulWidget {
  final String matchId;
  const RecordMatchScore({super.key, required this.matchId});

  @override
  State<RecordMatchScore> createState() => _RecordMatchScoreState();
}

class _RecordMatchScoreState extends State<RecordMatchScore> {
  MatchWithDetails? _matchDetails;
  List<PlayerWithUser> _matchPlayers = [];
  Map<String, int> _playerRanks = {};
  Map<String, double> _playerRatings = {};
  String? _winnerId;

  bool _coopVictory = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final matchesDao = context.read<MatchesDao>();
    final details = await matchesDao.getMatchWithDetails(widget.matchId);
    final players = await matchesDao.getPlayersForMatch(widget.matchId);
    
    if (mounted) {
      setState(() {
        _matchDetails = details;
        _matchPlayers = players;
        
        // Init state
        if (details?.match.scoringType == 'cooperative') {
           // If already recorded, use first player's win status as team status
           if (players.isNotEmpty && players.first.player.isWinner) {
              _coopVictory = true;
           }
        } else {
           for (var p in players) {
             _playerRanks[p.player.id] = p.player.rank ?? 0;
             if (p.player.isWinner) {
                _winnerId = p.user.id;
             }
           }
        }
        
        // Ratings always present
        for (var p in players) {
          _playerRatings[p.player.id] = p.player.matchRating ?? 0.0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () {
            if (Navigator.canPop(context)) {
               Navigator.pop(context);
            } else {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameCatalog()));
            }
          },
        ),
        title: Text('Record Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_matchDetails == null) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              _buildGameHeader(theme),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.1))),
              
              if (_matchDetails!.match.scoringType == 'cooperative')
                 _buildCoopResultToggle(theme),
              
              _buildPlayersHeader(theme),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _matchPlayers.length,
                itemBuilder: (context, index) => _buildPlayerCard(_matchPlayers[index], theme),
              ),
              // _buildAddPlayerButton(), // Disabled per rule: Cannot change participants after match start
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildStickyFooter(theme),
    );
  }
  
  Widget _buildCoopResultToggle(ThemeData theme) {
      final currentUser = context.read<UserSession>().currentUser;
      final creatorId = _matchDetails?.match.creatorId;
      final canEditScore = (creatorId == null) || (currentUser?.id == creatorId); // Same logic
      final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

      return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
             color: _coopVictory ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
             borderRadius: BorderRadius.circular(16),
             border: Border.all(color: _coopVictory ? Colors.green : Colors.red, width: 2),
          ),
          child: Column(
             children: [
                Text('MISSION RESULT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 12),
                Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      _buildResultOption('DEFEAT', false, Icons.sentiment_very_dissatisfied, canEditScore),
                      const SizedBox(width: 24),
                      _buildResultOption('VICTORY', true, Icons.emoji_events, canEditScore),
                   ],
                ),
                if (!canEditScore)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Only Match Creator can change result', style: TextStyle(color: mutedColor, fontSize: 10)),
                  ),
             ],
          ),
      );
  }
  
  Widget _buildResultOption(String label, bool value, IconData icon, bool enabled) {
     final isSelected = _coopVictory == value;
     return GestureDetector(
        onTap: enabled ? () => setState(() => _coopVictory = value) : null,
        child: Opacity(
           opacity: isSelected ? 1.0 : (enabled ? 0.5 : 0.2),
           child: Column(
              children: [
                 Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                       color: value ? Colors.green : Colors.red,
                       shape: BoxShape.circle,
                       boxShadow: isSelected ? [BoxShadow(color: (value ? Colors.green : Colors.red).withOpacity(0.4), blurRadius: 10)] : [],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                 ),
                 const SizedBox(height: 8),
                 Text(label, style: TextStyle(
                    color: value ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                 )),
              ],
           ),
        ),
     );
  }

  Widget _buildGameHeader(ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 112, width: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: _matchDetails!.game.imageUrl != null 
                  ? (_matchDetails!.game.imageUrl!.startsWith('http') 
                      ? NetworkImage(_matchDetails!.game.imageUrl!) 
                      : (File(_matchDetails!.game.imageUrl!).existsSync() 
                          ? FileImage(File(_matchDetails!.game.imageUrl!)) as ImageProvider
                          : const NetworkImage('https://i.placeholder.com/150')))
                  : const NetworkImage('https://i.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.category_outlined, color: theme.primaryColor, size: 14),
                      const SizedBox(width: 4),
                      Text(_matchDetails!.match.scoringType.toUpperCase(), style: TextStyle(color: theme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(_matchDetails!.game.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: mutedColor, size: 14),
                    const SizedBox(width: 4),
                    Text('${_matchDetails!.match.date.month}/${_matchDetails!.match.date.day}/${_matchDetails!.match.date.year}', style: TextStyle(color: mutedColor, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersHeader(ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('PLAYERS', style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          Text(_matchDetails?.match.scoringType == 'cooperative' ? 'RATING' : 'POSITION & RATING', style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(PlayerWithUser playerWithUser, ThemeData theme) {
    final player = playerWithUser.player;
    final user = playerWithUser.user;
    final rank = _playerRanks[player.id] ?? 0;
    final rating = _playerRatings[player.id] ?? 0.0;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    
    // In Coop: Winner determined by Team Victory. In Comp: by Rank 1.
    final isWinner = _matchDetails?.match.scoringType == 'cooperative' ? _coopVictory : rank == 1;

    final currentUser = context.read<UserSession>().currentUser;
    final creatorId = _matchDetails?.match.creatorId;
    
    // Permission Logic
    // 1. Score/Rank: Only Creator can edit. (If null/legacy, allow all)
    final canEditScore = (creatorId == null) || (currentUser?.id == creatorId);

    // 2. Rating: Any participant can edit, but typically they edit *their own*.
    // However, the prompt says "Any participant can alter the evaluation".
    // I'll interpret this as "I can only rate if I participated".
    // And assuming "Evaluation of the match" is personal.
    // So I can only change MY row's rating.
    final canEditRating = (currentUser?.id == user.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isWinner ? (_matchDetails?.match.scoringType == 'cooperative' ? Colors.green : theme.primaryColor).withOpacity(0.4) : Colors.transparent, width: 2),
      ),
      child: Column(
        children: [
           Row(
              children: [
                 InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDashboard(userId: user.id))),
                    child: Row(
                      children: [
                         CircleAvatar(
                            backgroundImage: user.avatarUrl != null 
                              ? (user.avatarUrl!.startsWith('http') 
                                  ? NetworkImage(user.avatarUrl!) 
                                  : (File(user.avatarUrl!).existsSync() ? FileImage(File(user.avatarUrl!)) as ImageProvider : null))
                              : null,
                            radius: 20,
                            backgroundColor: theme.colorScheme.surface,
                            child: user.avatarUrl == null || (user.avatarUrl != null && !user.avatarUrl!.startsWith('http') && !File(user.avatarUrl!).existsSync())
                                ? Text(user.username.isNotEmpty ? user.username.substring(0, 1).toUpperCase() : '?', 
                                    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold))
                                : null,
                         ),
                         const SizedBox(width: 12),
                         Text(user.username, style: TextStyle(fontSize: 16, fontWeight: isWinner ? FontWeight.bold : FontWeight.w500, color: theme.colorScheme.onSurface)),
                         const SizedBox(width: 12),
                    ],),
                 ),
                 Expanded(child: Container()), // Spacer
                 
                 // Rank Selector (Only if Competitive)
                 if (_matchDetails?.match.scoringType == 'competitive')
                 Opacity(
                    opacity: canEditScore ? 1.0 : 0.5,
                    child: IgnorePointer(
                       ignoring: !canEditScore,
                       child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                             color: theme.colorScheme.surface,
                             borderRadius: BorderRadius.circular(12),
                             border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                          ),
                          child: DropdownButtonHideUnderline(
                             child: DropdownButton<int>(
                                value: rank == 0 ? null : rank,
                                hint: Text('-', style: TextStyle(color: theme.colorScheme.onSurface)),
                                dropdownColor: theme.cardTheme.color,
                                icon: Icon(Icons.arrow_drop_down, color: mutedColor),
                                items: List.generate(_matchPlayers.length, (i) => i + 1).map((r) {
                                   return DropdownMenuItem(
                                      value: r,
                                      child: Text(_formatRank(r), style: TextStyle(
                                         color: r == 1 ? theme.primaryColor : theme.colorScheme.onSurface,
                                         fontWeight: r == 1 ? FontWeight.bold : FontWeight.normal
                                      )),
                                   );
                                }).toList(),
                                onChanged: (val) {
                                   if (val != null) {
                                      setState(() {
                                         _playerRanks[player.id] = val;
                                      });
                                   }
                                },
                             ),
                          ),
                       ),
                    ),
                 ),
              ],
           ),
           const SizedBox(height: 12),
           Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
           const SizedBox(height: 8),
           // Rating Row
           Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Rate Match:', style: TextStyle(color: mutedColor, fontSize: 12)),
                 Opacity(
                    opacity: canEditRating ? 1.0 : 0.3,
                    child: IgnorePointer(
                       ignoring: !canEditRating,
                       child: Row(
                          children: List.generate(5, (index) {
                             return GestureDetector(
                                onTap: () {
                                   setState(() {
                                      _playerRatings[player.id] = index + 1.0;
                                   });
                                },
                                child: Icon(
                                   index < rating ? Icons.star : Icons.star_border, 
                                   color: Colors.amber, 
                                   size: 20
                                ),
                             );
                          }),
                       ),
                    ),
                 ),
              ],
           ),
        ],
      ),
    );
  }

  String _formatRank(int rank) {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }

  /*
  Widget _buildAddPlayerButton() {
     // ... Removed to enforce "Participants cannot be changed after match finished"
     return SizedBox.shrink(); 
  }
  */

  Widget _buildStickyFooter(ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            final matchesDao = context.read<MatchesDao>();
            final currentUser = context.read<UserSession>().currentUser;
            final creatorId = _matchDetails?.match.creatorId;
            final isCoop = _matchDetails!.match.scoringType == 'cooperative';
            
            try {
              // Validation
              if (!isCoop) {
                 bool hasFirstPlace = false;
                 for (var p in _matchPlayers) {
                   if (_playerRanks[p.player.id] == 1) hasFirstPlace = true;
                 }
                 if (!hasFirstPlace) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a winner (1st place).'), backgroundColor: Colors.orange));
                    return;
                 }
              }
  
              for (var p in _matchPlayers) {
                // If the user is NOT the creator, they should ONLY update their own record!
                // This avoids RLS (Row Level Security) failures on Supabase when trying to update friends' data.
                if (currentUser?.id != creatorId && p.user.id != currentUser?.id) {
                   continue;
                }

                final rank = isCoop ? null : (_playerRanks[p.player.id] ?? 0);
                final rating = _playerRatings[p.player.id];
                final isWinner = isCoop ? _coopVictory : (rank == 1);
                
                await matchesDao.updatePlayerResult(p.player.id, rank ?? 0, isWinner, rating);
              }
              
               final notificationsDao = context.read<NotificationsDao>();
               if (isCoop) {
                  // Notify all about Team result
                  for (var p in _matchPlayers) {
                     await notificationsDao.createNotification(
                        userId: p.user.id,
                        type: 'match_result',
                        title: _coopVictory ? 'Mission Accomplished!' : 'Mission Failed',
                        message: _coopVictory 
                            ? 'Complete victory in ${_matchDetails!.game.name}!' 
                            : 'The team was defeated in ${_matchDetails!.game.name}. Only death remains.',
                        relatedId: widget.matchId.toString(),
                     );
                  }
               } else {
                   // Find legitimate winner from current state
                   String? effectiveWinnerId;
                   for (var p in _matchPlayers) {
                      if (_playerRanks[p.player.id] == 1) {
                         effectiveWinnerId = p.user.id;
                         break;
                      }
                   }
  
                   // Existing Winner Logic: Notify winner
                  if (effectiveWinnerId != null) {
                     // Find winner details
                     final winnerPlayer = _matchPlayers.firstWhere((p) => p.user.id == effectiveWinnerId!);
                     final winnerName = winnerPlayer.user.username;
                     // Mock score logic remains
                     
                     String message = 'You won the match of ${_matchDetails!.game.name}!';
                     try {
                         message = await AiMessageService.generateWinnerMessage(
                             _matchDetails!.game.name, 
                             winnerName, 
                             (winnerPlayer.player.matchRating ?? 0) * 20 > 0 ? (winnerPlayer.player.matchRating ?? 0).toInt() * 20 : 100,
                              _matchPlayers.map((p) => ((p.player.matchRating ?? 0) * 20).toInt()).toList()
                         );
                     } catch (e) {
                         debugPrint('AI Message generation failed: $e');
                     }
  
                     await notificationsDao.createNotification(
                        userId: effectiveWinnerId,
                        type: 'match_result',
                        title: 'Victory!',
                        message: message,
                        relatedId: widget.matchId.toString(),
                     );
                  }
               }
               
               // Gamification Triggers
               if (mounted) {
                 final gamificationService = context.read<GamificationService>();
                 for (var p in _matchPlayers) {
                     // Participation Base
                     await gamificationService.addXp(p.user.id, 10); 
                     
                     final isWinner = isCoop ? _coopVictory : (_playerRanks[p.player.id] == 1);
                     if (isWinner) {
                        // Win Reward: 40 for Coop, 50 for Competitive
                        final winReward = isCoop ? 40 : 50;
                        await gamificationService.addXp(p.user.id, winReward); 
                     }
                     
                     await gamificationService.checkAchievements(p.user.id);
                 }
               }

              if (!mounted) return;
              
              // Trigger background sync to push the Enqueued Player Results (UPDATEs)
              context.read<SupabaseSyncService>().sync();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const GameCatalog()),
                (route) => false,
              );
            } catch (e) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving match: $e')));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            elevation: 8,
            shadowColor: theme.primaryColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.check_circle_outline, size: 28),
          label: const Text('FINISH MATCH', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
      ),
    );
  }
}
