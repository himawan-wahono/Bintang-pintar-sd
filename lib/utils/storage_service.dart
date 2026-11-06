import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import '../models/user_stats_model.dart';
import '../models/parent_reward_model.dart';
import '../models/user_profile_model.dart';

class StorageService {
  static const String _statsKey = 'user_stats';
  static const String _pinKey = 'parent_pin';
  static const String _customQuestionsKey = 'custom_questions';
  static const String _rewardsKey = 'parent_rewards';
  static const String _profilesKey = 'user_profiles';
  static const String _activeProfileIdKey = 'active_profile_id';
  static const String _cachedCloudQuestionsKey = 'cached_cloud_questions';
  static const String _lastCloudSyncKey = 'last_cloud_sync_timestamp';

  // Stats Storage
  static Future<UserStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_statsKey);
    if (jsonStr != null) {
      try {
        return UserStats.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        return UserStats();
      }
    }
    return UserStats();
  }

  static Future<void> saveStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  static const String _timerKey = 'question_timer_seconds';
  static const String _firstInstallOnboardingKey = 'has_seen_first_install_onboarding_v2';

  // Timer Setting Storage (Default 0 = Mode Santai tanpa batas waktu)
  static Future<int> loadTimerSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_timerKey) ?? 0;
  }

  static Future<void> saveTimerSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timerKey, seconds);
  }

  // Persistent First Install Onboarding Guard
  static Future<bool> hasSeenFirstInstallOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstInstallOnboardingKey) ?? false;
  }

  static Future<void> markFirstInstallOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstInstallOnboardingKey, true);
  }

  // Parent PIN Storage (Default 1234)
  static Future<String> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey) ?? '1234';
  }

  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  // Profile Storage
  static Future<List<UserProfile>> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_profilesKey);
    if (jsonStr != null) {
      try {
        final List list = jsonDecode(jsonStr);
        return list.map((item) => UserProfile.fromJson(item)).toList();
      } catch (e) {
        return [_defaultProfile()];
      }
    }
    return [_defaultProfile()];
  }

  static UserProfile _defaultProfile() {
    return UserProfile(
      id: 'default_child',
      name: 'Bintang Pintar',
      gradeLevel: 'SD',
      classNum: 4,
      avatar: 'robot',
    );
  }

  static Future<void> saveProfiles(List<UserProfile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _profilesKey,
      jsonEncode(profiles.map((p) => p.toJson()).toList()),
    );
  }

  static Future<String> loadActiveProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeProfileIdKey) ?? 'default_child';
  }

  static Future<void> saveActiveProfileId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeProfileIdKey, id);
  }

  // Custom Questions Storage
  static Future<List<Question>> loadCustomQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_customQuestionsKey);
    if (jsonStr != null) {
      try {
        final List list = jsonDecode(jsonStr);
        return list.map((item) => Question.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveCustomQuestion(Question q) async {
    final current = await loadCustomQuestions();
    current.add(q);
    await saveAllCustomQuestions(current);
  }

  static Future<void> saveAllCustomQuestions(List<Question> list) async {
    final prefs = await SharedPreferences.getInstance();
    // FIFO memory cap: keep latest 500 questions max (~250 KB storage ceiling)
    final cappedList = list.length > 500 ? list.sublist(list.length - 500) : list;
    await prefs.setString(
      _customQuestionsKey,
      jsonEncode(cappedList.map((item) => item.toJson()).toList()),
    );
  }

  static Future<void> updateCustomQuestion(Question q) async {
    final current = await loadCustomQuestions();
    final index = current.indexWhere((item) => item.id == q.id);
    if (index != -1) {
      current[index] = q;
      await saveAllCustomQuestions(current);
    }
  }

  static Future<void> deleteCustomQuestion(String id) async {
    final current = await loadCustomQuestions();
    current.removeWhere((item) => item.id == id);
    await saveAllCustomQuestions(current);
  }

  // Parent Rewards Storage
  static Future<List<ParentReward>> loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_rewardsKey);
    if (jsonStr != null) {
      try {
        final List list = jsonDecode(jsonStr);
        return list.map((item) => ParentReward.fromJson(item)).toList();
      } catch (e) {
        return _defaultRewards();
      }
    }
    return _defaultRewards();
  }

  static Future<void> saveRewards(List<ParentReward> rewards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _rewardsKey,
      jsonEncode(rewards.map((r) => r.toJson()).toList()),
    );
  }

  static List<ParentReward> _defaultRewards() {
    return [
      ParentReward(id: '1', title: 'Main Game / YouTube 30 Menit 🎮', targetStars: 10),
      ParentReward(id: '2', title: 'Beli Es Krim Favorit 🍦', targetStars: 20),
      ParentReward(id: '3', title: 'Jalan-jalan ke Taman di Akhir Pekan 🌳', targetStars: 35),
    ];
  }

  // Cached Cloud Questions Storage (Stores up to 1000+ questions locally)
  static Future<List<Question>> loadCachedCloudQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_cachedCloudQuestionsKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final List list = jsonDecode(jsonStr);
        return list.map((item) => Question.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveCachedCloudQuestions(List<Question> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cachedCloudQuestionsKey,
      jsonEncode(list.map((item) => item.toJson()).toList()),
    );
  }

  static Future<DateTime?> loadLastCloudSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? millis = prefs.getInt(_lastCloudSyncKey);
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
    return null;
  }

  static const String _topicProgressPrefix = 'topic_progress_';
  static const String _hasDownloadedBaseSoalKey = 'has_downloaded_base_soal_v2';
  static const String _deltaCloudQuestionsKey = 'delta_cloud_questions';

  static Future<bool> hasDownloadedBaseSoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasDownloadedBaseSoalKey) ?? false;
  }

  static Future<void> setDownloadedBaseSoal(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasDownloadedBaseSoalKey, val);
  }

  static Future<List<Question>> loadDeltaQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_deltaCloudQuestionsKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final List list = jsonDecode(jsonStr);
        return list.map((item) => Question.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveDeltaQuestions(List<Question> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _deltaCloudQuestionsKey,
      jsonEncode(list.map((item) => item.toJson()).toList()),
    );
  }

  static const int defaultServerQuestionsCount = 1223;
  static const String _lastKnownCloudCountKey = 'last_known_cloud_questions_count';

  static Future<int> loadLastKnownCloudCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_lastKnownCloudCountKey) ?? 0;
    return count >= defaultServerQuestionsCount ? count : defaultServerQuestionsCount;
  }

  static Future<void> saveLastKnownCloudCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastKnownCloudCountKey, count);
  }

  static Future<void> saveLastCloudSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastCloudSyncKey, time.millisecondsSinceEpoch);
  }

  static String _sanitizeTopicKey(String topic) {
    return topic.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
  }

  // Topic Progress Storage
  static Future<Set<String>> loadAnsweredQuestionIds(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = await loadActiveProfileId();
    final key = '$_topicProgressPrefix${profileId}_${_sanitizeTopicKey(topic)}';
    final List<String>? list = prefs.getStringList(key);
    if (list != null) {
      return list.toSet();
    }
    return {};
  }

  static Future<void> recordAnsweredQuestionIds({
    required String topic,
    required List<String> questionIds,
  }) async {
    if (questionIds.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final profileId = await loadActiveProfileId();
    final key = '$_topicProgressPrefix${profileId}_${_sanitizeTopicKey(topic)}';
    final current = (prefs.getStringList(key) ?? []).toSet();
    current.addAll(questionIds.where((id) => id.isNotEmpty));
    await prefs.setStringList(key, current.toList());
  }

  static Future<void> resetTopicProgress(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = await loadActiveProfileId();
    final key = '$_topicProgressPrefix${profileId}_${_sanitizeTopicKey(topic)}';
    await prefs.remove(key);
  }
}
