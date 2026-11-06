import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../models/parent_reward_model.dart';
import '../utils/storage_service.dart';

class ParentProvider extends ChangeNotifier {
  String _pin = '1234';
  bool _isAuthenticated = false;
  List<Question> _customQuestions = [];
  List<ParentReward> _rewards = [];
  int _questionTimerSeconds = 0;
  bool _isLoading = true;

  String get pin => _pin;
  bool get isAuthenticated => _isAuthenticated;
  List<Question> get customQuestions => _customQuestions;
  List<ParentReward> get rewards => _rewards;
  int get questionTimerSeconds => _questionTimerSeconds;
  bool get isLoading => _isLoading;

  ParentProvider() {
    loadParentData();
  }

  Future<void> loadParentData() async {
    _isLoading = true;
    notifyListeners();
    _pin = await StorageService.loadPin();
    _customQuestions = await StorageService.loadCustomQuestions();
    _rewards = await StorageService.loadRewards();
    _questionTimerSeconds = await StorageService.loadTimerSeconds();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTimerSeconds(int seconds) async {
    _questionTimerSeconds = seconds;
    await StorageService.saveTimerSeconds(seconds);
    notifyListeners();
  }

  bool verifyPin(String inputPin) {
    if (inputPin == _pin) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logoutParent() {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updatePin(String newPin) async {
    _pin = newPin;
    await StorageService.savePin(newPin);
    notifyListeners();
  }

  Future<void> addCustomQuestion(Question question) async {
    await StorageService.saveCustomQuestion(question);
    _customQuestions.add(question);
    notifyListeners();
  }

  Future<void> updateCustomQuestion(Question question) async {
    final index = _customQuestions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _customQuestions[index] = question;
      await StorageService.updateCustomQuestion(question);
      notifyListeners();
    }
  }

  Future<void> deleteCustomQuestion(String id) async {
    _customQuestions.removeWhere((q) => q.id == id);
    await StorageService.deleteCustomQuestion(id);
    notifyListeners();
  }

  Future<void> toggleRewardClaim(String rewardId) async {
    final index = _rewards.indexWhere((r) => r.id == rewardId);
    if (index != -1) {
      final current = _rewards[index];
      _rewards[index] = ParentReward(
        id: current.id,
        title: current.title,
        targetStars: current.targetStars,
        isClaimed: !current.isClaimed,
      );
      await StorageService.saveRewards(_rewards);
      notifyListeners();
    }
  }

  Future<void> addReward(String title, int targetStars) async {
    final newReward = ParentReward(
      id: 'reward_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      targetStars: targetStars,
    );
    _rewards.add(newReward);
    await StorageService.saveRewards(_rewards);
    notifyListeners();
  }

  Future<void> updateReward(String id, String title, int targetStars) async {
    final index = _rewards.indexWhere((r) => r.id == id);
    if (index != -1) {
      _rewards[index] = ParentReward(
        id: id,
        title: title,
        targetStars: targetStars,
        isClaimed: _rewards[index].isClaimed,
      );
      await StorageService.saveRewards(_rewards);
      notifyListeners();
    }
  }

  Future<void> deleteReward(String id) async {
    _rewards.removeWhere((r) => r.id == id);
    await StorageService.saveRewards(_rewards);
    notifyListeners();
  }

  // Topic Weakness Detector Recommendation tailored strictly for SD (Kelas 1-6) Matematika & Bahasa Inggris
  List<String> getWeaknessRecommendations(double accuracyRate) {
    if (accuracyRate < 60) {
      return [
        'Anak memerlukan bimbingan tambahan pada Matematika Dasar (Perkalian, Pembagian & Pecahan SD).',
        'Disarankan mengulangi Kuis Bahasa Inggris Level 1 (Phonics, Basic Vocab & Pronouns).',
        'Dampingi anak mengerjakan kuis Planet Matematika & World Tour Bahasa Inggris secara perlahan.',
      ];
    } else if (accuracyRate < 80) {
      return [
        'Perkembangan belajar anak sangat baik! Tingkatkan latihan pada Planet Geometri & Grammar Bahasa Inggris.',
        'Fokuskan pengerjaan soal pada topik Matematika Lanjutan (Statistika & Aljabar SD Kelas 4-6).',
        'Berikan pujian & dorong anak untuk mengumpulkan Bintang ⭐ di setiap Planet & Negara.',
      ];
    } else {
      return [
        'Luar Biasa! Anak Anda sangat menguasai materi Matematika & Bahasa Inggris SD (Kelas 1-6).',
        'Gunakan fitur Tambah Soal Kustom untuk memasukkan soal PR sekolah anak dari dokumen Word / PDF.',
        'Pertahankan motivasi belajar anak dengan menyiapkan Hadiah / Reward Bintang di Dashboard!',
      ];
    }
  }
}
