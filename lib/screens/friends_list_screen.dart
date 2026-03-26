import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/gamification_service.dart';
import '../database/database.dart';
import '../providers/user_session.dart';
import 'user_search_screen.dart';
import 'profile_dashboard.dart';
import 'dart:io';
import '../services/supabase_sync_service.dart';
import '../services/supabase_realtime_service.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> _friends = [];
  List<FriendshipWithUser> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    // Listen to Realtime updates and reload automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupabaseRealtimeService>().addListener(_onRealtimeUpdate);
    });
  }

  void _onRealtimeUpdate() {
    if (mounted) {
      try {
        _loadData();
      } catch (_) {
        // Widget may have been disposed between mounted check and read
      }
    }
  }

  @override
  void dispose() {
    context.read<SupabaseRealtimeService>().removeListener(_onRealtimeUpdate);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool syncFirst = false}) async {
    if (!mounted) return;
    // Capture all context-dependent references BEFORE any await
    final userSession = context.read<UserSession>();
    final friendshipsDao = context.read<FriendshipsDao>();
    final syncService = context.read<SupabaseSyncService>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    if (syncFirst) {
      await syncService.sync();
    }

    final friends = await friendshipsDao.getFriends(currentUser.id);
    final pending = await friendshipsDao.getPendingRequests(currentUser.id);

    if (mounted) {
      setState(() {
        _friends = friends;
        _pendingRequests = pending;
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(FriendshipWithUser request) async {
    setState(() => _isLoading = true);
    final service = context.read<SupabaseSyncService>();
    final gamificationService = context.read<GamificationService>();
    final userSession = context.read<UserSession>();
    
    final friendshipId = request.friendship.id;
    final senderId = request.friendship.userId; // sender = who sent the request
    final error = await service.respondToFriendRequest(friendshipId, true, senderId: senderId);
    
    if (error == null) {
      if (userSession.currentUser != null) {
         await gamificationService.addXp(userSession.currentUser!.id, 10);
      }
      await _loadData();
      if (mounted) {
        // DEBUG: mostra o ID para comparar com Supabase
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Aceito! ID usado: $friendshipId'),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), duration: const Duration(seconds: 12))
        );
        setState(() => _isLoading = false);
    }
  }

  Future<void> _rejectRequest(FriendshipWithUser request) async {
    setState(() => _isLoading = true);
    final service = context.read<SupabaseSyncService>();
    
    final error = await service.respondToFriendRequest(request.friendship.id, false);
    
    if (error == null) {
      await _loadData();
    } else {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
       setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friendsTitle, style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserSearchScreen()),
              ).then((_) => _loadData());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: mutedColor,
          tabs: [
            Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text(AppLocalizations.of(context)!.myFriendsTab))),
            Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text(_pendingRequests.isNotEmpty ? AppLocalizations.of(context)!.friendRequestsCount(_pendingRequests.length.toString()) : AppLocalizations.of(context)!.friendRequestsTab))),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
            _buildFriendsList(context, theme, mutedColor),
            _buildRequestsList(context, theme, mutedColor),
          ],
        ),
    );
  }

  ImageProvider? _getAvatarImage(String? url) {
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http')) {
        return NetworkImage(url);
      } else if (File(url).existsSync()) {
        return FileImage(File(url));
      }
    }
    return null;
  }

  Widget _buildAvatar(User user, ThemeData theme) {
    ImageProvider? imageProvider = _getAvatarImage(user.avatarUrl);

    return CircleAvatar(
      backgroundColor: theme.cardTheme.color ?? theme.colorScheme.surface,
      child: imageProvider != null 
          ? ClipOval(
              child: Image(
                image: imageProvider,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitials(user, theme);
                },
              ),
            )
          : _buildInitials(user, theme),
    );
  }

  Widget _buildInitials(User user, ThemeData theme) {
    return Center(
      child: Text(
        user.username.length > 1 ? user.username.substring(0, 2).toUpperCase() : user.username.toUpperCase(),
        style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context, ThemeData theme, Color mutedColor) {
    if (_friends.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadData(syncFirst: true),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            Icon(Icons.people_outline, size: 64, color: mutedColor.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Center(child: Text(AppLocalizations.of(context)!.noFriendsYet, style: TextStyle(color: mutedColor, fontSize: 18))),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSearchScreen())).then((_) => _loadData());
                },
                icon: Icon(Icons.search, color: theme.primaryColor),
                label: Text(AppLocalizations.of(context)!.findFriendsButton, style: TextStyle(color: theme.primaryColor)),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadData(syncFirst: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDashboard(userId: friend.id)));
            },
            leading: _buildAvatar(friend, theme),
            title: Text(
              friend.username,
              style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
            subtitle: friend.firstName != null
                ? Text('${friend.firstName} ${friend.lastName ?? ""}', style: TextStyle(color: mutedColor))
                : null,
          );
        },
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, ThemeData theme, Color mutedColor) {
    if (_pendingRequests.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadData(syncFirst: true),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            Center(child: Text(AppLocalizations.of(context)!.noPendingRequests, style: TextStyle(color: mutedColor))),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadData(syncFirst: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingRequests.length,
        itemBuilder: (context, index) {
          final request = _pendingRequests[index];
          return Card(
            color: theme.cardTheme.color,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildAvatar(request.user, theme),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.user.username,
                          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          AppLocalizations.of(context)!.sentFriendRequest,
                          style: TextStyle(color: mutedColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () => _acceptRequest(request),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                    onPressed: () => _rejectRequest(request),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
