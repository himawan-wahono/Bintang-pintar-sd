import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../data/question_bank.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _correctAnswersCount = 0;
  int _comboStreak = 0;
  int _maxCombo = 0;
  int _coins = 3; // Lifeline Coins

  // Timer
  Timer? _timer;
  int _timerDuration = 30;
  int _timeLeft = 30; // seconds per question
  bool _isTimerActive = false;

  // Options hidden by 50/50 hint
  List<int> _hiddenOptionIndices = [];

  // Track user selected answers per question index
  final Map<int, int?> _userAnswers = {};

  // Getters
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  Question? get currentQuestion =>
      (_currentIndex >= 0 && _currentIndex < _questions.length)
          ? _questions[_currentIndex]
          : null;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool get isAnswered => _isAnswered;
  int get correctAnswersCount => _correctAnswersCount;
  int get comboStreak => _comboStreak;
  int get maxCombo => _maxCombo;
  int get coins => _coins;
  int get timerDuration => _timerDuration;
  int get timeLeft => _timeLeft;
  bool get isTimerActive => _isTimerActive;
  List<int> get hiddenOptionIndices => _hiddenOptionIndices;
  Map<int, int?> get userAnswers => Map.unmodifiable(_userAnswers);
  bool get isQuizFinished => _currentIndex >= _questions.length;
  int get totalQuestions => _questions.length;

  int get starsEarned {
    if (totalQuestions == 0) return 0;
    double percentage = (_correctAnswersCount / totalQuestions) * 100;
    if (percentage >= 80) return 3;
    if (percentage >= 60) return 2;
    if (percentage >= 40) return 1;
    return 0;
  }

  void startQuiz(List<Question> questionsList, {int timerSeconds = 0}) {
    _timerDuration = timerSeconds;
    if (questionsList.isEmpty) {
      _questions = List.from(QuestionBank.initialQuestions.take(5));
    } else {
      _questions = List.from(questionsList);
    }
    _currentIndex = 0;
    _selectedOptionIndex = null;
    _isAnswered = false;
    _correctAnswersCount = 0;
    _comboStreak = 0;
    _maxCombo = 0;
    _hiddenOptionIndices = [];
    _userAnswers.clear();
    _startTimer();
    notifyListeners();
  }

  void selectOption(int index) {
    if (_isAnswered || _hiddenOptionIndices.contains(index)) return;
    _stopTimer();
    _selectedOptionIndex = index;
    _userAnswers[_currentIndex] = index;
    _isAnswered = true;

    if (currentQuestion != null && index == currentQuestion!.correctAnswerIndex) {
      _correctAnswersCount++;
      _comboStreak++;
      if (_comboStreak > _maxCombo) {
        _maxCombo = _comboStreak;
      }
    } else {
      _comboStreak = 0;
    }

    notifyListeners();
  }

  void nextQuestion() {
    _stopTimer();
    _currentIndex++;
    _selectedOptionIndex = null;
    _isAnswered = false;
    _hiddenOptionIndices = [];
    if (!isQuizFinished) {
      _startTimer();
    }
    notifyListeners();
  }

  void useHint() {
    if (_isAnswered || _coins <= 0 || currentQuestion == null) return;
    _coins--;
    final correctIndex = currentQuestion!.correctAnswerIndex;
    final List<int> wrongIndices = [];
    for (int i = 0; i < currentQuestion!.options.length; i++) {
      if (i != correctIndex) {
        wrongIndices.add(i);
      }
    }
    wrongIndices.shuffle();
    // Hide 2 wrong options
    _hiddenOptionIndices = wrongIndices.take(2).toList();
    notifyListeners();
  }

  void _startTimer() {
    _stopTimer();
    if (_timerDuration <= 0) {
      _timeLeft = 0;
      _isTimerActive = false;
      return;
    }
    _timeLeft = _timerDuration;
    _isTimerActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        // Time out
        _stopTimer();
        _isAnswered = true;
        _comboStreak = 0;
        _userAnswers[_currentIndex] = null;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerActive = false;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
