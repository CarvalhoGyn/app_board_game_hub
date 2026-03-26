import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import 'my_collection_screen.dart';
import 'notifications_screen.dart';
import 'match_history_screen.dart';
import 'achievements_screen.dart';
import '../services/gamification_service.dart';
import '../services/supabase_realtime_service.dart';
import '../widgets/language_selector.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as package;
import '../services/supabase_sync_service.dart';
import '../services/supabase_storage_service.dart';
import '../services/subscription_service.dart';
import 'paywall_screen.dart';

class ProfileDashboard extends StatefulWidget {
  final String? userId; // Optional: If null, shows current user's profile
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
    
    final userSession = context.read<UserSession>();
    final currentSessionUser = userSession.currentUser;
    final isMyProfile = userId == null || (currentSessionUser != null && userId == currentSessionUser.id);
    final targetUserId = isMyProfile ? currentSessionUser!.id : userId!;
    
    final matchesDao = context.read<MatchesDao>();
    final collectionsDao = context.read<UserGameCollectionsDao>();
    final friendshipsDao = context.read<FriendshipsDao>();
    final usersDao = context.read<UsersDao>();

    final results = await Future.wait([
      // 0: Target User details (Always fetch fresh from DB for accurate XP!)
      usersDao.getUserById(targetUserId),
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
    
    // Propagate updated user back to session if it's my profile
    if (isMyProfile && user != null && mounted) {
       Future.microtask(() => context.read<UserSession>().updateUser(user));
    }
    
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
               return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(AppLocalizations.of(context)!.error(snapshot.error.toString()), textAlign: TextAlign.center)));
            }
            
            final data = snapshot.data!;
            final user = data['user'] as User?;
            final isMyProfile = data['isMyProfile'] as bool;
            
            if (user == null) return Center(child: Text(AppLocalizations.of(context)!.error('User not found')));

            return Column(
              children: [
                _buildAppBar(context, user, isMyProfile, theme),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 700) {
                        // Tablet: 2-Column Layout
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
      final storageService = SupabaseStorageService();
      
      // Feedback
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing avatar...')));

      try {
         // 1. Upload to Supabase (Upsert handles cleaning up the old file implicitly by using same name)
         final publicUrl = await storageService.uploadAvatar(File(pickedFile.path), currentUser.id);
         
         if (publicUrl != null) {
            // 2. Update Local DB
            final usersDao = context.read<UsersDao>();
            await usersDao.updateUser(
              currentUser.id, 
              UsersCompanion(avatarUrl: drift.Value(publicUrl))
            );

            // 3. Update Cloud DB (Ensure sync)
            final supabase = package.Supabase.instance.client;
            await supabase.from('profiles').update({
              'avatar_url': publicUrl
            }).eq('id', currentUser.id);

            // 4. Update Session & UI
            final updatedUser = currentUser.copyWith(avatarUrl: drift.Value(publicUrl));
            userSession.updateUser(updatedUser); 
            
            // 5. Force specific UI refresh
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avatar updated and synced!')));
              _refresh();
            }
         }
      } catch (e) {
         if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
         }
      }
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
             const LanguageSelector(showLabel: false),

           Text(
            isMyProfile ? AppLocalizations.of(context)!.profileTitle : user.username,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: theme.colorScheme.onSurface),
          ),
          
          if (isMyProfile)
            Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: AppLocalizations.of(context)!.logoutButton,
                onPressed: () async {
                   await Supabase.instance.client.auth.signOut();
                   if (!context.mounted) return;
                   // Disconnect Realtime before logout
                   context.read<SupabaseRealtimeService>().unsubscribe();
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

  // ... (Following methods are the same as original)
  
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
                    image: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(user.avatarUrl!),
                            fit: BoxFit.cover,
                            onError: (e, s) => debugPrint('Dashboard Avatar Error: $e'),
                          )
                        : null,
                  ),
                  child: (user.avatarUrl == null || user.avatarUrl!.isEmpty) 
                    ? Center(
                        child: Text(
                          user.username.substring(0, user.username.length > 1 ? 2 : 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ) 
                    : null,
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
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                displayName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              if (user.isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.diamond, color: Colors.black, size: 14),
                      SizedBox(width: 4),
                      Text("PREMIUM", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
              if (prestigeStars.isNotEmpty)
                 Text(prestigeStars, style: const TextStyle(fontSize: 20)),
            ],
          ),
          
          if (isMyProfile && user.isPremium && user.subscriptionExpiresAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Plano ${user.subscriptionType?.toUpperCase() ?? 'PREMIUM'} • Expira em ${DateFormat('dd/MM/yyyy').format(user.subscriptionExpiresAt!)}",
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          
          if (isMyProfile && user.isPremium)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                onPressed: () => SubscriptionService().showCustomerCenter(),
                icon: Icon(Icons.subscriptions, color: theme.primaryColor, size: 16),
                label: Text("Gerenciar Assinatura", style: TextStyle(color: theme.primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
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
                label: Text(AppLocalizations.of(context)!.prestigeReset),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => _showPrestigeDialog(context, user.id, theme),
              ),
            ),
            
          if (isMyProfile) ...[
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
                AppLocalizations.of(context)!.editProfile,
                style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
            if (!user.isPremium)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaywallScreen()));
                  },
                  icon: const Icon(Icons.star, color: Colors.amber, size: 18),
                  label: const Text("Seja Premium", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
          ] else
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
           label: Text(AppLocalizations.of(context)!.friendsButton, style: TextStyle(color: theme.primaryColor)),
           style: OutlinedButton.styleFrom(
               side: BorderSide(color: theme.primaryColor),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
           ),
        );
     } else if (status == 'pending') {
        return OutlinedButton(
           onPressed: null,
           child: Text(AppLocalizations.of(context)!.requestSent, style: TextStyle(color: mutedColor)),
        );
     } else {
        return ElevatedButton.icon(
           onPressed: () async {
               final currentUser = context.read<UserSession>().currentUser;
               if (currentUser != null) {
                  // Show feedback immediately or via setState if we wanted loading spinner
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sending request...'), duration: Duration(milliseconds: 500)));
                  
                  final error = await context.read<SupabaseSyncService>().sendFriendRequest(user.id);
                  
                  if (error == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Friend request sent!')));
                      // Trigger refresh to update button state to "Pending"
                      // Since parent is Stateful, we can call _refresh if we pass it down, or just re-read via FutureBuilder re-trigger?
                      // _refresh() is not available here easily unless we pass a callback.
                      // But this method is inside State, so we can call _refresh()!
                      // Wait, _buildFriendActionButton is inside _ProfileDashboardState? Yes.
                      _refresh();
                  } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
                  }
               }
           },
           icon: Icon(Icons.person_add, color: theme.colorScheme.onPrimary),
           label: Text(AppLocalizations.of(context)!.addFriend, style: TextStyle(color: theme.colorScheme.onPrimary)),
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
             _buildStatItem(AppLocalizations.of(context)!.matchesTitle, matches.toString(), theme, mutedColor),
             Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withOpacity(0.1)),
             _buildStatItem(AppLocalizations.of(context)!.winsLabel, wins.toString(), theme, mutedColor),
             Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withOpacity(0.1)),
             _buildStatItem(AppLocalizations.of(context)!.winRateLabel, '$winRate%', theme, mutedColor),
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
                title: AppLocalizations.of(context)!.achievementsLabel,
                subtitle: AppLocalizations.of(context)!.badgesSubtitle,
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
                title: AppLocalizations.of(context)!.myCollection,
                subtitle: AppLocalizations.of(context)!.gamesCount(stats['collectionCount']),
                icon: Icons.inventory_2,
                color: theme.primaryColor,
                onTap: () {
                   if (isMyProfile) Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCollectionScreen()));
                },
             ),
             const SizedBox(height: 16),
             _buildMenuCard(
                context,
                theme,
                title: AppLocalizations.of(context)!.myWishlistTitle,
                subtitle: AppLocalizations.of(context)!.gamesCount(stats['wishlistCount']),
                icon: Icons.favorite,
                color: Colors.redAccent,
                onTap: () {
                    if (isMyProfile) Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistScreen()));
                },
             ),
             const SizedBox(height: 16),
             _buildMenuCard(
                context,
                theme,
                title: AppLocalizations.of(context)!.friendsButton,
                subtitle: AppLocalizations.of(context)!.friendsCount(stats['friendsCount']),
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
                title: AppLocalizations.of(context)!.matchHistory,
                subtitle: AppLocalizations.of(context)!.matchesPlayed(stats['matches']),
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
              final friend = display[index];
              final hasAvatar = friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty;
              return Positioned(
                 left: index * 20.0,
                 child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       border: Border.all(color: theme.cardTheme.color ?? Colors.grey, width: 2),
                       color: theme.cardTheme.color,
                       image: hasAvatar 
                           ? DecorationImage(
                               image: NetworkImage(friend.avatarUrl!),
                               fit: BoxFit.cover,
                               onError: (e, s) => debugPrint('Preview Avatar Error: $e'),
                             )
                           : null,
                    ),
                    child: !hasAvatar ? Center(
                       child: Text(
                          friend.username.substring(0, friend.username.length > 1 ? 2 : 1).toUpperCase(),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.primaryColor),
                       ),
                    ) : null,
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
               AppLocalizations.of(context)!.levelLabel(level), 
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
                     AppLocalizations.of(context)!.xpLabel(xp, nextLevelTotal),
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

  void _showPrestigeDialog(BuildContext context, String userId, ThemeData theme) {
     showDialog(
       context: context, 
       builder: (ctx) => AlertDialog(
         backgroundColor: theme.cardTheme.color,
         title: Text(AppLocalizations.of(context)!.prestigeAscension, style: const TextStyle(color: Colors.amber)),
         content: Text(
           AppLocalizations.of(context)!.prestigeWarning,
           style: TextStyle(color: theme.colorScheme.onSurface),
         ),
         actions: [
            TextButton(
               onPressed: () => Navigator.pop(ctx), 
               child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text(AppLocalizations.of(context)!.ascendButton, style: const TextStyle(color: Colors.black)),
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
