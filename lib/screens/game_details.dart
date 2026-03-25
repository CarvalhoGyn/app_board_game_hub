import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../providers/user_session.dart';
import '../services/supabase_sync_service.dart';
import '../l10n/app_localizations.dart';

class GameDetails extends StatefulWidget {
  final Game game;
  const GameDetails({super.key, required this.game});

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  late Game _currentGame;
  bool _isLoading = false;
  bool _isOwned = false;
  bool _isWishlisted = false;

  // --- REVIEWS LOGIC ---
  List<ReviewWithUser> _reviews = [];

  Future<void> _fetchReviews() async {
    debugPrint('Fetching reviews for game ${_currentGame.id}');
    
    // 1. Pull on-demand from Supabase
    try {
      final syncService = context.read<SupabaseSyncService>();
      await syncService.pullGameReviews(_currentGame.id);
    } catch (e) {
      debugPrint('Sync: Error pulling reviews: $e');
    }

    // 2. Load from Local DB
    final reviewsDao = context.read<ReviewsDao>();
    final results = await reviewsDao.getReviewsForGame(_currentGame.id);
    debugPrint('Fetched ${results.length} reviews');
    if (mounted) setState(() => _reviews = results);
  }

  Future<void> _submitReview(double rating, String comment, String userId) async {
    debugPrint('Submitting review (Cloud-First): User $userId, Game ${_currentGame.id}, Rating $rating');
    try {
      setState(() => _isLoading = true);
      final service = context.read<SupabaseSyncService>();
      
      final error = await service.submitReview(
        gameId: _currentGame.id,
        rating: rating,
        comment: comment.isEmpty ? null : comment,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (error == null) {
          debugPrint('Review submitted successfully via Cloud-First');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted!')));
          await _fetchReviews(); // Refresh list from local DB (which was updated by service)
        } else {
          debugPrint('Error from Cloud-First Review: $error');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
        }
      }
    } catch (e) {
      debugPrint('Error submitting review: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentGame = widget.game;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCollectionStatus();
      _fetchReviews(); // Fetch reviews on load
    });
  }

  Future<void> _checkCollectionStatus() async {
     final dao = context.read<UserGameCollectionsDao>();
     final userSession = context.read<UserSession>();
     if (userSession.currentUser == null) return;
     
     final inWishlist = await dao.isInWishlist(userSession.currentUser!.id, _currentGame.id);
     final inCollection = await dao.isOwned(userSession.currentUser!.id, _currentGame.id);
     
     if (mounted) {
       setState(() {
         _isWishlisted = inWishlist;
         _isOwned = inCollection;
       });
     }
  }


  Future<void> _toggleWishlist() async {
      await _performCollectionAction(
          collectionType: 'wishlist',
          currentState: _isWishlisted,
          onSuccess: (val) => setState(() => _isWishlisted = val)
      );
  }

  Future<void> _toggleCollection() async {
      await _performCollectionAction(
          collectionType: 'owned',
          currentState: _isOwned,
          onSuccess: (val) => setState(() => _isOwned = val)
      );
  }

  Future<void> _performCollectionAction({
      required String collectionType,
      required bool currentState,
      required Function(bool) onSuccess,
  }) async {
      final user = context.read<UserSession>().currentUser;
      if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login required')));
          return;
      }

      setState(() => _isLoading = true);

      final service = context.read<SupabaseSyncService>();
      
      // Determine action (Add if not currently true, Remove if true)
      final isAdding = !currentState;
      
      final error = await service.toggleCollectionStatus(
          gameId: _currentGame.id,
          collectionType: collectionType,
          addToCollection: isAdding
      );
      
      if (mounted) {
         setState(() => _isLoading = false);
         
         if (error == null) {
             // Success: Update UI state
             onSuccess(isAdding);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 content: Text(isAdding ? 'Added to ${collectionType.toUpperCase()}' : 'Removed from ${collectionType.toUpperCase()}'),
                 duration: const Duration(seconds: 1),
             ));
         } else {
             // Error
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
         }
      }
  }

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
  
      return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
              children: [
                   CustomScrollView(
                    slivers: [
                        SliverAppBar(
                            expandedHeight: 300,
                            pinned: true,
                            backgroundColor: theme.scaffoldBackgroundColor,
                            flexibleSpace: FlexibleSpaceBar(
                                background: _buildImageSection(theme),
                            ),
                            leading: IconButton(
                                icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface, shadows: const [Shadow(color: Colors.black, blurRadius: 10)]),
                                onPressed: () => Navigator.pop(context),
                            ),
                            actions: [
                                if (_isLoading)
                                    Padding(padding: const EdgeInsets.all(12), child: CircularProgressIndicator(color: theme.colorScheme.onSurface, strokeWidth: 2)),
                                IconButton(
                                    icon: Icon(_isWishlisted ? Icons.bookmark : Icons.bookmark_outline, color: theme.colorScheme.onSurface, shadows: const [Shadow(color: Colors.black, blurRadius: 10)]),
                                    onPressed: _toggleWishlist,
                                ),
                                IconButton(
                                    icon: Icon(_isOwned ? Icons.shopping_bag : Icons.shopping_bag_outlined, color: theme.colorScheme.onSurface, shadows: const [Shadow(color: Colors.black, blurRadius: 10)]),
                                    onPressed: _toggleCollection,
                                ),
                            ],
                        ),
                        SliverToBoxAdapter(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        _buildTitleSection(theme),
                                        _buildStatsGrid(theme),
                                        _buildDescriptionSection(theme),
                                        _buildClassificationSection(theme),
                                        Divider(color: theme.colorScheme.onSurface.withValues(alpha:0.1), height: 32),
                                        _buildReviewsSection(theme),
                                    ],
                                ),
                            ),
                        ),
                    ],
                   ),
                   _buildStickyBottomButton(theme),
              ],
          ),
      );
  }

  Widget _buildImageSection(ThemeData theme) {
     final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
     if (_currentGame.imageUrl == null) return Container(color: theme.cardTheme.color, child: Icon(Icons.casino, size: 64, color: mutedColor));

     return Stack(
        fit: StackFit.expand,
        children: [
            Image.network(_currentGame.imageUrl!, fit: BoxFit.cover),
            BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(color: Colors.black.withValues(alpha:0.4))),
            Center(child: Image.network(_currentGame.imageUrl!, fit: BoxFit.contain)),
        ],
     );
  }

  // --- UI BUILDERS ---

  Widget _buildTitleSection(ThemeData theme) {
    final year = _currentGame.yearPublished != null ? '${_currentGame.yearPublished}' : '';
    final categories = _currentGame.categories?.split(', ').where((s) => s.trim().isNotEmpty).toList() ?? [];
    final mechanics = _currentGame.mechanics?.split(', ').where((s) => s.trim().isNotEmpty).toList() ?? [];
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(child: Text(_currentGame.name, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: theme.colorScheme.onSurface))),
                if (year.isNotEmpty)
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: theme.primaryColor.withValues(alpha:0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.primaryColor.withValues(alpha:0.5))),
                    child: Text(year, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
            ],
            ),
          const SizedBox(height: 4),
          // BGG ID removed
          const SizedBox(height: 16),
          
          if (categories.isNotEmpty) ...[
            Text('CATEGORIES', style: TextStyle(color: mutedColor, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: categories.take(5).map((cat) => _buildTag(cat, Colors.blue, theme)).toList(),
            ),
            const SizedBox(height: 12),
          ],
          
          if (mechanics.isNotEmpty) ...[
            Text('MECHANICS', style: TextStyle(color: mutedColor, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: mechanics.take(5).map((mech) => _buildTag(mech, Colors.green, theme)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label, MaterialColor color, ThemeData theme) {
    // Adjust text color based on brightness for legibility
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? color[100] : color[800];
    final borderColor = isDark ? color.withValues(alpha:0.3) : color.withValues(alpha:0.5);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha:0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    final rating = _currentGame.rating?.toStringAsFixed(1) ?? 'N/A';
    
    // Players
    final minP = _currentGame.minPlayers;
    final maxP = _currentGame.maxPlayers;
    final playersText = (minP != null && maxP != null) 
       ? (minP == maxP ? '$minP' : '$minP-$maxP')
       : 'N/A';
       
    // Time
    final minT = _currentGame.minPlaytime;
    final maxT = _currentGame.maxPlaytime;
    final timeText = (minT != null && maxT != null)
       ? (minT == maxT ? '$minT' : '$minT-$maxT')
       : 'N/A';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatItem(rating, 'BGG Rating', theme, isPrimary: true),
          const SizedBox(width: 8),
          _buildStatItem(timeText, 'Time', theme),
          const SizedBox(width: 8),
          _buildStatItem(playersText, 'Players', theme),
        ],
      ),
    );
  }

  // Helper _buildStatItem remains same but ensures consistency
  Widget _buildStatItem(String value, String label, ThemeData theme, {bool isPrimary = false}) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
        ),
        child: Column(
          children: [
            Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isPrimary ? theme.primaryColor : theme.colorScheme.onSurface)),
            const SizedBox(height: 4),
            Text(label.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: mutedColor, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    if (_currentGame.description == null || _currentGame.description!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('About this Game', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
           const SizedBox(height: 8),
           Container(
             height: 140,
             width: double.infinity,
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: theme.cardTheme.color,
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
             ),
             child: Scrollbar(
               thumbVisibility: true,
               child: SingleChildScrollView(
                 padding: const EdgeInsets.only(right: 12),
                 child: Text(
                   _currentGame.description!, 
                   style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.9), height: 1.5, fontSize: 14),
                 ),
               ),
             ),
           ),
           const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildClassificationSection(ThemeData theme) {
     final type = _currentGame.type;
     final families = _currentGame.families;
     final integrations = _currentGame.integrations;
     final reimpl = _currentGame.reimplementations;
     
     if ((type == null || type.isEmpty) && 
         (families == null || families.isEmpty) && 
         (integrations == null || integrations.isEmpty) &&
         (reimpl == null || reimpl.isEmpty)) {
         return const SizedBox.shrink();
     }

     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text('Classification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 16),
            if (type != null && type.isNotEmpty) _buildClassificationItem('Type', type, Icons.category_outlined, theme),
            if (families != null && families.isNotEmpty) _buildClassificationItem('Family', families, Icons.diversity_3_outlined, theme),
            if (integrations != null && integrations.isNotEmpty) _buildClassificationItem('Integrations', integrations, Icons.link, theme),
            if (reimpl != null && reimpl.isNotEmpty) _buildClassificationItem('Reimplements', reimpl, Icons.update, theme),
        ],
      ),
    );
  }

  Widget _buildClassificationItem(String label, String value, IconData icon, ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    final items = value.split(', ').where((s) => s.trim().isNotEmpty).map((s) {
        return s.replaceAll(RegExp(r'^(Category|Game|Components|Creatures|Crowdfunding|Theme|Admin|Misc): '), '').trim();
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              children: [
                  Icon(icon, size: 14, color: mutedColor),
                  const SizedBox(width: 8),
                  Text(label.toUpperCase(), style: TextStyle(color: mutedColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ]
          ),
          const SizedBox(height: 8),
          Wrap(
             spacing: 6,
             runSpacing: 6,
             children: items.map((item) => Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                 decoration: BoxDecoration(
                     color: theme.colorScheme.onSurface.withValues(alpha:0.05),
                     borderRadius: BorderRadius.circular(6),
                     border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1))
                 ),
                 child: Text(item, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface)),
             )).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildReviewsSection(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(l10n.communityReviews, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 16),
            _buildReviewSummary(theme),
            const SizedBox(height: 16),
            if (_reviews.isEmpty)
                Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('No reviews yet. Be the first!', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.54)))))
            else
                Column(children: _reviews.take(5).map((r) => _buildReviewCard(r, theme)).toList()),
        ],
      ),
    );
  }

  Widget _buildReviewSummary(ThemeData theme) {
    if (_reviews.isEmpty) return const SizedBox.shrink();
    
    final avg = _reviews.map((r) => r.review.rating).reduce((a, b) => a + b) / _reviews.length;
    final count = _reviews.length;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    
    // Distribution for 5 stars
    final dist = <int, int>{5:0, 4:0, 3:0, 2:0, 1:0};
    for (var r in _reviews) {
        final rounded = r.review.rating.round().clamp(1, 5);
        dist[rounded] = (dist[rounded] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.cardTheme.color, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1))),
      child: Row(
        children: [
          Column(
            children: [
              Text(avg.toStringAsFixed(1), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
               Row(
                children: List.generate(5, (index) => Icon(
                    index < avg.round() ? Icons.star : Icons.star_outline, 
                    color: theme.primaryColor, 
                    size: 14
                )),
              ),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context)!.ratingsCount(count), style: TextStyle(color: mutedColor, fontSize: 10)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(5, count > 0 ? dist[5]! / count : 0, theme),
                _buildRatingBar(4, count > 0 ? dist[4]! / count : 0, theme),
                _buildRatingBar(3, count > 0 ? dist[3]! / count : 0, theme),
                _buildRatingBar(2, count > 0 ? dist[2]! / count : 0, theme),
                _buildRatingBar(1, count > 0 ? dist[1]! / count : 0, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double percentage, ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text('$star', style: TextStyle(color: mutedColor, fontSize: 10)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha:0.1),
                color: theme.primaryColor,
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewWithUser reviewData, ThemeData theme) {
    final r = reviewData.review;
    final u = reviewData.user;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.cardTheme.color, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   _buildUserAvatar(u, theme),
                   const SizedBox(width: 12),
                   Text(u.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: theme.primaryColor.withValues(alpha:0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Text(r.rating.toStringAsFixed(1), style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 4),
                    Icon(Icons.star, color: theme.primaryColor, size: 10),
                  ],
                ),
              ),
            ],
          ),
          if (r.comment != null && r.comment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(r.comment!, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.8), fontSize: 14)),
          ]
        ],
      ),
    );
  }

  Widget _buildStickyBottomButton(ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [theme.scaffoldBackgroundColor, theme.scaffoldBackgroundColor.withValues(alpha:0)],
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () => _showReviewDialog(theme), // Linked to Review Dialog
          icon: Icon(Icons.rate_review, color: theme.colorScheme.onPrimary),
          label: Text(AppLocalizations.of(context)!.reviewGame, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 8,
            shadowColor: theme.primaryColor.withValues(alpha:0.4),
          ),
        ),
      ),
    );
  }

  Future<void> _showReviewDialog(ThemeData theme) async {
    final userSession = context.read<UserSession>();
    if (userSession.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to review')));
      return;
    }

    final commentController = TextEditingController();
    double currentRating = 5.0;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardTheme.color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.reviewGame, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.rateThisGame, style: TextStyle(color: mutedColor)),
              Slider(
                value: currentRating,
                min: 1, max: 5, divisions: 4,
                label: currentRating.toString(),
                activeColor: theme.primaryColor,
                onChanged: (v) => setModalState(() => currentRating = v),
              ),
              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                    Text(currentRating.toInt().toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                    Icon(Icons.star, color: theme.primaryColor, size: 24),
                 ]
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.reviewHint,
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5)),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
                  onPressed: () async {
                    Navigator.pop(context);
                    await _submitReview(currentRating, commentController.text, userSession.currentUser!.id);
                  },
                  child: Text(AppLocalizations.of(context)!.submitReview, style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(User user, ThemeData theme) {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: theme.primaryColor,
        backgroundImage: NetworkImage(user.avatarUrl!),
        onBackgroundImageError: (exception, stackTrace) {
           debugPrint('Avatar Load Error: $exception');
        },
        child: null, 
      );
    }
    
    return CircleAvatar(
      radius: 16,
      backgroundColor: theme.primaryColor,
      child: Text(
        user.username[0].toUpperCase(),
        style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12),
      ),
    );
  }
}

