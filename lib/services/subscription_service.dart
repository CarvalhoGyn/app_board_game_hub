import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../providers/user_session.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import '../services/supabase_sync_service.dart';

class SubscriptionService {
  static const String _entitlementId = 'Meeple Sync Pro';
  static const String _apiKey = 'test_ZyUcixKkMZHleCtqrzYgHSKJmNL';

  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  /// Initialize the RevenueCat SDK
  Future<void> initialize(String userId) async {
    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      // Configure for both iOS and Android (using same key for test as provided)
      PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey)
        ..appUserID = userId;
      
      await Purchases.configure(configuration);
      debugPrint('RevenueCat: Initialized for user $userId');
      
      
      await Purchases.configure(configuration);
      debugPrint('RevenueCat: Initialized for user $userId');
    } catch (e) {
      debugPrint('RevenueCat: Initialization Error: $e');
    }
  }

  /// Updates local status and Supabase based on RevenueCat Info
  Future<bool> updateSubscriptionStatus(String userId, UsersDao usersDao, UserSession session, SupabaseSyncService syncService) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      
      // Check if user has the active entitlement
      final bool isPremium = customerInfo.entitlements.active.containsKey(_entitlementId);
      final String? planType = _getPlanType(customerInfo);
      final DateTime? expirationDate = _getExpirationDate(customerInfo);

      debugPrint('RevenueCat: Status check - Premium: $isPremium');

      // 1. Update Session (UI)
      session.updateSubscription(
        isPremium: isPremium,
        type: planType,
        expiresAt: expirationDate,
      );

      // 2. Persist to Local DB (Drift)
      final user = await usersDao.getUserById(userId);
      if (user != null) {
        await usersDao.updateUser(user.id, UsersCompanion(
          isPremium: drift.Value(isPremium),
          subscriptionType: drift.Value(planType),
          subscriptionExpiresAt: drift.Value(expirationDate),
        ));
        
        // 3. Force Sync to Supabase (Cloud-First)
        await syncService.sync();
      }

      return isPremium;
    } catch (e) {
      debugPrint('RevenueCat: Error checking status: $e');
      return false;
    }
  }

  /// Launches the RevenueCat Paywall UI
  Future<void> showPaywall(String userId, UsersDao usersDao, UserSession session, SupabaseSyncService syncService) async {
    try {
      // Using modern PaywallView from purchases_ui_flutter
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(_entitlementId);
      debugPrint('RevenueCat: Paywall result: $paywallResult');
      
      // Refresh status after paywall closes
      await updateSubscriptionStatus(userId, usersDao, session, syncService);
    } catch (e) {
      debugPrint('RevenueCat: Error presenting paywall: $e');
    }
  }

  /// Launches the Customer Center for subscription management
  Future<void> showCustomerCenter() async {
    try {
       // Requires purchases_ui_flutter correctly configured
       await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      debugPrint('RevenueCat: Error presenting customer center: $e');
    }
  }

  /// Helper to get plan type from info
  String? _getPlanType(CustomerInfo info) {
    if (!info.entitlements.active.containsKey(_entitlementId)) return 'free';
    final entitlement = info.entitlements.active[_entitlementId]!;
    if (entitlement.productIdentifier.contains('yearly')) return 'annual';
    if (entitlement.productIdentifier.contains('monthly')) return 'monthly';
    return 'premium';
  }

  /// Helper to get expiration date
  DateTime? _getExpirationDate(CustomerInfo info) {
    if (!info.entitlements.active.containsKey(_entitlementId)) return null;
    final expirationStr = info.entitlements.active[_entitlementId]!.expirationDate;
    if (expirationStr == null) return null;
    return DateTime.parse(expirationStr);
  }
}
