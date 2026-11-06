import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../models/user_account_model.dart';

class AuthService {
  static const String _userAccountKey = 'user_account_active';

  static Future<void> _ensureFirebaseInitialized() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (_) {
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
      } catch (_) {}
    }
  }

  /// Load currently saved active user account from local storage
  static Future<UserAccount?> loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_userAccountKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return UserAccount.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Save active user account to local storage
  static Future<void> saveAccount(UserAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userAccountKey, jsonEncode(account.toJson()));
  }

  /// Register a new parent user account with Firebase Auth & Cloud Firestore (Supports Offline Registration)
  static Future<UserAccount> registerUser({
    required String name,
    required String email,
    required String password,
    required String parentPin,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim();
    String uid = '';
    bool isOfflineMode = false;

    // 1. Try Registering to Firebase Authentication
    try {
      await _ensureFirebaseInitialized();
      final cred = await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (cred.user != null) {
        uid = cred.user!.uid;
        await cred.user!.updateDisplayName(cleanName);
      }
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed' || e.code == 'unavailable') {
        isOfflineMode = true;
        uid = 'offline_user_${DateTime.now().millisecondsSinceEpoch}';
        debugPrint('Register Offline Mode: Network unavailable. Created local account $cleanEmail.');
      } else {
        debugPrint('Firebase Auth Register Error: ${e.code} - ${e.message}');
        throw _getAuthErrorMessage(e);
      }
    } catch (e) {
      isOfflineMode = true;
      uid = 'offline_user_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Register Offline Notice: $e. Created local account $cleanEmail.');
    }

    if (uid.isEmpty) {
      uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
    }

    final account = UserAccount(
      uid: uid,
      email: cleanEmail,
      displayName: cleanName,
      parentPin: parentPin.trim(),
      isGuest: false,
      subscription: SubscriptionInfo(isPremium: false, planType: 'free'),
    );

    // 2. Save user profile document to Cloud Firestore if online
    if (!isOfflineMode) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(account.toJson(), SetOptions(merge: true));
        debugPrint('Successfully registered user $cleanEmail to Firestore with UID: $uid');
      } catch (e) {
        debugPrint('Firestore Sync Error: $e');
      }
    }

    // 3. Save to local device storage (SharedPreferences)
    await saveAccount(account);
    return account;
  }

  static String _getAuthErrorMessage(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Silakan masuk ke akun Anda.';
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'operation-not-allowed':
        return 'Metode pendaftaran email belum diaktifkan.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa jaringan internet Anda.';
      default:
        return e.message ?? 'Gagal mendaftar akun (${e.code}).';
    }
  }

  /// Login existing user account with Firebase Auth & Cloud Firestore
  static Future<UserAccount?> loginUser({
    required String email,
    required String password,
  }) async {
    await _ensureFirebaseInitialized();
    final cleanEmail = email.trim().toLowerCase();

    // 1. Try Firebase Authentication Sign-In
    try {
      final cred = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (cred.user != null) {
        final uid = cred.user!.uid;
        String displayName = cred.user!.displayName ?? cleanEmail.split('@').first;

        // Try reading Firestore user record
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
          if (doc.exists && doc.data() != null) {
            final fetchedAccount = UserAccount.fromJson(doc.data()!);
            await saveAccount(fetchedAccount);
            return fetchedAccount;
          }
        } catch (_) {}

        final firebaseAccount = UserAccount(
          uid: uid,
          email: cleanEmail,
          displayName: displayName,
          isGuest: false,
          subscription: SubscriptionInfo(isPremium: false, planType: 'free'),
        );
        await saveAccount(firebaseAccount);
        return firebaseAccount;
      }
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Sign-In Failed: ${e.code} - ${e.message}');
      // Explicitly fail if Firebase Auth rejects credentials or user not found
      return null;
    } catch (e) {
      debugPrint('Firebase Login Notice (Checking Local Storage): $e');
    }

    // 2. Local Storage Check: Check if user was previously registered locally
    final savedAccount = await loadSavedAccount();
    if (savedAccount != null &&
        !savedAccount.isGuest &&
        savedAccount.email.trim().toLowerCase() == cleanEmail) {
      return savedAccount;
    }

    // User is not registered!
    return null;
  }

  /// Create and save guest session
  static Future<UserAccount> loginAsGuest() async {
    final guestAccount = UserAccount.guest();
    await saveAccount(guestAccount);
    return guestAccount;
  }

  /// Send password reset email via Firebase Authentication
  static Future<String?> sendPasswordReset(String email) async {
    try {
      await _ensureFirebaseInitialized();
      final cleanEmail = email.trim().toLowerCase();
      if (cleanEmail.isEmpty) {
        return 'Alamat email wajib diisi.';
      }
      await fb.FirebaseAuth.instance.sendPasswordResetEmail(email: cleanEmail);
      return null;
    } on fb.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Email ini belum terdaftar. Silakan periksa kembali atau buat akun baru.';
        case 'invalid-email':
          return 'Format alamat email tidak valid.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah. Periksa jaringan internet Anda.';
        default:
          return e.message ?? 'Gagal mengirim email reset password (${e.code}).';
      }
    } catch (e) {
      return 'Terjadi kendala saat mengirim email reset password: $e';
    }
  }

  /// Logout current user session
  static Future<void> logout() async {
    try {
      await fb.FirebaseAuth.instance.signOut();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userAccountKey);
  }

  /// Update premium subscription status and sync to Firestore
  static Future<UserAccount> updatePremiumSubscription({
    required UserAccount account,
    required bool isPremium,
    required String planType,
    DateTime? validUntil,
  }) async {
    final updatedAccount = UserAccount(
      uid: account.uid,
      email: account.email,
      displayName: account.displayName,
      role: account.role,
      parentPin: account.parentPin,
      isGuest: account.isGuest,
      subscription: SubscriptionInfo(
        isPremium: isPremium,
        planType: planType,
        validUntil: validUntil ?? DateTime.now().add(const Duration(days: 30)),
        activatedAt: DateTime.now(),
      ),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(account.uid)
          .set(updatedAccount.toJson(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Firestore Premium Sync Notice: $e');
    }

    await saveAccount(updatedAccount);
    return updatedAccount;
  }
}
