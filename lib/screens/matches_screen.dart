import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'create_match.dart';
import '../widgets/shared_bottom_nav.dart';
import 'record_match_score.dart';
import '../providers/user_session.dart';
import '../services/supabase_realtime_service.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<MatchWithDetails> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
    // Listen to Realtime updates (e.g. new match invitations)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupabaseRealtimeService>().addListener(_onRealtimeUpdate);
    });
  }

  @override
  void dispose() {
    context.read<SupabaseRealtimeService>().removeListener(_onRealtimeUpdate);
    super.dispose();
  }

  void _onRealtimeUpdate() {
    if (mounted) _loadMatches();
  }

  Future<void> _loadMatches() async {
    final matchesDao = context.read<MatchesDao>();
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    
    if (currentUser == null) return;

    final matches = await matchesDao.getMatchesForUser(currentUser.id);
    if (mounted) {
      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Partidas', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _matches.isEmpty 
           ? _buildEmptyState(theme)
           : ListView.builder(
               padding: const EdgeInsets.all(16),
               itemCount: _matches.length,
               itemBuilder: (context, index) {
                 return _buildMatchItem(_matches[index], theme);
               },
             ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateMatch())).then((_) => _loadMatches());
        },
        backgroundColor: theme.primaryColor, // Match the requested theme
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 2),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_esports, size: 64, color: mutedColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('Nenhuma partida registrada', style: TextStyle(color: mutedColor, fontSize: 16)),
          const SizedBox(height: 8),
          TextButton(
             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateMatch())).then((_) => _loadMatches()),
             child: Text('Registrar Primeira Partida', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchItem(MatchWithDetails matchData, ThemeData theme) {
     final match = matchData.match;
     final game = matchData.game;
     final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
     
     return GestureDetector(
        onTap: () {
           // View details or results
           Navigator.push(context, MaterialPageRoute(builder: (context) => RecordMatchScore(matchId: match.id)));
        },
        child: Container(
           margin: const EdgeInsets.only(bottom: 12),
           padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
           ),
           child: Row(
              children: [
                 ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                       game.imageUrl ?? '',
                       width: 60, height: 60, fit: BoxFit.cover,
                       errorBuilder: (_,__,___) => Container(width: 60, height: 60, color: theme.colorScheme.surface),
                    ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          Text(game.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
                          const SizedBox(height: 4),
                          Text(
                             '${match.date.day}/${match.date.month}/${match.date.year} • ${match.scoringType == 'cooperative' ? 'Co-op' : 'Competitive'}',
                             style: TextStyle(color: mutedColor, fontSize: 12),
                          ),
                       ],
                    ),
                 ),
                 Icon(Icons.chevron_right, color: mutedColor),
              ],
           ),
        ),
     );
  }
}
