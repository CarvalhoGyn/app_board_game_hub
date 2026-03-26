import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../providers/user_session.dart';
import 'game_details.dart';
import '../widgets/game_card_grid.dart';
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
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: _wishlist.length,
                  itemBuilder: (context, index) {
                    final game = _wishlist[index];
                    return GameCardGrid(
                      game: game,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameDetails(game: game)),
                        ).then((_) => _loadWishlist());
                      },
                      onDelete: () => _removeFromWishlist(game),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color mutedColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: mutedColor.withOpacity(0.5)),
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
}
