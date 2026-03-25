import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../providers/user_session.dart';
import 'game_details.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Game> _wishlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;

    final collectionsDao = context.read<UserGameCollectionsDao>();
    final games = await collectionsDao.getWishlist(currentUser.id);

    if (mounted) {
      setState(() {
        _wishlist = games;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromWishlist(Game game) async {
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;

    final collectionsDao = context.read<UserGameCollectionsDao>();
    await collectionsDao.removeFromCollection(currentUser.id, game.id, 'wishlist');
    
    _loadWishlist(); // Reload list
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.removedFromWishlist(game.name))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myWishlistTitle, style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : _wishlist.isEmpty
              ? _buildEmptyState(context, mutedColor)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _wishlist.length,
                  itemBuilder: (context, index) {
                    final game = _wishlist[index];
                    return _buildGameCard(game, theme, mutedColor);
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color mutedColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: mutedColor.withValues(alpha:0.5)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.emptyWishlist,
            style: TextStyle(color: mutedColor, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.exploreToAddToWishlist,
            style: TextStyle(color: mutedColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(Game game, ThemeData theme, Color mutedColor) {
    return Card(
      color: theme.cardTheme.color,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameDetails(game: game)),
          ).then((_) => _loadWishlist()); // Refresh on return
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  game.imageUrl ?? 'https://via.placeholder.com/60',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 60, height: 60, color: theme.colorScheme.surface, child: Icon(Icons.broken_image, color: mutedColor)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: theme.primaryColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          game.rating?.toStringAsFixed(1) ?? 'N/A',
                          style: TextStyle(color: mutedColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _removeFromWishlist(game),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
