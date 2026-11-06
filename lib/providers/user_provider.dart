import 'package:flutter/foundation.dart';
import '../models/user_account_model.dart';
import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';

class UserProvider extends ChangeNotifier {
  UserAccount? _account;
  bool _isLoading = true;

  UserAccount? get account => _account;
  bool get isLoading => _isLoading;
  bool get isGuest => _account?.isGuest ?? true;
  bool get isPremium => true;

  UserProvider() {
    _initAccount();
  }

  Future<void> _initAccount() async {
    _isLoading = true;
    notifyListeners();
    try {
      _account = await AuthService.loadSavedAccount();
    } catch (e) {
      debugPrint('Error loading saved account: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    if (!isGuest) {
      CloudSyncService.ensureCacheLoaded();
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String parentPin,
  }) async {
    try {
      _account = await AuthService.registerUser(
        name: name,
        email: email,
        password: password,
        parentPin: parentPin,
      );
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _account = await AuthService.loginUser(
        email: email,
        password: password,
      );
      notifyListeners();
      if (_account != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    return await AuthService.sendPasswordReset(email);
  }

  Future<void> loginAsGuest() async {
    _account = await AuthService.loginAsGuest();
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.logout();
    _account = null;
    notifyListeners();
  }

  Future<void> activatePremium({String planType = 'lifetime', int durationDays = 3650}) async {
    if (_account == null) return;
    _account = await AuthService.updatePremiumSubscription(
      account: _account!,
      isPremium: true,
      planType: planType,
      validUntil: DateTime.now().add(Duration(days: durationDays)),
    );
    notifyListeners();
  }

  /// All topics are 100% unlocked for everyone (Mode Gratis & Terbuka Penuh)
  bool canAccessTopic(int topicIndex) => true;

  /// All HOTS level questions are 100% unlocked
  bool canAccessHotsLevel() => true;

  /// PDF report download is 100% unlocked
  bool canDownloadPdfReport() => true;
}
