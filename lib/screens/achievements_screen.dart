import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/gamification_service.dart';
import '../database/database.dart';
import 'package:intl/intl.dart';

class AchievementsScreen extends StatelessWidget {
  final int userId;
  final bool isMyProfile;
  
  const AchievementsScreen({super.key, required this.userId, this.isMyProfile = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievementsDao = context.read<UserAchievementsDao>();
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: FutureBuilder<List<UserAchievement>>(
        future: achievementsDao.getAchievements(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final unlocked = snapshot.data!;
          final unlockedIds = unlocked.map((a) => a.achievementId).toSet();
          final all = GamificationService.allAchievements;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: all.length,
            itemBuilder: (context, index) {
              final achievement = all[index];
              final isUnlocked = unlockedIds.contains(achievement.id);
              final unlockDate = isUnlocked 
                  ? unlocked.firstWhere((a) => a.achievementId == achievement.id).unlockedAt 
                  : null;

              return GestureDetector(
                onTap: () {
                   _showDetails(context, achievement, isUnlocked, unlockDate, theme);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                       color: isUnlocked ? theme.primaryColor.withOpacity(0.5) : theme.colorScheme.onSurface.withOpacity(0.1),
                       width: isUnlocked ? 2 : 1
                    ),
                    boxShadow: isUnlocked ? [
                       BoxShadow(color: theme.primaryColor.withOpacity(0.2), blurRadius: 8, spreadRadius: 0)
                    ] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Opacity(
                         opacity: isUnlocked ? 1.0 : 0.3,
                         child: Text(achievement.icon, style: const TextStyle(fontSize: 40)),
                       ),
                       const SizedBox(height: 12),
                       Text(
                         achievement.title,
                         textAlign: TextAlign.center,
                         style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.5)
                         ),
                       ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetails(BuildContext context, AchievementDefinition achievement, bool isUnlocked, DateTime? date, ThemeData theme) {
     final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
     showDialog(
       context: context,
       builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                 color: theme.scaffoldBackgroundColor,
                 borderRadius: BorderRadius.circular(24),
                 border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
              ),
              child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                    Container(
                       padding: const EdgeInsets.all(24),
                       decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isUnlocked ? theme.primaryColor : Colors.grey).withOpacity(0.1),
                       ),
                       child: Text(achievement.icon, style: const TextStyle(fontSize: 64)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                       achievement.title,
                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                       isUnlocked ? 'Unlocked' : 'Locked',
                       style: TextStyle(
                          color: isUnlocked ? theme.primaryColor : mutedColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                       ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                       achievement.description,
                       textAlign: TextAlign.center,
                       style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    if (isUnlocked && date != null) ...[
                       const SizedBox(height: 24),
                       Text(
                          'Unlocked on ${DateFormat.yMMMd().format(date)}',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                       ),
                    ],
                    const SizedBox(height: 32),
                    ElevatedButton(
                       onPressed: () => Navigator.pop(context),
                       style: ElevatedButton.styleFrom(
                          backgroundColor: theme.cardTheme.color,
                          foregroundColor: theme.colorScheme.onSurface,
                       ),
                       child: const Text('Close'),
                    )
                 ],
              ),
          ),
       ),
     );
  }
}
