import 'package:drift/drift.dart';
import '../database/database.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

/// Service to handle gamification logic (XP, Levels, Achievements)
class GamificationService {
  final AppDatabase db;

  GamificationService(this.db);

  // --- Definitions ---

  static final List<AchievementDefinition> allAchievements = [
    // Ranks (Generated)
    ...List.generate(maxLevel, (index) {
       final lvl = index + 1;
       return AchievementDefinition(
         id: 'rank_$lvl',
         title: _getRankTitle(lvl),
         description: 'Reach Level $lvl',
         icon: _getRankIcon(lvl),
         xpReward: 0, 
       );
    }),
    
    const AchievementDefinition(
      id: 'first_match',
      title: 'First Steps',
      description: 'Record your first match result.',
      icon: '🎲',
      xpReward: 100,
    ),
    const AchievementDefinition(
      id: 'first_win',
      title: 'Champion',
      description: 'Win your first competitive match.',
      icon: '🏆',
      xpReward: 200,
    ),
    const AchievementDefinition(
      id: 'veteran_10',
      title: 'Veteran',
      description: 'Play 100 matches.',
      icon: '⚔️',
      xpReward: 1000,
    ),
    const AchievementDefinition(
      id: 'social_butterfly',
      title: 'Social Butterfly',
      description: 'Add 5 friends.',
      icon: '🦋',
      xpReward: 300,
    ),
  ];
  
  static String _getRankTitle(int level) {
    if (level == 0) return 'Unranked';
    if (level <= 10) return _getTierTitle(level, 'Casual', ['Dice Roller', 'Card Shuffler', 'Gateway Explorer', 'Meeple Mover']);
    if (level <= 20) return _getTierTitle(level, 'Hobbyist', ['Rulebook Reader', 'Box Organizer', 'Insert Planner', 'Sleeve Master']);
    if (level <= 30) return _getTierTitle(level, 'Strategist', ['Alpha Gamer', 'Analysis Paralysis', 'Combo Breaker', 'Min-Maxer']);
    if (level <= 40) return _getTierTitle(level, 'Collector', ['Kickstarter Backer', 'Shelf of Shame Owner', 'Miniature Painter', 'Completionist']);
    return _getTierTitle(level, 'Legend', ['The Designer', 'The Publisher', 'The Reviewer', 'The Meeple Incarnate']);
  }
  
  static String _getTierTitle(int level, String tierName, List<String> subtitles) {
      final index = (level - 1) % 10; 
      if (index == 0) return '$tierName (I)'; 
      if (index == 9) return '$tierName Master'; 
      if (index < subtitles.length) return '$tierName: ${subtitles[index]}';
      return '$tierName ${index + 1}';
  }
  
  static String _getRankIcon(int level) {
     if (level == 0) return '🥚';
     if (level <= 10) return '🎲'; 
     if (level <= 20) return '🧠'; 
     if (level <= 30) return '♟️'; 
     if (level <= 40) return '📚'; 
     return '👑'; 
  }
  
  // -- PRESTIGE --
  
  Future<void> prestigeUser(String userId) async {
    final user = await db.usersDao.getUserById(userId);
    if (user == null) return;
    
    // Check Requirement (Lvl 50)
    if (getLevel(user.xp) < maxLevel) return;
    
    // Reset XP, Increment Prestige
    final newPrestige = (user.prestige) + 1;
    await db.usersDao.updateUser(userId, UsersCompanion(
       xp: const Value(0),
       prestige: Value(newPrestige),
    ));
    
    await db.notificationsDao.createNotification(
       userId: userId,
       type: 'system',
       title: 'PRESTIGE UNLOCKED! ⭐',
       message: 'You have ascended! Your level is reset, but your glory grows.',
    );
  }

  // --- Logic ---

  /// Calculate level based on XP. Formula: Level = sqrt(XP / 100)
  /// Example:
  /// Level 1: 100 XP
  /// Level 2: 400 XP
  // -- XP CURVE LOGIC --
  
  static const int maxLevel = 50;
  static const double growthFactor = 1.38;
  static const int baseXp = 1000;

  /// Returns the TOTAL XP required to reach the given [level].
  static int getXpRequiredForLevel(int level) {
    if (level <= 0) return 0;
    if (level == 1) return 100;
    
    double total = 100;
    double currentDelta = baseXp.toDouble();
    
    for (int i = 2; i <= level; i++) {
       total += currentDelta;
       currentDelta *= growthFactor;
    }
    
    return total.floor();
  }

  static int getLevel(int xp) {
    if (xp < getXpRequiredForLevel(1)) return 0;
    
    for (int i = 1; i < maxLevel; i++) {
       if (xp < getXpRequiredForLevel(i + 1)) {
         return i;
       }
    }
    return maxLevel;
  }

  static double getProgressToNextLevel(int xp) {
    final currentLevel = getLevel(xp);
    if (currentLevel >= maxLevel) return 1.0;
    
    final startXp = getXpRequiredForLevel(currentLevel);
    final endXp = getXpRequiredForLevel(currentLevel + 1);
    
    return (xp - startXp) / (endXp - startXp);
  }

  /// Adds XP to user and returns the new total XP
  Future<int> addXp(String userId, int amount) async {
    final user = await db.usersDao.getUserById(userId);
    if (user == null) return 0;

    final oldLevel = getLevel(user.xp);
    final newXp = (user.xp ) + amount;
    final newLevel = getLevel(newXp);
    
    // Update user
    await db.usersDao.updateUser(userId, UsersCompanion(xp: Value(newXp)));
    
    // Check Level Up
    if (newLevel > oldLevel) {
       // Unlock Rank Achievement
       final rankId = 'rank_$newLevel'; 
       await db.userAchievementsDao.unlockAchievement(userId, rankId);
       
       await db.notificationsDao.createNotification(
          userId: userId,
          type: 'system',
          title: 'LEVEL UP! ⬆️', // Changed title
          message: 'You reached Level $newLevel: ${_getRankTitle(newLevel)}!',
       );
    }
    
    return newXp;
  }

  /// Checks for achievements based on triggers
  /// Returns list of newly unlocked achievements
  Future<List<AchievementDefinition>> checkAchievements(String userId, {bool isRestore = false}) async {
    List<AchievementDefinition> newlyUnlocked = [];

    // existing unlocked
    final unlockedIds = (await db.userAchievementsDao.getAchievements(userId))
        .map((a) => a.achievementId)
        .toSet();

    // Get stats
    final user = await db.usersDao.getUserById(userId);
    if (user == null) return newlyUnlocked;

    final stats = await db.matchesDao.getUserStats(userId);
    final matchCount = stats['matches'] as int;
    final winCount = stats['wins'] as int;
    final friendCount = await db.friendshipsDao.getFriendCount(userId);

    // Retroactively check for skipped Level/Rank achievements
    final currentLevel = getLevel(user.xp);
    for (int i = 1; i <= currentLevel; i++) {
       final rId = 'rank_$i';
       if (!unlockedIds.contains(rId)) {
          newlyUnlocked.add(getDefinition(rId));
       }
    }

    // Check Logic
    if (!unlockedIds.contains('first_match') && matchCount >= 1) {
      newlyUnlocked.add(getDefinition('first_match'));
    }
    
    if (!unlockedIds.contains('first_win') && winCount >= 1) {
       newlyUnlocked.add(getDefinition('first_win'));
    }
    
    if (!unlockedIds.contains('veteran_10') && matchCount >= 100) {
      newlyUnlocked.add(getDefinition('veteran_10'));
    }

    if (!unlockedIds.contains('social_butterfly') && friendCount >= 5) {
      newlyUnlocked.add(getDefinition('social_butterfly'));
    }

    // Unlock them in DB and award XP
    for (var achievement in newlyUnlocked) {
      await db.userAchievementsDao.unlockAchievement(userId, achievement.id);
      
      if (!isRestore) {
         await addXp(userId, achievement.xpReward);
         
         // Notify (Create system notification)
         await db.notificationsDao.createNotification(
           userId: userId,
           type: 'system',
           title: 'Achievement Unlocked!',
           message: 'You unlocked: ${achievement.title}',
         );
      }
    }
    
    return newlyUnlocked;
  }

  AchievementDefinition getDefinition(String id) {
    return allAchievements.firstWhere((a) => a.id == id, orElse: () => 
      const AchievementDefinition(id: 'unknown', title: 'Unknown', description: '?', icon: '?', xpReward: 0));
  }
}

class AchievementDefinition {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int xpReward;

  const AchievementDefinition({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.icon,
    this.xpReward = 0,
  });
}

class GamificationLocalizer {
  static String getAchievementTitle(AppLocalizations l10n, String id) {
     if (id.startsWith('rank_')) {
        int lvl = int.parse(id.split('_')[1]);
        switch(lvl) {
          case 0: return l10n.lvl0Title;
          case 1: return l10n.lvl1Title;
          case 2: return l10n.lvl2Title;
          case 3: return l10n.lvl3Title;
          case 4: return l10n.lvl4Title;
          case 5: return l10n.lvl5Title;
          case 6: return l10n.lvl6Title;
          case 7: return l10n.lvl7Title;
          case 8: return l10n.lvl8Title;
          case 9: return l10n.lvl9Title;
          case 10: return l10n.lvl10Title;
          case 11: return l10n.lvl11Title;
          case 12: return l10n.lvl12Title;
          case 13: return l10n.lvl13Title;
          case 14: return l10n.lvl14Title;
          case 15: return l10n.lvl15Title;
          case 16: return l10n.lvl16Title;
          case 17: return l10n.lvl17Title;
          case 18: return l10n.lvl18Title;
          case 19: return l10n.lvl19Title;
          case 20: return l10n.lvl20Title;
          case 21: return l10n.lvl21Title;
          case 22: return l10n.lvl22Title;
          case 23: return l10n.lvl23Title;
          case 24: return l10n.lvl24Title;
          case 25: return l10n.lvl25Title;
          case 26: return l10n.lvl26Title;
          case 27: return l10n.lvl27Title;
          case 28: return l10n.lvl28Title;
          case 29: return l10n.lvl29Title;
          case 30: return l10n.lvl30Title;
          case 31: return l10n.lvl31Title;
          case 32: return l10n.lvl32Title;
          case 33: return l10n.lvl33Title;
          case 34: return l10n.lvl34Title;
          case 35: return l10n.lvl35Title;
          case 36: return l10n.lvl36Title;
          case 37: return l10n.lvl37Title;
          case 38: return l10n.lvl38Title;
          case 39: return l10n.lvl39Title;
          case 40: return l10n.lvl40Title;
          case 41: return l10n.lvl41Title;
          case 42: return l10n.lvl42Title;
          case 43: return l10n.lvl43Title;
          case 44: return l10n.lvl44Title;
          case 45: return l10n.lvl45Title;
          case 46: return l10n.lvl46Title;
          case 47: return l10n.lvl47Title;
          case 48: return l10n.lvl48Title;
          case 49: return l10n.lvl49Title;
          case 50: return l10n.lvl50Title;
          default: return 'Lvl $lvl';
        }
     }
     switch(id) {
       case 'first_match': return l10n.achFirstMatchTitle;
       case 'first_win': return l10n.achFirstWinTitle;
       case 'veteran_10': return l10n.achVeteranTitle;
       case 'social_butterfly': return l10n.achSocialTitle;
       default: return 'Unknown';
     }
  }

  static String getAchievementDesc(AppLocalizations l10n, String id) {
     if (id.startsWith('rank_')) {
        int lvl = int.parse(id.split('_')[1]);
        return l10n.rankReachLevel(lvl.toString());
     }
     switch(id) {
       case 'first_match': return l10n.achFirstMatchDesc;
       case 'first_win': return l10n.achFirstWinDesc;
       case 'veteran_10': return l10n.achVeteranDesc;
       case 'social_butterfly': return l10n.achSocialDesc;
       default: return '?';
     }
  }
}
