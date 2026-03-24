import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_session.dart';
import '../services/supabase_sync_service.dart';
import 'login_screen.dart';

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
    
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Wait for animation + minimum time
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    final userSession = context.read<UserSession>();
    
    // Check if we have a persisted session or auto-login logic
    // Usually Supabase handles this via auth state change, but UserSession might need init.
    // For now, we just navigate to LoginScreen which handles "Already Logged In" check or shows Login UI.
    // Ideally, LoginScreen's check should be here to skip LoginScreen UI flash.
    
    // Let's assume LoginScreen handles it or we check session:
    // final session = supabase.auth.currentSession;
    // if (session != null) ...
    
    // Navigate
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
            Container(
               width: 120,
               height: 120,
               decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                     BoxShadow(
                        color: theme.primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5
                     )
                  ]
               ),
               child: const Icon(Icons.casino, size: 64, color: Colors.white), // Placeholder BoardGame Icon
            ),
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
                    'Board Game Hub',
                    style: TextStyle(
                       fontSize: 24, 
                       fontWeight: FontWeight.bold,
                       color: theme.colorScheme.onSurface,
                       letterSpacing: 1.2
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
