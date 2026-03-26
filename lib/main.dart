import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import 'database/database.dart';

import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'providers/user_session.dart';
import 'services/gamification_service.dart';
import 'providers/theme_provider.dart';
import 'providers/localization_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env/env.dart';
import 'services/supabase_sync_service.dart';
import 'services/supabase_storage_service.dart';
import 'services/supabase_realtime_service.dart';
import 'services/subscription_service.dart';
import 'services/error_log_service.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  final database = AppDatabase();
  final errorLogService = ErrorLogService(Supabase.instance.client);

  // Captura erros de Widgets do Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogService.logError(
      message: details.exceptionAsString(),
      stackTrace: details.stack?.toString(),
    );
  };

  // Captura erros assíncronos fora da árvore de widgets
  PlatformDispatcher.instance.onError = (error, stack) {
    errorLogService.logError(
      message: error.toString(),
      stackTrace: stack.toString(),
    );
    return true;
  };

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
        Provider<SupabaseSyncService>(create: (_) => SupabaseSyncService(database)),
        Provider<SupabaseStorageService>(create: (_) => SupabaseStorageService()),
        ChangeNotifierProvider<SupabaseRealtimeService>(create: (_) => SupabaseRealtimeService(database)),
        ChangeNotifierProvider<UserSession>(create: (_) => UserSession()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<LocalizationProvider>(create: (_) => LocalizationProvider()),
        Provider<SubscriptionService>(create: (_) => SubscriptionService()),
        Provider<ErrorLogService>.value(value: errorLogService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocalizationProvider>(
      builder: (context, themeProvider, localizationProvider, child) {
        return MaterialApp(
          title: 'MeepleSync',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: localizationProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}
