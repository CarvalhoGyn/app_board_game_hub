import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_session.dart';
import '../services/subscription_service.dart';
import '../database/database.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import '../services/supabase_sync_service.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final userSession = context.watch<UserSession>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.diamond_outlined, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              l10n.premiumTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.premiumSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildFeatureRow(context, Icons.all_inclusive, l10n.premiumFeature1Title, l10n.premiumFeature1Desc),
            _buildFeatureRow(context, Icons.analytics_outlined, l10n.premiumFeature2Title, l10n.premiumFeature2Desc),
            _buildFeatureRow(context, Icons.cloud_done_outlined, l10n.premiumFeature3Title, l10n.premiumFeature3Desc),
            const SizedBox(height: 50),
            _buildPricingCard(
              context, 
              l10n.premiumMonthlyPlan, 
              l10n.premiumMonthlyPrice, 
              l10n.premiumMonthlyDesc,
              onTap: () => _handleSubscribe(context),
            ),
            const SizedBox(height: 16),
            _buildPricingCard(
              context, 
              l10n.premiumAnnualPlan, 
              l10n.premiumAnnualPrice, 
              l10n.premiumAnnualDesc,
              isPopular: true,
              onTap: () => _handleSubscribe(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubscribe(BuildContext context) {
    final session = context.read<UserSession>();
    final usersDao = context.read<UsersDao>();
    final userId = session.currentUser?.id;
    
    if (userId != null) {
      final syncService = context.read<SupabaseSyncService>();
      SubscriptionService().showPaywall(userId, usersDao, session, syncService);
    }
  }

  Widget _buildFeatureRow(BuildContext context, IconData icon, String title, String description) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: theme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context, String title, String price, String description, {bool isPopular = false, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? theme.primaryColor.withOpacity(0.05) : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPopular ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.1), width: 2),
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
              child: Text(l10n.premiumBestValue, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(price, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isPopular ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.1),
              foregroundColor: isPopular ? Colors.white : theme.colorScheme.onSurface,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(l10n.premiumSubscribeButton, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
