import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'database/sample_data.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'providers/user_session.dart';
import 'services/bgg_service.dart';
import 'services/gamification_service.dart';

import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = AppDatabase();
  await SampleData.insertSampleData(database);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<UsersDao>(create: (_) => database.usersDao),
        Provider<GamesDao>(create: (_) => database.gamesDao),
        Provider<MatchesDao>(create: (_) => database.matchesDao),
        Provider<UserGameCollectionsDao>(create: (_) => database.userGameCollectionsDao),
        Provider<FriendshipsDao>(create: (_) => database.friendshipsDao),
        Provider<NotificationsDao>(create: (_) => database.notificationsDao),
        Provider<ReviewsDao>(create: (_) => database.reviewsDao),
        Provider<UserAchievementsDao>(create: (_) => database.userAchievementsDao),
        Provider<GamificationService>(create: (_) => GamificationService(database)),
        Provider<BggService>(create: (_) => BggService()),
        ChangeNotifierProvider<UserSession>(create: (_) => UserSession()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MeepleSync',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
