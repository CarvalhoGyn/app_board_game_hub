import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'registration_screen.dart';
import 'game_catalog.dart';
import '../providers/user_session.dart';
import 'package:drift/drift.dart' as drift;

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

    return Scaffold(
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC00UCQ0swBzzjoQfZupN0p4ovLePNhAnKZl_Zx2TKPZneTEVeOnQrQP_CWri6q2Jk0Z18S02VQwoftH7-ra598v6YbU-6E3Sb1KM46ZqJbX72mlI3ebwdVb0M4MnTYXaIOVJCcYAnePzIeT2qcy7rEDWmUU6sog3kAn-8qjJSKGJPW4vUMLSwOJNG_6a_6iOxSO8KMAByshHtOhPx70qzuEHsAwjqGty55jUzsng6EV4_YUJJ2Qa1aW2vENN_9ZWNbutqFKPh4_A',
                  ),
                  fit: BoxFit.cover,
                  opacity: isDark ? 0.1 : 0.05,
                  colorFilter: isDark ? null : const ColorFilter.mode(Colors.grey, BlendMode.saturation), 
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.scaffoldBackgroundColor.withOpacity(0.8),
                    theme.scaffoldBackgroundColor.withOpacity(0.95),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Section
                    Column(
                      children: [
                        const SizedBox(height: 32),
                        // App Logo
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.4),
                                blurRadius: 40,
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
                          'Welcome Back, Player',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: onBackground,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ready for your next turn?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                          hintText: 'Email or Nickname',
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildLoginButton(
                          theme: theme, 
                          onPressed: () async {
                            final usersDao = context.read<UsersDao>();
                            final user = await usersDao.login(_emailController.text, _passwordController.text);
                            
                            if (user != null) {
                              if (!mounted) return;
                              context.read<UserSession>().login(user);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const GameCatalog()),
                              );
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid email/nickname or password'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                        }),
                        const SizedBox(height: 16),
                        _buildSecondaryButton(
                          text: 'Create New Account',
                          theme: theme,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildDivider(theme),
                        const SizedBox(height: 24),
                        _buildSocialLogins(theme),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Bottom Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New player?',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                            );
                          },
                          child: Text(
                            'Create an Account',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
      ],
    ));
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

  Widget _buildLoginButton({required ThemeData theme, VoidCallback? onPressed}) {
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
          'Log In',
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

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.casino, color: AppColors.textMuted, size: 14),
              const SizedBox(width: 8),
              const Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.casino, color: AppColors.textMuted, size: 14),
            ],
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildSocialLogins(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          theme: theme,
          icon: Icons.apple, 
          label: 'Apple',
          onTap: () => _handleSocialLogin('Apple'),
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          theme: theme,
          isGoogle: true, 
          onTap: () => _handleSocialLogin('Google'),
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          theme: theme,
          icon: Icons.facebook, 
          color: const Color(0xFF1877F2), 
          label: 'Facebook',
          onTap: () => _handleSocialLogin('Facebook'),
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          theme: theme,
          icon: Icons.close, // Using close icon to simulate X logo which is basically an X
          label: 'X',
          onTap: () => _handleSocialLogin('X'),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required ThemeData theme, IconData? icon, Color? color, bool isGoogle = false, String? label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: isGoogle
              ? Container(
                  height: 24,
                  width: 24,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: AppColors.surfaceDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : Icon(icon, color: color ?? theme.colorScheme.onSurface, size: 28),
        ),
      ),
    );
  }

  Future<void> _handleSocialLogin(String provider) async {
    // 1. Show Loading
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator())
    );

    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    if (!mounted) return;
    Navigator.pop(context); // Hide loading

    final usersDao = context.read<UsersDao>();
    
    // 2. Determine Fake User Details based on Provider
    final email = 'user_${provider.toLowerCase()}@example.com';
    final username = 'User${provider}';
    
    try {
       // 3. Try Login (Assuming password is 'social_login' for simplicty in this mock)
       // Note: In real app, we'd query by provider_id. Here we reuse login logic or create if fail.
       
       User? user = await usersDao.login(email, 'social_login');
       
       if (user == null) {
          // Create new social user
          final userId = await usersDao.createUser(
            UsersCompanion(
               username: drift.Value(username),
               email: drift.Value(email),
               password: const drift.Value('social_login'), // Mock pwd
               firstName: drift.Value(provider),
               lastName: const drift.Value('User'),
            ),
          );
          user = await usersDao.getUserById(userId);
       }
       
       if (user != null && mounted) {
           context.read<UserSession>().login(user);
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in with $provider!')));
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GameCatalog()),
           );
       }

    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Failed: $e')));
    }
  }
}
