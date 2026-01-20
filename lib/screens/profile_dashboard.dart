import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import '../theme/app_theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import '../widgets/shared_bottom_nav.dart';
import '../providers/user_session.dart';
import 'edit_profile_screen.dart';
import 'wishlist_screen.dart';
import 'friends_list_screen.dart';
import 'login_screen.dart';

import 'my_collection_screen.dart';
import 'notifications_screen.dart';
import 'match_history_screen.dart';
import 'achievements_screen.dart';
import '../services/gamification_service.dart';

class ProfileDashboard extends StatefulWidget {
  final int? userId; // Optional: If null, shows current user's profile
  const ProfileDashboard({super.key, this.userId});

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final userId = widget.userId; 
    // We need to access providers. context.read is safe here or in the future execution.
    // However, we need to know WHO we are loading for.
    // The previous logic determined 'targetUserId' inside build based on UserSession.
    // We should replicate that or just fetch it.
    
    final userSession = context.read<UserSession>();
    final currentSessionUser = userSession.currentUser;
    final isMyProfile = userId == null || (currentSessionUser != null && userId == currentSessionUser.id);
    final targetUserId = isMyProfile ? currentSessionUser!.id : userId!;
    
    final matchesDao = context.read<MatchesDao>();
    final collectionsDao = context.read<UserGameCollectionsDao>();
    final friendshipsDao = context.read<FriendshipsDao>();
    final usersDao = context.read<UsersDao>();

    final results = await Future.wait([
      // 0: Target User details
      isMyProfile ? Future.value(currentSessionUser) : usersDao.getUserById(targetUserId),
      // 1: Stats
      matchesDao.getUserStats(targetUserId),
      // 2: Wishlist Count
      collectionsDao.getWishlistCount(targetUserId),
      // 3: Friend Count
      friendshipsDao.getFriendCount(targetUserId),
      // 4: Collection Count
      collectionsDao.getOwnedCount(targetUserId),
      // 5: Wishlist Games
      collectionsDao.getWishlist(targetUserId),
      // 6: Friends List
      friendshipsDao.getFriends(targetUserId),
      // 7: Friendship status
      !isMyProfile && currentSessionUser != null 
          ? friendshipsDao.getFriendshipStatus(currentSessionUser.id, targetUserId)
          : Future.value(null),
      // 8: Match History
      matchesDao.getMatchesForUser(targetUserId),
    ]);

    final user = results[0] as User?;
    final matchStats = results[1] as Map<String, dynamic>;
    
    return {
      'user': user,
      'matches': matchStats['matches'],
      'wins': matchStats['wins'],
      'wishlistCount': results[2],
      'friendsCount': results[3],
      'collectionCount': results[4],
      'wishlistGames': results[5],
      'friendsList': results[6],
      'friendshipStatus': results[7],
      'matchHistory': results[8],
      'isMyProfile': isMyProfile,
    };
  }

  Future<void> _refresh() async {
    setState(() {
      _profileFuture = _loadData();
    });
    await _profileFuture;
  }

  @override
  Widget build(BuildContext context) {
    // We still watch UserSession to trigger rebuilds on login/logout changes if needed,
    // but the data loading is now manual/cached. 
    // Actually, if we just use context.read in _loadData, we might miss session updates.
    // But for 'pull to refresh', manual is fine.
    // If user logs out, the parent widget usually handles navigation (ProfileDashboard cheks for null user).
    
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
               return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
               return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Error loading profile: ${snapshot.error}', textAlign: TextAlign.center)));
            }
            
            final data = snapshot.data!;
            final user = data['user'] as User?;
            final isMyProfile = data['isMyProfile'] as bool;
            
            if (user == null) return const Center(child: Text("User not found"));

            return Column(
              children: [
                _buildAppBar(context, user, isMyProfile, theme),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 700) {
                        // Tablet: 2-Column Layout
                        // Note: RefreshIndicator on tablet is tricky with split view. 
                        // We wrap the Right Column (Content) for now, or implicitely let users use button.
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300,
                              child: SingleChildScrollView(
                                child: _buildProfileHeader(user, context, isMyProfile, data['friendshipStatus'], theme),
                              ),
                            ),
                            Container(width: 1, color: theme.colorScheme.onSurface.withOpacity(0.1)),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: _refresh,
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Column(
                                    children: [
                                      _buildStatsOverview(context, data, theme),
                                      const SizedBox(height: 24),
                                      _buildMenuOptions(context, data, isMyProfile, theme),
                                      const SizedBox(height: 100),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Mobile: Single Column with Refresh
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                _buildProfileHeader(user, context, isMyProfile, data['friendshipStatus'], theme),
                                _buildStatsOverview(context, data, theme),
                                const SizedBox(height: 24),
                                _buildMenuOptions(context, data, isMyProfile, theme),
                                const SizedBox(height: 100), 
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: (widget.userId == null) ? const SharedBottomNav(currentIndex: 3) : null,
    );
  }

  Future<void> _updateAvatar(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && context.mounted) {
      final userSession = context.read<UserSession>();
      final currentUser = userSession.currentUser!;
      
      final directory = await getApplicationDocumentsDirectory();
      final name = 'avatar_${currentUser.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy('${directory.path}/$name');

      final usersDao = context.read<UsersDao>();
      await usersDao.updateUser(
        currentUser.id, 
        UsersCompanion(avatarUrl: drift.Value(savedImage.path))
      );

      final updatedUser = currentUser.copyWith(avatarUrl: drift.Value(savedImage.path));
      userSession.updateUser(updatedUser); 
      _refresh(); // Refresh UI to show new avatar
    }
  }

  Widget _buildAppBar(BuildContext context, User user, bool isMyProfile, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isMyProfile)
             IconButton(
               icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
               onPressed: () => Navigator.pop(context),
             )
          else
             const SizedBox(width: 48), // Spacer to balance if needed, or just nothing

           Text(
            isMyProfile ? 'My Profile' : user.username,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: theme.colorScheme.onSurface),
          ),
          
          if (isMyProfile)
            Row(
            children: [
              // Notification Bell
              StreamBuilder<int>(
                stream: Stream.fromFuture(context.read<NotificationsDao>().getUnreadCount(user.id)),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;
                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount > 9 ? '9+' : unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
                tooltip: 'Logout',
                onPressed: () {
                   context.read<UserSession>().logout();
                   Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (context) => const LoginScreen()),
                     (route) => false,
                   );
                },
              ),
            ],
          ) else const SizedBox(width: 48), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user, BuildContext context, bool isMyProfile, String? friendshipStatus, ThemeData theme) {
    final displayName = user.firstName != null && user.lastName != null
        ? '${user.firstName} ${user.lastName}'
        : user.username;
        
    final prestigeStars = user.prestige > 0 ? '⭐' * user.prestige : '';
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, const Color(0xFF00B0FF)], // Primary -> Cyan
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.scaffoldBackgroundColor, width: 4),
                    color: theme.cardTheme.color,
                     image: user.avatarUrl != null 
                        ? DecorationImage(
                            image: user.avatarUrl!.startsWith('http') 
                                ? NetworkImage(user.avatarUrl!) 
                            : (File(user.avatarUrl!).existsSync() 
                                    ? FileImage(File(user.avatarUrl!)) as ImageProvider
                                    : const NetworkImage('https://i.pravatar.cc/150')),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user.avatarUrl == null ? Center(
                    child: Text(
                      user.username.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ) : null,
                ),
              ),
              if (isMyProfile)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _updateAvatar(context, ImageSource.gallery),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primaryColor, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, color: theme.primaryColor, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              if (prestigeStars.isNotEmpty) ...[
                 const SizedBox(width: 8),
                 Text(prestigeStars, style: const TextStyle(fontSize: 20)),
              ],
            ],
          ),


          const SizedBox(height: 16),
          // Level & XP
          _buildLevelIndicator(user.xp, theme),
          const SizedBox(height: 20),
          // Prestige Button
          if (isMyProfile && _getLevel(user.xp) >= GamificationService.maxLevel)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.stars, color: Colors.amber),
                label: const Text('PRESTIGE RESET'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => _showPrestigeDialog(context, user.id, theme),
              ),
            ),
            
          if (isMyProfile)
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.cardTheme.color ?? Colors.grey, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
            )
          else
             _buildFriendActionButton(context, user, friendshipStatus, theme),
        ],
      ),
    );
  }

  Widget _buildFriendActionButton(BuildContext context, User user, String? status, ThemeData theme) {
     final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
     if (status == 'accepted') {
        return OutlinedButton.icon(
           onPressed: () {}, // Maybe unfriend
           icon: Icon(Icons.check, color: theme.primaryColor),
           label: Text('Friends', style: TextStyle(color: theme.primaryColor)),
           style: OutlinedButton.styleFrom(
               side: BorderSide(color: theme.primaryColor),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
           ),
        );
     } else if (status == 'pending') {
        return OutlinedButton(
           onPressed: null,
           child: Text('Request Sent', style: TextStyle(color: mutedColor)),
        );
     } else {
        return ElevatedButton.icon(
           onPressed: () async {
               final currentUser = context.read<UserSession>().currentUser;
               if (currentUser != null) {
                  await context.read<FriendshipsDao>().sendFriendRequest(currentUser.id, user.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Friend request sent!')));
                  // Note: To refresh UI, we'd need setState. As this is stateless, simpler to assume user sees feedback.
                  // Ideally, convert to Stateful.
               }
           },
           icon: Icon(Icons.person_add, color: theme.colorScheme.onPrimary),
           label: Text('Add Friend', style: TextStyle(color: theme.colorScheme.onPrimary)),
           style: ElevatedButton.styleFrom(
               backgroundColor: theme.primaryColor,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
           ),
        );
     }
  }

  Widget _buildStatsOverview(BuildContext context, Map<String, dynamic> stats, ThemeData theme) {
    int matches = stats['matches'];
    int wins = stats['wins'];
    int winRate = matches > 0 ? ((wins / matches) * 100).toInt() : 0;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Container(
       margin: const EdgeInsets.symmetric(horizontal: 16),
       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
       decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
       ),
       child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             _buildStatItem('Matches', matches.toString(), theme, mutedColor),
             Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withOpacity(0.1)),
             _buildStatItem('Wins', wins.toString(), theme, mutedColor),
             Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withOpacity(0.1)),
             _buildStatItem('Win Rate', '$winRate%', theme, mutedColor),
          ],
       ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme, Color mutedColor) {
     return Column(
        children: [
           Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
           const SizedBox(height: 4),
           Text(label, style: TextStyle(fontSize: 12, color: mutedColor)),
        ],
     );
  }

  Widget _buildMenuOptions(BuildContext context, Map<String, dynamic> stats, bool isMyProfile, ThemeData theme) {
      final wishlistGames = stats['wishlistGames'] as List<Game>;
      final friendsList = stats['friendsList'] as List<User>;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
             _buildMenuCard(
                context, 
                theme,
                title: 'Achievements',
                subtitle: 'Badges and milestones',
                icon: Icons.emoji_events,
                color: Colors.amber,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsScreen(userId: (stats['user'] as User).id, isMyProfile: isMyProfile)));
                },
             ),
             const SizedBox(height: 16),
             _buildMenuCard(
                context, 
                theme,
                title: 'My Collection',
                subtitle: '${stats['collectionCount']} games',
                icon: Icons.category,
                color: theme.primaryColor,
                onTap: () {
                   if (isMyProfile) Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCollectionScreen()));
                },
             ),
             const SizedBox(height: 16),
             _buildMenuCard(
                context,
                theme,
                title: 'Wishlist',
                subtitle: '${stats['wishlistCount']} games',
                icon: Icons.favorite,
                color: Colors.redAccent,
                trailingWidget: _buildWishlistPreviews(wishlistGames),
                onTap: () {
                    if (isMyProfile) Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistScreen()));
                },
             ),
             const SizedBox(height: 16),
             _buildMenuCard(
                context,
                theme,
                title: 'Friends',
                subtitle: '${stats['friendsCount']} friends',
                icon: Icons.diversity_3,
                color: Colors.blueAccent,
                trailingWidget: _buildFriendsPreviews(friendsList, theme),
                onTap: () {
                  if (isMyProfile) Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsListScreen()));
                },
             ),
             
             const SizedBox(height: 16),
             _buildMenuCard(
                context,
                theme,
                title: 'Game History',
                subtitle: '${stats['matches']} matches played',
                icon: Icons.history,
                color: Colors.purpleAccent,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => MatchHistoryScreen(userId: (stats['user'] as User).id)));
                },
             ),
          ],
        ),
      );
  }



  Widget _buildMenuCard(BuildContext context, ThemeData theme, {
      required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
      Widget? trailingWidget,
  }) {
      final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
      return Material(
          color: Colors.transparent,
          child: InkWell(
             onTap: onTap,
             borderRadius: BorderRadius.circular(24),
             child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                   color: theme.cardTheme.color,
                   borderRadius: BorderRadius.circular(24),
                   border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
                ),
                child: Row(
                   children: [
                      Container(
                         padding: const EdgeInsets.all(12),
                         decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                         ),
                         child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                              Text(subtitle, style: TextStyle(fontSize: 13, color: mutedColor)),
                           ],
                        ),
                      ),
                      if (trailingWidget != null) ...[
                          const SizedBox(width: 12),
                          trailingWidget,
                          const SizedBox(width: 12),
                      ],
                      Icon(Icons.chevron_right, color: mutedColor),
                   ],
                ),
             ),
          ),
      );
  }
  
  Widget _buildWishlistPreviews(List<Game> games) {
     if (games.isEmpty) return const SizedBox.shrink();
     
     final display = games.take(3).toList();
     return SizedBox(
        height: 32,
        child: Row(
           mainAxisSize: MainAxisSize.min,
           children: display.map((g) => Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ClipRRect(
                 borderRadius: BorderRadius.circular(6),
                 child: Image.network(g.imageUrl ?? '', width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.grey, width:32)),
              ),
           )).toList(),
        ),
     );
  }

  Widget _buildFriendsPreviews(List<User> friends, ThemeData theme) {
      if (friends.isEmpty) return const SizedBox.shrink();

      final display = friends.take(3).toList();
      return SizedBox(
        width: 20.0 * (display.length - 1) + 32,
        height: 32,
        child: Stack(
           children: List.generate(display.length, (index) {
              return Positioned(
                 left: index * 20.0,
                 child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       border: Border.all(color: theme.cardTheme.color ?? Colors.grey, width: 2),
                       image: DecorationImage(
                         image: display[index].avatarUrl != null 
                           ? (display[index].avatarUrl!.startsWith('http') 
                               ? NetworkImage(display[index].avatarUrl!) 
                               : (File(display[index].avatarUrl!).existsSync() 
                                   ? FileImage(File(display[index].avatarUrl!)) as ImageProvider
                                   : NetworkImage('https://i.pravatar.cc/150?u=${display[index].id}')))
                           : NetworkImage('https://i.pravatar.cc/150?u=${display[index].id}'),
                         fit: BoxFit.cover,
                       ),
                    ),
                 ),
              );
           }),
         ),
      );
  }

  Widget _buildLevelIndicator(int xp, ThemeData theme) {
    final level = GamificationService.getLevel(xp);
    final progress = GamificationService.getProgressToNextLevel(xp);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    
    // For display: "XP in Level / Total for Next Level"
    // Since math is complex, we just show "XP Needed for Next" or current progress relative to next level delta.
    // Let's rely on progress bar and show absolute text like "1540 / 2380 XP" (Total)
    final nextLevelTotal = GamificationService.getXpRequiredForLevel(level + 1);
    
    return Column(
      children: [
         Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
               color: theme.primaryColor,
               borderRadius: BorderRadius.circular(12),
               boxShadow: [BoxShadow(color: theme.primaryColor.withValues(alpha: 0.4), blurRadius: 8)],
            ),
            child: Text(
               'LEVEL $level', 
               style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 12)
            ),
         ),
         const SizedBox(height: 8),
         SizedBox(
            width: 200,
            child: Column(
               children: [
                  ClipRRect(
                     borderRadius: BorderRadius.circular(4),
                     child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                        color: theme.primaryColor,
                        minHeight: 6,
                     ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                     '$xp / $nextLevelTotal XP',
                     style: TextStyle(color: mutedColor, fontSize: 10),
                  )
               ],
            ),
         )
      ],
    );
  }

  int _getLevel(int xp) {
     return GamificationService.getLevel(xp);
  }

  void _showPrestigeDialog(BuildContext context, int userId, ThemeData theme) {
     showDialog(
       context: context, 
       builder: (ctx) => AlertDialog(
         backgroundColor: theme.cardTheme.color,
         title: const Text('🌟 Prestige Ascension 🌟', style: TextStyle(color: Colors.amber)),
         content: Text(
           'Are you sure? This will RESET your level to 1, but you will gain a PRESTIGE STAR and eternal glory.',
           style: TextStyle(color: theme.colorScheme.onSurface),
         ),
         actions: [
            TextButton(
               onPressed: () => Navigator.pop(ctx), 
               child: const Text('Cancel', style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('ASCEND', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                 Navigator.pop(ctx);
                 await context.read<GamificationService>().prestigeUser(userId);
                 _refresh(); // Refresh
              },
            ),
         ],
       )
     );
  }

}
