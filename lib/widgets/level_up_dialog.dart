import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LevelUpDialog extends StatelessWidget {
  final int newLevel;
  final VoidCallback onContinue;

  const LevelUpDialog({super.key, required this.newLevel, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
       backgroundColor: Colors.transparent,
       child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
             color: theme.cardTheme.color,
             borderRadius: BorderRadius.circular(32),
             border: Border.all(color: theme.primaryColor, width: 2),
             boxShadow: [
                BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 30, spreadRadius: 0)
             ]
          ),
          child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
                Text('LEVEL UP!', style: TextStyle(
                   fontSize: 32, fontWeight: FontWeight.bold,  
                   color: theme.primaryColor,
                   letterSpacing: 2,
                   shadows: [Shadow(color: theme.primaryColor, blurRadius: 20)],
                )),
                const SizedBox(height: 24),
                Container(
                   padding: const EdgeInsets.all(24),
                   decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor.withOpacity(0.1),
                      border: Border.all(color: theme.primaryColor, width: 4),
                   ),
                   child: Text(
                      '$newLevel',
                      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                   ),
                ),
                const SizedBox(height: 24),
                Text(
                   'You reached a new level!',
                   textAlign: TextAlign.center,
                   style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                 const SizedBox(height: 32),
                SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                         backgroundColor: theme.primaryColor,
                         foregroundColor: theme.colorScheme.onPrimary,
                         padding: const EdgeInsets.symmetric(vertical: 16),
                         textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('AWESOME!'),
                   ),
                )
             ],
          ),
       ),
    );
  }
}
