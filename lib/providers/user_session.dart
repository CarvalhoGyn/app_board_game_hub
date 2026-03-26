import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

class UserSession extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isPremium => _currentUser?.isPremium ?? false;

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateSubscription({required bool isPremium, String? type, DateTime? expiresAt}) {
     if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          isPremium: isPremium,
          subscriptionType: drift.Value(type),
          subscriptionExpiresAt: drift.Value(expiresAt),
        );
        notifyListeners();
     }
  }
}
