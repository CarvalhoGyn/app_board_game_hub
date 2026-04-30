import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_session.dart';
import '../services/subscription_service.dart';
import '../database/database.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';
import '../services/supabase_sync_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isLoading = true;
  bool _isPurchasing = false;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final offerings = await SubscriptionService().getOfferings();
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_offerings?.current == null) ...[
                  _buildPricingCard(
                    context, 
                    l10n.premiumMonthlyPlan, 
                    "R\$ 14,90", 
                    l10n.premiumMonthlyDesc,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("RevenueCat não configurado. Oferecimento simulado.")),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPricingCard(
                    context, 
                    l10n.premiumAnnualPlan, 
                    "R\$ 119,90", 
                    l10n.premiumAnnualDesc,
                    isPopular: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("RevenueCat não configurado. Oferecimento simulado.")),
                      );
                    },
                  ),
                ] else ...[
                  if (_offerings!.current!.monthly != null)
                    _buildPricingCard(
                      context, 
                      l10n.premiumMonthlyPlan, 
                      _offerings!.current!.monthly!.storeProduct.priceString, 
                      l10n.premiumMonthlyDesc,
                      onTap: () => _handleSubscribe(context, _offerings!.current!.monthly!),
                    ),
                  const SizedBox(height: 16),
                  if (_offerings!.current!.annual != null)
                    _buildPricingCard(
                      context, 
                      l10n.premiumAnnualPlan, 
                      _offerings!.current!.annual!.storeProduct.priceString, 
                      l10n.premiumAnnualDesc,
                      isPopular: true,
                      onTap: () => _handleSubscribe(context, _offerings!.current!.annual!),
                    ),
                ],
              ],
            ),
          ),
          if (_isPurchasing)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  void _handleSubscribe(BuildContext context, Package package) async {
    final l10n = AppLocalizations.of(context)!;
    final session = context.read<UserSession>();
    final usersDao = context.read<UsersDao>();
    final userId = session.currentUser?.id;
    
    if (userId != null) {
      setState(() => _isPurchasing = true);
      final syncService = context.read<SupabaseSyncService>();
      final success = await SubscriptionService().purchasePackage(package, userId, usersDao, session, syncService);
      
      if (mounted) {
        setState(() => _isPurchasing = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.premiumWelcomeMessage), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true); // Close paywall and indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.subscriptionFailed), backgroundColor: Colors.red),
          );
        }
      }
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
