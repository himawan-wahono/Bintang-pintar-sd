import 'package:flutter/foundation.dart';
import '../models/user_stats_model.dart';
import '../models/user_profile_model.dart';
import '../utils/storage_service.dart';

class StatsProvider extends ChangeNotifier {
  UserStats _stats = UserStats();
  bool _isLoading = true;

  List<UserProfile> _profiles = [];
  UserProfile _activeProfile = UserProfile(
    id: 'default_child',
    name: 'Bintang Pintar',
    gradeLevel: 'SD',
    classNum: 4,
    avatar: 'robot',
  );

  UserStats get stats => _stats;
  bool get isLoading => _isLoading;
  List<UserProfile> get profiles => _profiles;
  UserProfile get activeProfile => _activeProfile;

  final List<BadgeItem> allBadges = [
    BadgeItem(
      id: 'beginner_explorer',
      title: 'Penjelajah Angkasa 🚀',
      description: 'Menyelesaikan penerbangan kuis planet pertama kamu!',
      icon: '🚀',
      requiredXp: 10,
    ),
    BadgeItem(
      id: 'numbers_master',
      title: 'Penakluk Planet Bilangan 🪐',
      description: 'Menguasai KABATAKU, nilai tempat & pecahan!',
      icon: '🪐',
      requiredXp: 100,
    ),
    BadgeItem(
      id: 'geometry_expert',
      title: 'Pakar Geometri Kosmik 📐',
      description: 'Menguasai sudut, keliling, luas & volume ruang!',
      icon: '📐',
      requiredXp: 250,
    ),
    BadgeItem(
      id: 'measurement_navigator',
      title: 'Navigator Waktu & Satuan ⏱️',
      description: 'Menguasai konversi tangga satuan, kecepatan & debit!',
      icon: '⏱️',
      requiredXp: 450,
    ),
    BadgeItem(
      id: 'data_master',
      title: 'Pakar Data & Statistika Galaksi 📊',
      description: 'Mengolah diagram, modus, median & mean kosmik!',
      icon: '📊',
      requiredXp: 650,
    ),
    BadgeItem(
      id: 'algebra_master',
      title: 'Master Aljabar & Skala Kartesius 🔮',
      description: 'Menemukan pola deret & sistem koordinat antariksa!',
      icon: '🔮',
      requiredXp: 850,
    ),
    BadgeItem(
      id: 'supernova_trophy',
      title: 'Piala Supernova Kosmik 🏆',
      description: 'Meraih 1.000 XP & Menjadi Juara Galaksi Matematika!',
      icon: '🏆',
      requiredXp: 1000,
    ),
  ];

  StatsProvider() {
    loadUserStats();
  }

  Future<void> loadUserStats() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stats = await StorageService.loadStats();
      _profiles = await StorageService.loadProfiles();
      final activeId = await StorageService.loadActiveProfileId();
      _activeProfile = _profiles.firstWhere(
        (p) => p.id == activeId,
        orElse: () => _profiles.isNotEmpty ? _profiles.first : _defaultProfile(),
      );
      _checkBadges();
    } catch (e) {
      debugPrint('Error loading stats/profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  UserProfile _defaultProfile() {
    return UserProfile(
      id: 'default_child',
      name: 'Bintang Pintar',
      gradeLevel: 'SD',
      classNum: 4,
      avatar: 'robot',
    );
  }

  Future<void> addProfile(UserProfile profile) async {
    _profiles.add(profile);
    await StorageService.saveProfiles(_profiles);
    await switchProfile(profile.id);
  }

  Future<void> updateProfile(UserProfile updated) async {
    final index = _profiles.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _profiles[index] = updated;
      if (_activeProfile.id == updated.id) {
        _activeProfile = updated;
      }
      await StorageService.saveProfiles(_profiles);
      notifyListeners();
    }
  }

  Future<void> switchProfile(String profileId) async {
    final selected = _profiles.firstWhere(
      (p) => p.id == profileId,
      orElse: () => _profiles.first,
    );
    _activeProfile = selected;
    await StorageService.saveActiveProfileId(selected.id);
    notifyListeners();
  }

  Future<void> deleteProfile(String profileId) async {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.id == profileId);
    await StorageService.saveProfiles(_profiles);
    if (_activeProfile.id == profileId) {
      await switchProfile(_profiles.first.id);
    } else {
      notifyListeners();
    }
  }

  Future<void> markOnboardingSeen() async {
    _stats.hasSeenOnboarding = true;
    await StorageService.saveStats(_stats);
    notifyListeners();
  }

  Future<void> recordQuizResult({
    required int correctCount,
    required int totalQuestions,
    required int starsEarned,
    int? levelNumber,
  }) async {
    final xpEarned = (correctCount * 20) + (starsEarned * 15);
    _stats.totalXp += xpEarned;
    _stats.totalStars += starsEarned;
    _stats.quizzesCompleted += 1;
    _stats.totalCorrectAnswers += correctCount;
    _stats.totalQuestionsAnswered += totalQuestions;

    if (levelNumber != null) {
      final currentStars = _stats.levelStars[levelNumber] ?? 0;
      if (starsEarned > currentStars) {
        _stats.levelStars[levelNumber] = starsEarned;
      }
    }

    _checkBadges();
    await StorageService.saveStats(_stats);
    notifyListeners();
  }

  void _checkBadges() {
    for (var badge in allBadges) {
      if (_stats.totalXp >= badge.requiredXp &&
          !_stats.unlockedBadgeIds.contains(badge.id)) {
        _stats.unlockedBadgeIds.add(badge.id);
      }
    }
  }
}
