import 'package:flutter/material.dart' hide Notification;
import 'package:provider/provider.dart';
import '../services/gamification_service.dart';
import '../services/supabase_realtime_service.dart';
import '../services/supabase_sync_service.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../providers/user_session.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    // Listen to Realtime updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupabaseRealtimeService>().addListener(_onRealtimeUpdate);
    });
  }

  void _onRealtimeUpdate() {
    if (mounted) {
      // Capture context synchronously before any async gap
      try {
        _loadNotifications();
      } catch (_) {
        // Widget may have been disposed between mounted check and read
      }
    }
  }

  @override
  void dispose() {
    context.read<SupabaseRealtimeService>().removeListener(_onRealtimeUpdate);
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;
    // Capture all context-dependent references BEFORE any await
    final userSession = context.read<UserSession>();
    final notificationsDao = context.read<NotificationsDao>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;

    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final list = await notificationsDao.getNotifications(currentUser.id);

    if (mounted) {
      setState(() {
        _notifications = list;
        _isLoading = false;
      });
    }
  }
  
  Future<void> _markAsRead(Notification notification) async {
    if (notification.isRead) return;
    
    final notificationsDao = context.read<NotificationsDao>();
    await notificationsDao.markAsRead(notification.id);
    
    // Process sync queue immediately
    context.read<SupabaseSyncService>().pushChanges();
    
    _loadNotifications();
  }

  Future<void> _markAllRead() async {
     final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    if (currentUser == null) return;
    
    final notificationsDao = context.read<NotificationsDao>();
    await notificationsDao.markAllAsRead(currentUser.id);

    // Process sync queue immediately
    context.read<SupabaseSyncService>().pushChanges();

    _loadNotifications();
  }

  Future<void> _handleFriendRequest(Notification notification, bool accept) async {
    final userSession = context.read<UserSession>();
    final currentUser = userSession.currentUser;
    if (currentUser == null || notification.relatedId == null) return;

    final syncService = context.read<SupabaseSyncService>(); 
    final gamificationService = context.read<GamificationService>(); 
    
    setState(() => _isLoading = true);
    
    try {
      final friendshipId = notification.relatedId!;

      final error = await syncService.respondToFriendRequest(friendshipId, accept);

      if (error == null) {
        
        // Gamification Hook: +10 XP
        if (mounted) {
          await gamificationService.addXp(currentUser.id, 10);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(accept ? 'Friend request accepted! (+10 XP)' : 'Friend request rejected'),
              backgroundColor: accept ? Colors.green : Colors.orange,
            )
          );
        }
        await _markAsRead(notification);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red)
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process request. Please try again.'))
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getLocalizedTitle(Notification notification, AppLocalizations l10n) {
    if (notification.type == 'system') {
      final title = notification.title.toUpperCase();
      if (title.contains('LEVEL UP')) return l10n.notifLevelUpTitle;
      if (title.contains('ACHIEVEMENT')) return l10n.notifAchievementTitle;
      if (title.contains('PRESTIGE')) return l10n.notifPrestigeTitle;
    }
    if (notification.type == 'friend_request') return l10n.notifFriendRequestTitle;
    if (notification.type == 'match_result') {
      final title = notification.title.toLowerCase();
      bool isDefeat = title.contains('failed') || 
                      title.contains('defeat') ||
                      title.contains('lost');
      return isDefeat ? l10n.notifMatchDefeatTitle : l10n.notifMatchVictoryTitle;
    }
    return notification.title;
  }

  String _getLocalizedMessage(Notification notification, AppLocalizations l10n) {
    final title = notification.title.toUpperCase();
    if (notification.type == 'system') {
      if (title.contains('LEVEL UP')) {
        final reg = RegExp(r'Level (\d+): (.+)!', caseSensitive: false);
        final match = reg.firstMatch(notification.message);
        if (match != null) {
          return l10n.notifLevelUpMsg(match.group(1)!, match.group(2)!);
        }
      }
      if (title.contains('ACHIEVEMENT')) {
        final reg = RegExp(r'You unlocked: (.+)', caseSensitive: false);
        final match = reg.firstMatch(notification.message);
        if (match != null) {
          return l10n.notifAchievementMsg(match.group(1)!);
        }
      }
      if (title.contains('PRESTIGE')) return l10n.notifPrestigeMsg;
    }
    if (notification.type == 'friend_request') {
      final reg1 = RegExp(r'(.+) wants to be your friend!', caseSensitive: false);
      final match1 = reg1.firstMatch(notification.message);
      if (match1 != null) {
        return l10n.notifFriendRequestMsg(match1.group(1)!.trim());
      }
      final reg2 = RegExp(r'(.+) sent you a friend request.', caseSensitive: false);
      final match2 = reg2.firstMatch(notification.message);
      if (match2 != null) {
        return l10n.notifFriendRequestMsg(match2.group(1)!.trim());
      }
    }
    if (notification.type == 'match_result') {
      final titleLower = notification.title.toLowerCase();
      bool isDefeat = titleLower.contains('failed') || 
                      titleLower.contains('defeat') ||
                      titleLower.contains('lost');
      return isDefeat ? l10n.notifMatchDefeatMsg : l10n.notifMatchVictoryMsg;
    }
    return notification.message;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.notifications, style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: _markAllRead,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : _notifications.isEmpty
              ? _buildEmptyState(mutedColor, l10n)
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationItem(_notifications[index], theme, mutedColor, l10n);
                  },
                ),
    );
  }

  Widget _buildEmptyState(Color mutedColor, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: mutedColor.withValues(alpha:0.5)),
          const SizedBox(height: 16),
          Text(l10n.noNotifications, style: TextStyle(color: mutedColor, fontSize: 18)),
        ],
      ),
    );
  }

  void _showNotificationDialog(Notification notification, ThemeData theme, AppLocalizations l10n) {
    IconData icon;
    Color color;
    String headerText = 'NOTIFICATION';

    final localizedTitle = _getLocalizedTitle(notification, l10n);
    final localizedMessage = _getLocalizedMessage(notification, l10n);

    bool isDefeat = notification.title.toLowerCase().contains('failed') || 
                    notification.title.toLowerCase().contains('defeat') ||
                    notification.title.toLowerCase().contains('lost');

    switch (notification.type) {
      case 'friend_request':
        icon = Icons.person_add;
        color = Colors.blueAccent;
        headerText = 'NEW FRIEND';
        break;
      case 'match_result':
        if (isDefeat) {
           icon = Icons.sentiment_very_dissatisfied; 
           color = Colors.redAccent;
           headerText = 'DEFEAT';
        } else {
           icon = Icons.emoji_events;
           color = Colors.amber;
           headerText = 'VICTORY!';
        }
        break;
      default:
        icon = Icons.info_outline;
        color = theme.primaryColor;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            boxShadow: [
               BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20, offset: const Offset(0, 10))
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               // Header with Icon
               Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                     color: color.withValues(alpha: 0.1),
                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                       Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                             color: theme.cardTheme.color,
                             shape: BoxShape.circle,
                             border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
                             boxShadow: [
                                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12)
                             ]
                          ),
                          child: Icon(icon, size: 32, color: color),
                       ),
                       const SizedBox(height: 12),
                       Text(
                          headerText, 
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)
                       )
                    ],
                  ),
               ),
               
               // Content
               Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                     children: [
                        Text(
                           localizedTitle,
                           textAlign: TextAlign.center,
                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(height: 12),
                        Text(
                           localizedMessage,
                           textAlign: TextAlign.center,
                           style: TextStyle(fontSize: 14, height: 1.5, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 24),
                        Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                        const SizedBox(height: 8),
                         Text(
                            DateFormat('MMMM d, y • h:mm a').format(notification.createdAt),
                            style: TextStyle(color: theme.inputDecorationTheme.hintStyle?.color?.withValues(alpha: 0.5), fontSize: 11),
                         ),
                     ],
                  ),
               ),
               
               // Actions
               Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                     width: double.infinity,
                     child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                           backgroundColor: theme.colorScheme.surface,
                           foregroundColor: theme.colorScheme.onSurface,
                           elevation: 0,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                           padding: const EdgeInsets.symmetric(vertical: 16)
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                     ),
                  ),
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Notification notification, ThemeData theme, Color mutedColor, AppLocalizations l10n) {
    IconData icon;
    Color color;

    final localizedTitle = _getLocalizedTitle(notification, l10n);
    final localizedMessage = _getLocalizedMessage(notification, l10n);

    bool isDefeat = notification.title.toLowerCase().contains('failed') || 
                    notification.title.toLowerCase().contains('defeat') ||
                    notification.title.toLowerCase().contains('lost');

    switch (notification.type) {
      case 'friend_request':
        icon = Icons.person_add;
        color = Colors.blueAccent;
        break;
      case 'match_result':
        if (isDefeat) {
            icon = Icons.sentiment_very_dissatisfied;
            color = Colors.redAccent;
        } else {
            icon = Icons.emoji_events;
            color = Colors.amber; // Golden Trophy
        }
        break;
      default:
        icon = Icons.info_outline;
        color = mutedColor;
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        // Implement delete if needed, for now just hide
      },
      child: Container(
        color: notification.isRead ? Colors.transparent : theme.colorScheme.surface.withValues(alpha: 0.3),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            localizedTitle,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                localizedMessage,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: notification.isRead ? mutedColor : theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat.yMMMd().add_jm().format(notification.createdAt),
                style: TextStyle(color: mutedColor, fontSize: 10),
              ),
              if (notification.type == 'friend_request' && !notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleFriendRequest(notification, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('Accept'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _handleFriendRequest(notification, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          onTap: () async {
            await _markAsRead(notification);
            if (!context.mounted) return;
            _showNotificationDialog(notification, theme, l10n);
          },
        ),
      ),
    );
  }
}
