import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_session.dart';
import '../services/supabase_sync_service.dart';
import '../services/supabase_realtime_service.dart';
import 'login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../env/env.dart';
import '../database/database.dart';
import 'game_catalog.dart';
import '../services/subscription_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    // Animation Setup
    _controller = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 2000), 
    );
    
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.easeIn))
    );

    _controller.forward();
    
    // Ensure the very first frame paints BEFORE we trigger complex init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }
  
  Future<void> _initializeApp() async {
    // 1. Initialize heavy backend services here while animation plays
    try {
        await Supabase.initialize(
          url: Env.supabaseUrl,
          anonKey: Env.supabaseAnonKey,
        );
    } catch (e) {
        debugPrint('Splash: Supabase init error: $e');
    }

    // 2. Padding delay to let the animation show for at least 1-1.5 seconds smoothly
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;

    final userSession = context.read<UserSession>();
    
    // Check if we have a persisted session or auto-login logic
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
        try {
           final authUser = session.user;
           final usersDao = context.read<UsersDao>();
           var localUser = await usersDao.getUserById(authUser.id);
           
           if (localUser != null) {
              userSession.login(localUser);
              context.read<SupabaseSyncService>().sync();
              // Start Realtime subscription
              context.read<SupabaseRealtimeService>().subscribe(authUser.id);
              
              // RevenueCat Init
              final subService = context.read<SubscriptionService>();
              final syncService = context.read<SupabaseSyncService>();
              await subService.initialize(authUser.id);
              await subService.updateSubscriptionStatus(authUser.id, usersDao, userSession, syncService);
              
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const GameCatalog(),
                  transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                  transitionDuration: const Duration(milliseconds: 800),
                ),
              );
              return; 
           }
        } catch (e) {
           debugPrint('Auto-login failed: $e');
        }
    }
    
    if (!mounted) return;
    // Navigate to Login if session fails
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon removed as requested to keep a minimal beige layout
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacityAnimation.value, // Simple fade for text
                  child: child,
                );
              },
              child: Column(
                children: [
                   Text(
                    'MeepleSync',
                    style: TextStyle(
                       fontSize: 28, 
                       fontWeight: FontWeight.bold,
                       color: theme.colorScheme.onSurface,
                       letterSpacing: 2.0
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                     width: 150,
                     child: LinearProgressIndicator(
                        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                        color: theme.primaryColor,
                     ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                     'Preparando o tabuleiro...',
                     style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6)
                     ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
