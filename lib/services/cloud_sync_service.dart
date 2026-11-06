import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/question_model.dart';
import '../firebase_options.dart';
import '../utils/storage_service.dart';
import 'connectivity_service.dart';
import 'ai_question_generator_service.dart';
import 'ai_english_generator_service.dart';

class TopicProgressStats {
  final int totalQuestions;
  final int completedQuestions;
  final int remainingQuestions;
  final double progressPercent; // 0.0 to 1.0

  const TopicProgressStats({
    required this.totalQuestions,
    required this.completedQuestions,
    required this.remainingQuestions,
    required this.progressPercent,
  });

  bool get isCompleted => totalQuestions > 0 && completedQuestions >= totalQuestions;
}

enum SyncProgressState { idle, syncing, success, error }

class SyncProgressInfo {
  final SyncProgressState state;
  final int downloadedCount;
  final int targetCount;
  final String message;
  final double? progress; // 0.0 to 1.0 or null

  const SyncProgressInfo({
    required this.state,
    this.downloadedCount = 0,
    this.targetCount = 1000,
    this.message = '',
    this.progress,
  });
}

class CloudSyncService {
  static const String collectionName = 'cloud_questions';

  // In-memory cache of the downloaded 1000+ questions for instant 0ms access
  static List<Question> _cachedQuestions = [];
  static bool _isSyncing = false;

  static final ValueNotifier<SyncProgressInfo> syncProgress =
      ValueNotifier<SyncProgressInfo>(const SyncProgressInfo(state: SyncProgressState.idle));

  static bool get isSyncing => _isSyncing;
  static int get localQuestionCount => _cachedQuestions.length;

  /// Ensures Firebase core is ready before Firestore operations
  static Future<void> ensureFirebaseInitialized() async {
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

  static FirebaseApp? _supersinanApp;

  /// Retrieves Firestore instance connected specifically to project 'supersinan'
  static Future<FirebaseFirestore> getQuestionsFirestore() async {
    await ensureFirebaseInitialized();
    try {
      if (_supersinanApp == null) {
        for (var app in Firebase.apps) {
          if (app.name == 'supersinan') {
            _supersinanApp = app;
            break;
          }
        }
      }
      _supersinanApp ??= await Firebase.initializeApp(
        name: 'supersinan',
        options: DefaultFirebaseOptions.supersinan,
      );
      return FirebaseFirestore.instanceFor(app: _supersinanApp!);
    } catch (e) {
      debugPrint('Notice getQuestionsFirestore fallback to default: $e');
      return FirebaseFirestore.instance;
    }
  }

  /// Parses a Firestore DocumentSnapshot into a Question model with safety fallbacks
  static Question parseFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Class number parsing (int or string)
    int classNumber = 1;
    if (data['classNum'] is int) {
      classNumber = data['classNum'] as int;
    } else if (data['classNum'] != null) {
      classNumber = int.tryParse(data['classNum'].toString()) ?? 1;
    }

    // Answer index parsing
    int ansIndex = 0;
    if (data['correctAnswerIndex'] is int) {
      ansIndex = data['correctAnswerIndex'] as int;
    } else if (data['correctAnswerIndex'] != null) {
      ansIndex = int.tryParse(data['correctAnswerIndex'].toString()) ?? 0;
    }

    // Options parsing
    List<String> opts = [];
    if (data['options'] is List) {
      opts = (data['options'] as List).map((e) => e.toString()).toList();
    }

    // Visual Data parsing
    Map<String, dynamic>? vData;
    if (data['visualData'] is Map) {
      vData = Map<String, dynamic>.from(data['visualData'] as Map);
    }

    return Question(
      id: doc.id,
      gradeLevel: data['gradeLevel']?.toString() ?? 'SD',
      classNum: classNumber,
      subject: data['subject']?.toString() ?? 'Matematika',
      topic: data['topic']?.toString() ?? data['category']?.toString() ?? 'Umum',
      level: data['level']?.toString() ?? data['difficulty']?.toString() ?? 'Sedang',
      questionText: data['questionText']?.toString() ?? data['question']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString(),
      visualType: data['visualType']?.toString(),
      visualData: vData,
      visualLabel: data['visualLabel']?.toString(),
      options: opts,
      correctAnswerIndex: ansIndex,
      explanation: data['explanation']?.toString() ?? '',
      isCustom: true,
    );
  }

  /// Loads the bundled 1.223 base questions package from app asset
  static Future<List<Question>> loadBaseAssetQuestions() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/bank_soal_base.json');
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      final List list = data['questions'] as List? ?? [];
      return list.map((item) => Question.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Notice loading base questions asset: $e');
      return [];
    }
  }

  /// Ensures that questions stored in local phone storage are loaded into memory
  static Future<void> ensureCacheLoaded({bool forceReload = false}) async {
    if (_cachedQuestions.isEmpty || forceReload) {
      final hasDownloaded = await StorageService.hasDownloadedBaseSoal();
      if (hasDownloaded) {
        final base = await loadBaseAssetQuestions();
        final delta = await StorageService.loadDeltaQuestions();
        final List<Question> combined = List.from(base);
        final Set<String> seenIds = combined.map((e) => e.id).toSet();
        for (var q in delta) {
          if (!seenIds.contains(q.id)) {
            combined.add(q);
            seenIds.add(q.id);
          }
        }
        _cachedQuestions = combined;
      } else {
        // Fallback: check if legacy or test cache had questions saved
        final legacy = await StorageService.loadCachedCloudQuestions();
        if (legacy.isNotEmpty) {
          _cachedQuestions = legacy;
        } else {
          _cachedQuestions = [];
        }
      }
      debugPrint('Loaded ${_cachedQuestions.length} cached questions into memory.');
    }
  }

  /// Downloads questions:
  /// 1. If base package (1.223 questions) not yet installed, extracts it from app asset with 0 Firestore reads!
  /// 2. Performs delta update from Firestore for any new questions added since last sync.
  static Future<int> syncBulkQuestionsFromCloud({int targetCount = 10000}) async {
    if (_isSyncing) return _cachedQuestions.length;
    _isSyncing = true;
    syncProgress.value = const SyncProgressInfo(
      state: SyncProgressState.syncing,
      message: 'Menghubungkan ke Database Soal...',
      progress: 0.1,
    );

    try {
      final bool hasBase = await StorageService.hasDownloadedBaseSoal();
      List<Question> combined = [];

      if (!hasBase || _cachedQuestions.isEmpty) {
        syncProgress.value = const SyncProgressInfo(
          state: SyncProgressState.syncing,
          message: 'Mengunduh dan memasang 1.223 Soal Matematika & Bahasa Inggris...',
          progress: 0.4,
        );

        final baseQuestions = await loadBaseAssetQuestions();
        combined.addAll(baseQuestions);
        await StorageService.setDownloadedBaseSoal(true);
        _cachedQuestions = combined;

        syncProgress.value = SyncProgressInfo(
          state: SyncProgressState.syncing,
          downloadedCount: combined.length,
          message: 'Memeriksa pembaruan soal baru di Server...',
          progress: 0.8,
        );
      } else {
        combined = List.from(_cachedQuestions);
      }

      // Check Firestore for any new delta questions
      int newlyAdded = 0;
      try {
        final firestore = await getQuestionsFirestore();
        final lastSyncTime = await StorageService.loadLastCloudSyncTime();

        Query query = firestore.collection(collectionName);
        if (lastSyncTime != null) {
          query = query.where('createdAt', isGreaterThan: Timestamp.fromDate(lastSyncTime)).limit(500);
        } else {
          query = query.orderBy('createdAt', descending: true).limit(50);
        }

        final snapshot = await query.get().timeout(const Duration(seconds: 8));
        final Set<String> seenIds = combined.map((e) => e.id).toSet();
        final Set<String> seenTexts = combined.map((e) => e.questionText.trim().toLowerCase()).toSet();
        final List<Question> deltaList = await StorageService.loadDeltaQuestions();

        for (var doc in snapshot.docs) {
          final q = parseFirestoreDoc(doc);
          final textKey = q.questionText.trim().toLowerCase();
          if (textKey.isNotEmpty && !seenTexts.contains(textKey) && !seenIds.contains(q.id)) {
            seenIds.add(q.id);
            seenTexts.add(textKey);
            combined.add(q);
            deltaList.add(q);
            newlyAdded++;
          }
        }
        if (newlyAdded > 0) {
          await StorageService.saveDeltaQuestions(deltaList);
        }
      } catch (cloudErr) {
        debugPrint('Delta sync notice (offline or limit): $cloudErr');
      }

      if (combined.isNotEmpty) {
        _cachedQuestions = combined;
        await StorageService.saveLastCloudSyncTime(DateTime.now());
        await StorageService.saveLastKnownCloudCount(combined.length);
        ConnectivityService().recordSuccessfulSync();
        ConnectivityService().refreshQuestionCount();

        debugPrint('✅ Sukses sinkronisasi: ${combined.length} soal di memori HP ($newlyAdded baru)!');
        syncProgress.value = SyncProgressInfo(
          state: SyncProgressState.success,
          downloadedCount: combined.length,
          message: newlyAdded > 0
              ? 'Berhasil mengunduh $newlyAdded soal baru! Total ${combined.length} soal di memori HP.'
              : 'Berhasil! Total ${combined.length} soal siap dimainkan 100% offline.',
          progress: 1.0,
        );
        return combined.length;
      } else {
        syncProgress.value = const SyncProgressInfo(
          state: SyncProgressState.error,
          downloadedCount: 0,
          message: '0 soal ditemukan di koleksi cloud_questions.',
          progress: 0.0,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error saat sinkronisasi bulk soal dari cloud: $e');
      String errMsg = e.toString().replaceAll('Exception:', '').trim();
      if (errMsg.contains('resource-exhausted') || errMsg.contains('Quota exceeded') || errMsg.contains('429')) {
        errMsg = 'Batas kuota harian server tercapai. Soal di memori HP tetap siap dimainkan offline.';
      } else if (errMsg.contains('unavailable') || errMsg.contains('network') || errMsg.contains('SocketException')) {
        errMsg = 'Koneksi ke server terputus. Menggunakan bank soal di memori HP.';
      }
      syncProgress.value = SyncProgressInfo(
        state: SyncProgressState.error,
        downloadedCount: 0,
        message: 'Gagal mengunduh: $errMsg',
        progress: 0.0,
      );
    } finally {
      _isSyncing = false;
    }

    // If download failed or was offline, ensure memory cache is at least loaded from disk
    await ensureCacheLoaded();
    return _cachedQuestions.length;
  }

  /// Normalizes a topic string for strict comparison (removes punctuation, lowercase)
  static String _cleanTopic(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .trim();
  }

  /// Strict topic comparison logic:
  /// Prevents false overlap between similar keywords (e.g. "Pola Bilangan" vs "Pengenalan Pola Gambar")
  static bool _isStrictTopicMatch(String a, String b) {
    if (a.isEmpty || b.isEmpty) return false;
    if (a == b) return true;

    // Strict prefix matching for extended labels (e.g. "pengenalanbilangan" and "pengenalanbilangandannilaitempat")
    if (a.length >= 8 && b.length >= 8) {
      if (a.startsWith(b) || b.startsWith(a)) return true;
    }
    return false;
  }

  /// Master method to assemble quiz questions directly from local memory:
  /// 1. Reads from the 1000+ cached questions in phone memory
  /// 2. Performs strict topic & subject matching (NO cross-topic bleeding)
  /// 3. Shuffles and takes the requested count (e.g. 10 or 20)
  /// 4. Pads with AI Procedural Generator if local pool is fewer than count
  /// 5. Merges parent custom questions
  static Future<List<Question>> getQuizQuestions({
    required String subject,
    required String topic,
    required String gradeLevel,
    required int classNum,
    int count = 10,
    List<Question> customQuestions = const [],
    bool isGuest = false,
  }) async {
    // Jika masuk menggunakan akun Tamu, HANYA tampilkan soal bawaan dari aplikasi
    if (isGuest) {
      final isEnglish = subject.toLowerCase().contains('inggris') ||
          gradeLevel.toLowerCase() == 'english';
      if (isEnglish) {
        return AiEnglishGeneratorService.generateDynamicEnglishQuestions(
          gradeLevel: gradeLevel,
          classNum: classNum,
          count: count,
          topic: topic,
        );
      } else {
        return AiQuestionGeneratorService.generateDynamicMathQuestions(
          gradeLevel: gradeLevel,
          classNum: classNum,
          count: count,
          topic: topic,
        );
      }
    }

    await ensureCacheLoaded();

    final normTargetSubject = subject.toLowerCase().trim();
    final normTargetTopic = _cleanTopic(topic);

    // 1. Strict filter from cached 1000 questions in phone memory
    final List<Question> matching = [];
    for (var q in _cachedQuestions) {
      final qSubj = q.subject.toLowerCase().trim();
      final qTopic = _cleanTopic(q.topic);

      final bool matchSubject = normTargetSubject.isEmpty ||
          qSubj == normTargetSubject ||
          (normTargetSubject.contains('inggris') && qSubj.contains('inggris')) ||
          (normTargetSubject.contains('matematika') && qSubj.contains('matematika'));

      final bool matchTopic = _isStrictTopicMatch(qTopic, normTargetTopic);

      if (matchSubject && matchTopic) {
        matching.add(q);
      }
    }

    // Smart Question Selection: Prioritize unattempted questions
    final answeredSet = await StorageService.loadAnsweredQuestionIds(topic);
    final unattempted = matching.where((q) {
      final qId = q.id.isNotEmpty ? q.id : q.questionText.hashCode.toString();
      return !answeredSet.contains(qId);
    }).toList();
    final attempted = matching.where((q) {
      final qId = q.id.isNotEmpty ? q.id : q.questionText.hashCode.toString();
      return answeredSet.contains(qId);
    }).toList();

    unattempted.shuffle();
    attempted.shuffle();

    List<Question> result = [...unattempted, ...attempted].take(count).toList();

    // 2. Pad with AI Procedural Generator if fewer questions than requested count
    if (result.length < count) {
      final needed = count - result.length;
      final isEnglish = subject.toLowerCase().contains('inggris') ||
          gradeLevel.toLowerCase() == 'english';

      if (isEnglish) {
        final generated = AiEnglishGeneratorService.generateDynamicEnglishQuestions(
          gradeLevel: gradeLevel,
          classNum: classNum,
          count: needed,
          topic: topic,
        );
        result.addAll(generated);
      } else {
        final generated = AiQuestionGeneratorService.generateDynamicMathQuestions(
          gradeLevel: gradeLevel,
          classNum: classNum,
          count: needed,
          topic: topic,
        );
        result.addAll(generated);
      }
    }

    // 3. Merge custom questions matching topic
    for (var cq in customQuestions) {
      final cqTopic = _cleanTopic(cq.topic);
      final cqSubj = cq.subject.toLowerCase().trim();
      if ((cqSubj == normTargetSubject || normTargetSubject.contains(cqSubj)) &&
          _isStrictTopicMatch(cqTopic, normTargetTopic)) {
        if (!result.any((q) => q.id == cq.id || q.questionText == cq.questionText)) {
          result.insert(0, cq);
        }
      }
    }

    result.shuffle();
    return result.take(count).toList();
  }

  /// Returns total count of questions stored in Firestore `cloud_questions` collection
  static Future<int> fetchTotalCloudQuestionsCount() async {
    try {
      final firestore = await getQuestionsFirestore();
      final aggregateSnapshot = await firestore
          .collection(collectionName)
          .count()
          .get()
          .timeout(const Duration(seconds: 10));
      final count = aggregateSnapshot.count;
      if (count != null && count > 0) {
        return count;
      }
    } catch (e) {
      debugPrint('fetchTotalCloudQuestionsCount notice: $e');
    }
    return 0;
  }

  /// Legacy compatibility wrapper
  static Future<int> syncAllQuestionsToLocal() async {
    return await syncBulkQuestionsFromCloud(targetCount: 1000);
  }

  /// Returns all cached questions matching the given subject and topic strictly
  static List<Question> getMatchingCachedQuestions({
    required String subject,
    required String topic,
  }) {
    final normTargetSubject = subject.toLowerCase().trim();
    final normTargetTopic = _cleanTopic(topic);
    return _cachedQuestions.where((q) {
      final qSubj = q.subject.toLowerCase().trim();
      final qTopic = _cleanTopic(q.topic);
      final bool matchSubject = normTargetSubject.isEmpty ||
          qSubj == normTargetSubject ||
          (normTargetSubject.contains('inggris') && qSubj.contains('inggris')) ||
          (normTargetSubject.contains('matematika') && qSubj.contains('matematika'));
      return matchSubject && _isStrictTopicMatch(qTopic, normTargetTopic);
    }).toList();
  }

  /// Calculates total, completed, remaining, and percentage for a given topic
  static Future<TopicProgressStats> getTopicProgressStats({
    required String subject,
    required String topic,
  }) async {
    await ensureCacheLoaded();
    final matching = getMatchingCachedQuestions(subject: subject, topic: topic);
    final answeredSet = await StorageService.loadAnsweredQuestionIds(topic);

    // Total questions: if matching from cached cloud is available, use it;
    // otherwise fallback to standard 20 questions target per topic.
    final total = matching.isNotEmpty ? matching.length : 20;

    int completed = 0;
    if (matching.isNotEmpty) {
      for (var q in matching) {
        final qId = q.id.isNotEmpty ? q.id : q.questionText.hashCode.toString();
        if (answeredSet.contains(qId)) {
          completed++;
        }
      }
    } else {
      completed = answeredSet.length > total ? total : answeredSet.length;
    }

    if (completed > total) completed = total;
    final remaining = (total - completed).clamp(0, total);
    final percent = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return TopicProgressStats(
      totalQuestions: total,
      completedQuestions: completed,
      remainingQuestions: remaining,
      progressPercent: percent,
    );
  }

  /// Records question IDs as completed for their corresponding topics
  static Future<void> recordCompletedQuizQuestions(List<Question> questions) async {
    if (questions.isEmpty) return;
    final Map<String, List<String>> byTopic = {};
    for (var q in questions) {
      final t = q.topic.isNotEmpty ? q.topic : 'Umum';
      final qId = q.id.isNotEmpty ? q.id : q.questionText.hashCode.toString();
      byTopic.putIfAbsent(t, () => []).add(qId);
    }
    for (var entry in byTopic.entries) {
      await StorageService.recordAnsweredQuestionIds(
        topic: entry.key,
        questionIds: entry.value,
      );
    }
  }
}

