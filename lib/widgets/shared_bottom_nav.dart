import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../screens/game_catalog.dart';
import '../screens/explore_screen.dart';
import '../screens/create_match.dart';
import '../screens/profile_dashboard.dart';

import '../screens/matches_screen.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex;

  const SharedBottomNav({
    super.key,
    required this.currentIndex,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.primaryColor;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      height: 70,
      decoration: BoxDecoration(
        color: (theme.cardTheme.color ?? theme.cardColor).withOpacity(0.9), // Slightly lighter than background
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, Icons.home_filled, Icons.home_outlined, 'Início', activeColor, theme),
              _buildNavItem(context, 1, Icons.search, Icons.search_outlined, 'Buscar', activeColor, theme),
              _buildNavItem(context, 2, Icons.gamepad, Icons.gamepad_outlined, 'Partidas', activeColor, theme),
              _buildNavItem(context, 3, Icons.person, Icons.person_outline, 'Perfil', activeColor, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData activeIcon, IconData inactiveIcon, String label, Color activeColor, ThemeData theme) {
    final isSelected = index == currentIndex;
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected 
            ? BoxDecoration(
                color: activeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? activeColor : mutedColor,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 4, height: 4,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const GameCatalog();
        break;
      case 1:
        destination = const ExploreScreen();
        break;
      case 2:
        destination = const CreateMatch();
        break;
      case 3:
        destination = const ProfileDashboard(); 
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
