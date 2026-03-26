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

  /// Fetches available offerings from RevenueCat
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('RevenueCat: Error fetching offerings: $e');
      return null;
    }
  }

  /// Processes a purchase for a specific package
  Future<bool> purchasePackage(Package package, String userId, UsersDao usersDao, UserSession session, SupabaseSyncService syncService) async {
    try {
      final result = await Purchases.purchasePackage(package);
      final customerInfo = result.customerInfo;
      final bool isPremium = customerInfo.entitlements.active.containsKey(_entitlementId);
      
      if (isPremium) {
        await updateSubscriptionStatus(userId, usersDao, session, syncService);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('RevenueCat: Purchase Error: $e');
      return false;
    }
  }

  /// Launches the RevenueCat Paywall UI (Native) - Use only as fallback
  Future<void> showNativePaywall(String userId, UsersDao usersDao, UserSession session, SupabaseSyncService syncService) async {
    try {
      await RevenueCatUI.presentPaywallIfNeeded(_entitlementId);
      await updateSubscriptionStatus(userId, usersDao, session, syncService);
    } catch (e) {
      debugPrint('RevenueCat: Error presenting native paywall: $e');
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

  /// Checks if a user is allowed to participate in a new match (Limit: 5 for Free)
  Future<bool> canParticipateInMatch({
    required String userId,
    required UsersDao usersDao,
    required MatchesDao matchesDao,
    required SupabaseSyncService syncService,
    bool isLocalOnly = false,
  }) async {
    final user = await usersDao.getUserById(userId);
    if (user == null) return false;

    // Premium users have no limit
    if (user.isPremium) return true;

    // For Free users, check participation count
    int count;
    if (isLocalOnly) {
       count = await matchesDao.countMatchesForUser(userId);
    } else {
       count = await syncService.getGlobalMatchCount(userId);
    }
    
    return count < 5;
  }
}
