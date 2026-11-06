import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/storage_service.dart';
import 'cloud_sync_service.dart';

class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal() {
    _startPinging();
    refreshQuestionCount();
  }

  static const int defaultServerQuestionsCount = 1223;

  bool _isOnline = true;
  DateTime _lastSyncTime = DateTime.now();
  int _totalQuestionsCount = 1000;
  int _cloudQuestionsCount = defaultServerQuestionsCount;
  bool _isCheckingCloud = false;
  Timer? _timer;

  bool get isOnline => _isOnline;
  DateTime get lastSyncTime => _lastSyncTime;
  int get totalQuestionsCount => _totalQuestionsCount;
  int get cloudQuestionsCount => _cloudQuestionsCount;
  bool get isCheckingCloud => _isCheckingCloud;

  int get newQuestionsAvailable {
    final targetServer = _cloudQuestionsCount >= defaultServerQuestionsCount
        ? _cloudQuestionsCount
        : defaultServerQuestionsCount;
    if (targetServer > _totalQuestionsCount) {
      return targetServer - _totalQuestionsCount;
    }
    return 0;
  }

  bool get hasNewQuestions => newQuestionsAvailable > 0;

  String get totalQuestionsFormattedText {
    final str = _totalQuestionsCount.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  }

  String get cloudQuestionsFormattedText {
    final count = _cloudQuestionsCount >= defaultServerQuestionsCount
        ? _cloudQuestionsCount
        : defaultServerQuestionsCount;
    final str = count.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  }

  String get newQuestionsFormattedText {
    final str = newQuestionsAvailable.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  }

  Future<void> refreshQuestionCount() async {
    try {
      await CloudSyncService.ensureCacheLoaded();
      final localDownloaded = CloudSyncService.localQuestionCount;
      final customList = await StorageService.loadCustomQuestions();
      // Total soal yang benar-benar tersimpan di memori HP:
      _totalQuestionsCount = localDownloaded + customList.length;

      final savedCloudCount = await StorageService.loadLastKnownCloudCount();
      if (savedCloudCount >= defaultServerQuestionsCount) {
        _cloudQuestionsCount = savedCloudCount;
      } else {
        _cloudQuestionsCount = defaultServerQuestionsCount;
      }

      final lastSync = await StorageService.loadLastCloudSyncTime();
      if (lastSync != null) {
        _lastSyncTime = lastSync;
      }

      if (_isOnline) {
        _isCheckingCloud = true;
        notifyListeners();
        final cloudCount = await CloudSyncService.fetchTotalCloudQuestionsCount();
        if (cloudCount >= defaultServerQuestionsCount) {
          _cloudQuestionsCount = cloudCount;
          await StorageService.saveLastKnownCloudCount(cloudCount);
        }
        _isCheckingCloud = false;
      }
      notifyListeners();
    } catch (_) {
      _isCheckingCloud = false;
      notifyListeners();
    }
  }

  String get lastSyncFormattedText {
    final now = DateTime.now();
    final hh = _lastSyncTime.hour.toString().padLeft(2, '0');
    final mm = _lastSyncTime.minute.toString().padLeft(2, '0');

    if (_isSameDay(now, _lastSyncTime)) {
      return '$hh:$mm WIB';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      final monthName = months[_lastSyncTime.month - 1];
      return '${_lastSyncTime.day} $monthName, $hh:$mm WIB';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _startPinging() {
    // Initial check
    checkConnection();
    // Periodic check every 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => checkConnection());
  }

  Future<void> checkConnection() async {
    if (kIsWeb) {
      if (!_isOnline) {
        _isOnline = true;
        notifyListeners();
      }
      return;
    }
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 4));

      bool newStatus = response.statusCode == 204 || response.statusCode == 200;
      if (newStatus != _isOnline) {
        _isOnline = newStatus;
        if (_isOnline) {
          _lastSyncTime = DateTime.now();
        }
        notifyListeners();
      } else if (_isOnline) {
        // Refresh sync timestamp periodically when online
        _lastSyncTime = DateTime.now();
        notifyListeners();
      }
    } catch (_) {
      if (_isOnline != false) {
        _isOnline = false;
        notifyListeners();
      }
    }
  }

  void recordSuccessfulSync() {
    _lastSyncTime = DateTime.now();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
