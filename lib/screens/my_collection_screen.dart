import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../providers/user_session.dart';
import 'game_details.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({super.key});

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  List<Game> _collection = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  Future<void> _loadCollection() async {
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;

    final collectionsDao = context.read<UserGameCollectionsDao>();
    final games = await collectionsDao.getOwnedGames(currentUser.id);

    if (mounted) {
      setState(() {
        _collection = games;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromCollection(Game game) async {
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;

    final collectionsDao = context.read<UserGameCollectionsDao>();
    await collectionsDao.removeFromCollection(currentUser.id, game.id, 'owned');
    
    _loadCollection(); // Reload list
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.removedFromCollection(game.name))),
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
        title: Text(AppLocalizations.of(context)!.myCollection, style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : _collection.isEmpty
              ? _buildEmptyState(context, theme, mutedColor)
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _collection.length,
                  itemBuilder: (context, index) {
                    final game = _collection[index];
                    return _buildGameGridItem(game, theme, mutedColor);
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, Color mutedColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: mutedColor.withValues(alpha:0.5)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.emptyCollection,
            style: TextStyle(color: mutedColor, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.exploreToAddToCollection,
            style: TextStyle(color: mutedColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGridItem(Game game, ThemeData theme, Color mutedColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameDetails(game: game)),
        ).then((_) => _loadCollection()); // Refresh on return
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  game.imageUrl ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: theme.colorScheme.surface, child: Icon(Icons.broken_image, color: mutedColor)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: theme.primaryColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            game.rating?.toStringAsFixed(1) ?? 'N/A',
                            style: TextStyle(color: mutedColor, fontSize: 12),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _removeFromCollection(game),
                        child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
