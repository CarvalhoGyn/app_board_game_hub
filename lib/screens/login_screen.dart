import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'registration_screen.dart';
import 'game_catalog.dart';
import '../providers/user_session.dart';
import 'package:drift/drift.dart' as drift;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import '../widgets/language_selector.dart';

import '../services/supabase_sync_service.dart';
import '../services/supabase_realtime_service.dart';

// ...

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onBackground = theme.colorScheme.onSurface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Assuming this exists, or fallback to gradient
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [const Color(0xFF1E2229), const Color(0xFF13161C)]
                          : [const Color(0xFFF5F7FA), const Color(0xFFE4E9F2)],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              color: theme.colorScheme.surface.withOpacity(isDark ? 0.85 : 0.9),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Top Section
                        Column(
                          children: [
                            const SizedBox(height: 60), // Increased spacing for language selector
                            // App Logo
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  'assets/icon/app_icon.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: theme.primaryColor,
                                      child: const Icon(Icons.casino, color: Colors.white, size: 64),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              l10n.loginTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: onBackground,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Form Section
                        Column(
                          children: [
                            _buildTextField(
                              controller: _emailController,
                              hintText: l10n.usernameLabel,
                              icon: Icons.person_outline,
                              theme: theme,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              theme: theme,
                              onToggleVisibility: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildLoginButton(
                              text: l10n.loginButton,
                              theme: theme,
                              onPressed: () async {
                                final email = _emailController.text.trim();
                                final password = _passwordController.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please fill in all fields')),
                                  );
                                  return;
                                }

                                try {
                                  String loginEmail = email;
                                  
                                  // If input is not an email (username), look it up in Supabase profiles
                                  if (!email.contains('@')) {
                                     try {
                                       final userProfile = await supabase.Supabase.instance.client
                                          .from('profiles')
                                          .select('email')
                                          .eq('username', email)
                                          .single();
                                       
                                       if (userProfile['email'] != null) {
                                          loginEmail = userProfile['email'];
                                          debugPrint('Resolved username $email to $loginEmail');
                                       }
                                     } catch (e) {
                                       // If lookup fails, let it proceed to fail at auth or handle specific error
                                       debugPrint('Username lookup failed: $e');
                                     }
                                  }

                                  // 1. Authenticate with Supabase
                                  final response = await supabase.Supabase.instance.client.auth.signInWithPassword(
                                    email: loginEmail,
                                    password: password,
                                  );

                                  final authUser = response.user;

                                  if (authUser == null) {
                                    throw Exception('Login failed: No user returned');
                                  }

                                  if (!mounted) return;
                                  
                                  // 2. Check Local DB
                                  final usersDao = context.read<UsersDao>();
                                  var localUser = await usersDao.getUserById(authUser.id);

                                  // 3. If not found locally (fresh install), fetch from Supabase Profiles
                                  if (localUser == null) {
                                    final profile = await supabase.Supabase.instance.client
                                        .from('profiles')
                                        .select()
                                        .eq('id', authUser.id)
                                        .single();
                                    
                                    // Insert into local DB
                                    await usersDao.createUser(UsersCompanion(
                                        id: drift.Value(profile['id']),
                                        username: drift.Value(profile['username'] ?? 'User'),
                                        email: drift.Value(profile['email'] ?? email),
                                        password: const drift.Value(''), // Auth is managed by Supabase, keep empty locally
                                        firstName: drift.Value(profile['first_name']),
                                        lastName: drift.Value(profile['last_name']),
                                        country: drift.Value(profile['country']),
                                        phone: drift.Value(profile['phone']),
                                        birthDate: drift.Value(profile['birth_date'] != null ? DateTime.parse(profile['birth_date']) : null),
                                        latitude: drift.Value(profile['latitude']),
                                        longitude: drift.Value(profile['longitude']),
                                        avatarUrl: drift.Value(profile['avatar_url']),
                                        xp: drift.Value(profile['xp'] ?? 0),
                                        prestige: drift.Value(profile['prestige'] ?? 0),
                                    ));
                                    
                                    localUser = await usersDao.getUserById(authUser.id);
                                  }

                                  if (!mounted) return;

                                  if (localUser != null) {
                                    final session = context.read<UserSession>();
                                    final syncService = context.read<SupabaseSyncService>();
                                    
                                    session.login(localUser);
                                    // Trigger background sync and Realtime
                                    syncService.sync();
                                    context.read<SupabaseRealtimeService>().subscribe(authUser.id);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const GameCatalog()),
                                    );
                                  } else {
                                     throw Exception('Failed to sync user profile');
                                  }
                                } on supabase.AuthException catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message), backgroundColor: Colors.red),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildSecondaryButton(
                              text: l10n.registerText,
                              theme: theme,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                                );
                              },
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Language Selector
          Positioned(
            top: 16,
            right: 24,
            child: SafeArea(
              child: const LanguageSelector(showLabel: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required ThemeData theme,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    // Rely on AppTheme's inputDecorationTheme for colors
    return TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.textMuted),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
    );
  }

  Widget _buildLoginButton({required String text, required ThemeData theme, VoidCallback? onPressed}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.4),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSecondaryButton({required String text, required ThemeData theme, VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2), width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}
