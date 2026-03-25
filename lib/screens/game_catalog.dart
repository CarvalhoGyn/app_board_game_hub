import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'game_details.dart';
import 'dart:io';

import 'create_match.dart';
import 'profile_dashboard.dart';
import 'explore_screen.dart';
import '../widgets/shared_bottom_nav.dart';
import '../providers/user_session.dart';
import 'notifications_screen.dart';
import '../widgets/staggered_slide_fade.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import 'package:app_board_game_hub/services/supabase_sync_service.dart';
import 'package:app_board_game_hub/widgets/sync_toast.dart';
import 'top_games_screen.dart';

class GameCatalog extends StatefulWidget {
  const GameCatalog({super.key});

  @override
  State<GameCatalog> createState() => _GameCatalogState();
}

class _GameCatalogState extends State<GameCatalog> {
  List<Game> _trendingGames = [];
  List<Game> _recommendedGames = [];
  bool _isLoading = true;
  bool _wasSyncing = false;
  OverlayEntry? _syncOverlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _setupSyncListener();
    });
  }

  void _setupSyncListener() {
    final syncService = context.read<SupabaseSyncService>();
    _wasSyncing = syncService.isSyncing.value;
    syncService.isSyncing.addListener(_onSyncChanged);
  }

  void _onSyncChanged() {
    if (!mounted) return;
    final isSyncing = context.read<SupabaseSyncService>().isSyncing.value;
    
    // Detect transition from true to false
    if (_wasSyncing && !isSyncing) {
      _showSyncToast();
    }
    
    _wasSyncing = isSyncing;
  }

  void _showSyncToast() {
    if (_syncOverlayEntry != null) {
      _syncOverlayEntry!.remove();
      _syncOverlayEntry = null;
    }

    final l10n = AppLocalizations.of(context)!;
    _syncOverlayEntry = OverlayEntry(
      builder: (context) => SyncToast(
        message: l10n.syncCompleted,
        onDismiss: () {
           _syncOverlayEntry?.remove();
           _syncOverlayEntry = null;
        },
      ),
    );

    Overlay.of(context).insert(_syncOverlayEntry!);
  }

  Future<void> _loadData() async {
    final userSession = context.read<UserSession>();
    final matchesDao = context.read<MatchesDao>();
    
    final currentUser = userSession.currentUser;
    debugPrint('Refresing GameCatalog for user: ${currentUser?.username}');
    
    try {
      if (currentUser != null) {
        final trending = await matchesDao.getTrendingGames(5);
        final stats = await matchesDao.getUserStats(currentUser.id);
        final matchCount = stats['matches'] as int? ?? 0;

        List<Game> recommended = [];
        if (matchCount > 0) {
           recommended = await matchesDao.getRecommendedGames(currentUser.id, 3);
        }
        
        if (mounted) {
           setState(() {
              _trendingGames = trending;
              _recommendedGames = recommended;
           });
        }
      }
    } catch (e) {
      debugPrint('Error loading game catalog data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    context.read<SupabaseSyncService>().isSyncing.removeListener(_onSyncChanged);
    _syncOverlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: theme.primaryColor,
        backgroundColor: theme.colorScheme.surface,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(theme, l10n),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _isLoading 
                    ? const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_trendingGames.isNotEmpty)
                         _buildTrendingSection(context, _trendingGames, theme, l10n)
                      else
                         _buildEmptyStateCard(
                           context,
                           theme,
                           title: l10n.noTrendingGames,
                           subtitle: l10n.noTrendingSubtitle,
                           icon: Icons.trending_up,
                           actionLabel: l10n.startMatch,
                           onAction: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateMatch())),
                         ),
  
                      if (_recommendedGames.isNotEmpty)
                        _buildRecommendedSection(context, _recommendedGames, theme, l10n)
                      else
                         _buildEmptyStateCard(
                           context,
                           theme,
                           title: l10n.needMoreData,
                           subtitle: l10n.needMoreDataSubtitle,
                           icon: Icons.auto_awesome,
                           actionLabel: l10n.exploreGamesButton,
                           onAction: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ExploreScreen())),
                         ),
                      const SizedBox(height: 100), // Extra space for floating nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    final userSession = context.watch<UserSession>();
    final currentUser = userSession.currentUser;

    if (currentUser == null) return const SizedBox.shrink();

    final displayName = currentUser.firstName != null && currentUser.lastName != null
        ? '${currentUser.firstName} ${currentUser.lastName}'
        : currentUser.username;
    
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primaryColor.withOpacity(0.5), width: 2),
                      image: DecorationImage(
                        image: () {
                          final url = currentUser.avatarUrl;
                          if (url != null && url.isNotEmpty) {
                             if (url.startsWith('http')) {
                               return NetworkImage(url);
                             } else {
                               final file = File(url);
                               if (file.existsSync()) {
                                 return FileImage(file); 
                               }
                             }
                          }
                          return const NetworkImage('https://i.pravatar.cc/150');
                        }() as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.welcomeBack, style: TextStyle(color: mutedColor, fontSize: 12, fontWeight: FontWeight.w500)),
                  Text(displayName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                ],
              ),
            ],
          ),
          // Notification Bell
          StreamBuilder<int>(
            stream: Stream.fromFuture(context.read<NotificationsDao>().getUnreadCount(currentUser.id)),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())).then((_) {
                        setState(() {}); // Refresh to update badge if needed
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(color: theme.cardTheme.color, shape: BoxShape.circle),
                      child: Icon(Icons.notifications_outlined, color: mutedColor),
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
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
        ],
      ),
    );
  }

  Widget _buildTrendingSection(BuildContext context, List<Game> games, ThemeData theme, AppLocalizations l10n) {
    if (games.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.trendingGames, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TopGamesScreen())), 
                child: Text(l10n.seeDetails, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 360,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: games.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final game = games[index];
              return StaggeredSlideFade(
                 index: index,
                 direction: Axis.horizontal,
                 child: _buildTrendingCard(
                   context: context,
                   game: game,
                   theme: theme,
                 ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard({
    required BuildContext context,
    required Game game,
    required ThemeData theme,
    Color? categoryColor,
  }) {
    final rating = game.rating?.toStringAsFixed(1) ?? 'N/A';
    final actualCategoryColor = categoryColor ?? theme.primaryColor;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GameDetails(game: game))),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(game.imageUrl ?? 'https://via.placeholder.com/280x360?text=${game.name}'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.favorite_border, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: actualCategoryColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(game.yearPublished?.toString() ?? 'BOARD GAME', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: theme.primaryColor, size: 14),
                            const SizedBox(width: 4),
                            Text(rating, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(game.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(game.description ?? 'Tap to see details', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context, List<Game> games, ThemeData theme, AppLocalizations l10n) {
    if (games.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Text(l10n.recommendedForYou, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Tablet/Desktop: Grid View
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3, // Wider cards
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                   final game = games[index];
                   return StaggeredSlideFade(
                     index: index,
                     child: _buildRecommendedItem(
                       context: context,
                       game: game,
                       theme: theme,
                       l10n: l10n,
                     ),
                   );
                },
              );
            } else {
              // Mobile: List View
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: games.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final game = games[index];
                  return StaggeredSlideFade(
                    index: index,
                    child: _buildRecommendedItem(
                      context: context,
                      game: game,
                      theme: theme,
                      l10n: l10n,
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedItem({
    required BuildContext context,
    required Game game,
    required ThemeData theme,
    required AppLocalizations l10n,
  }) {
    final rating = game.rating?.toStringAsFixed(1) ?? 'N/A';
    final players = game.minPlayers != null ? l10n.playersCount(game.minPlayers!, game.maxPlayers!) : 'Strategy';
    final time = game.maxPlaytime != null ? ' • ${game.maxPlaytime} min' : '';
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GameDetails(game: game))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: theme.cardTheme.color, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(game.imageUrl ?? 'https://via.placeholder.com/80?text=${game.name}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('$players$time', style: TextStyle(color: mutedColor, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: theme.primaryColor, size: 16),
                      const SizedBox(width: 4),
                      Text(rating, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      const SizedBox(width: 4),
                      Text(game.rank != null ? l10n.rankLabel(game.rank!) : '', style: TextStyle(color: mutedColor, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, shape: BoxShape.circle),
              child: Icon(Icons.bookmark_add_outlined, color: mutedColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Icon(icon, color: mutedColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: mutedColor, fontSize: 13)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: onAction,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(actionLabel, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: theme.primaryColor, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
