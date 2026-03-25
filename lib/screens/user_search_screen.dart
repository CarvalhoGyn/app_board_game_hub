import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../providers/user_session.dart';
import '../services/supabase_sync_service.dart';
import 'profile_dashboard.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final syncService = context.read<SupabaseSyncService>();
    final results = await syncService.searchGlobalUsers(query);
    setState(() {
      _searchResults = results;
    });
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

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserSession>().currentUser;
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Find Friends', style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search by nickname...',
                hintStyle: TextStyle(color: mutedColor),
                prefixIcon: Icon(Icons.search, color: mutedColor),
                filled: true,
                fillColor: theme.cardTheme.color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                if (user.id == currentUser?.id) return const SizedBox.shrink();

                final imageProvider = _getAvatarImage(user.avatarUrl);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: imageProvider,
                    backgroundColor: theme.colorScheme.surface,
                    onBackgroundImageError: imageProvider != null ? (e, s) => debugPrint('Search Avatar Error: $e') : null,
                    child: imageProvider == null ? Text(
                       user.username.length > 1 ? user.username.substring(0, 2).toUpperCase() : user.username.toUpperCase(), 
                       style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)
                    ) : null,
                  ),
                  title: Text(user.username, style: TextStyle(color: theme.colorScheme.onSurface)),
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDashboard(userId: user.id)));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
