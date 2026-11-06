import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pintar_bersama/models/question_model.dart';
import 'package:pintar_bersama/utils/storage_service.dart';
import 'package:pintar_bersama/services/cloud_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CloudSyncService.ensureCacheLoaded(forceReload: true);
  });

  group('Topic Progress Storage Tests', () {
    test('loadAnsweredQuestionIds returns empty set initially', () async {
      final answered = await StorageService.loadAnsweredQuestionIds('Pola Bilangan');
      expect(answered, isEmpty);
    });

    test('recordAnsweredQuestionIds saves unique question IDs without duplicates', () async {
      const topic = 'Phonics, Alphabet & Basic Vocabulary';
      await StorageService.recordAnsweredQuestionIds(
        topic: topic,
        questionIds: ['q1', 'q2', 'q3'],
      );

      var answered = await StorageService.loadAnsweredQuestionIds(topic);
      expect(answered.length, equals(3));
      expect(answered.contains('q1'), isTrue);
      expect(answered.contains('q2'), isTrue);
      expect(answered.contains('q3'), isTrue);

      // Add duplicate q2 and new q4
      await StorageService.recordAnsweredQuestionIds(
        topic: topic,
        questionIds: ['q2', 'q4'],
      );

      answered = await StorageService.loadAnsweredQuestionIds(topic);
      expect(answered.length, equals(4));
      expect(answered.contains('q4'), isTrue);
    });

    test('resetTopicProgress clears the saved question IDs for that topic', () async {
      const topic = 'Numbers, Colors & Shapes';
      await StorageService.recordAnsweredQuestionIds(
        topic: topic,
        questionIds: ['num1', 'num2'],
      );
      expect((await StorageService.loadAnsweredQuestionIds(topic)).length, equals(2));

      await StorageService.resetTopicProgress(topic);
      expect((await StorageService.loadAnsweredQuestionIds(topic)), isEmpty);
    });
  });

  group('CloudSyncService Topic Progress Stats Tests', () {
    test('Calculates total, completed, remaining, and percentage correctly with cached questions', () async {
      const topic = 'Penjumlahan dan Pengurangan';
      final List<Question> sampleQuestions = [
        Question(
          id: 'math_q1',
          gradeLevel: 'SD',
          classNum: 1,
          questionText: '10 + 5 = ?',
          options: ['12', '15', '18', '20'],
          correctAnswerIndex: 1,
          explanation: '10 + 5 = 15',
          subject: 'Matematika',
          topic: topic,
        ),
        Question(
          id: 'math_q2',
          gradeLevel: 'SD',
          classNum: 1,
          questionText: '20 - 7 = ?',
          options: ['11', '12', '13', '14'],
          correctAnswerIndex: 2,
          explanation: '20 - 7 = 13',
          subject: 'Matematika',
          topic: topic,
        ),
        Question(
          id: 'math_q3',
          gradeLevel: 'SD',
          classNum: 1,
          questionText: '50 + 50 = ?',
          options: ['100', '90', '80', '110'],
          correctAnswerIndex: 0,
          explanation: '50 + 50 = 100',
          subject: 'Matematika',
          topic: topic,
        ),
      ];

      await StorageService.saveCachedCloudQuestions(sampleQuestions);
      await CloudSyncService.ensureCacheLoaded(forceReload: true);

      // Record 1 question answered
      await StorageService.recordAnsweredQuestionIds(
        topic: topic,
        questionIds: ['math_q1'],
      );

      final stats = await CloudSyncService.getTopicProgressStats(
        subject: 'Matematika',
        topic: topic,
      );

      expect(stats.totalQuestions, equals(3));
      expect(stats.completedQuestions, equals(1));
      expect(stats.remainingQuestions, equals(2));
      expect(stats.progressPercent, closeTo(1 / 3, 0.01));
      expect(stats.isCompleted, isFalse);

      // Record remaining 2 questions
      await StorageService.recordAnsweredQuestionIds(
        topic: topic,
        questionIds: ['math_q2', 'math_q3'],
      );

      final updatedStats = await CloudSyncService.getTopicProgressStats(
        subject: 'Matematika',
        topic: topic,
      );

      expect(updatedStats.completedQuestions, equals(3));
      expect(updatedStats.remainingQuestions, equals(0));
      expect(updatedStats.progressPercent, equals(1.0));
      expect(updatedStats.isCompleted, isTrue);
    });

    test('recordCompletedQuizQuestions automatically groups and records questions by topic', () async {
      final List<Question> quizQuestions = [
        Question(
          id: 'eng_1',
          gradeLevel: 'SD',
          classNum: 1,
          questionText: 'What is A for?',
          options: ['Apple', 'Cat', 'Dog', 'Elephant'],
          correctAnswerIndex: 0,
          explanation: 'A is for Apple',
          subject: 'Bahasa Inggris',
          topic: 'Phonics, Alphabet & Basic Vocabulary',
        ),
        Question(
          id: 'math_1',
          gradeLevel: 'SD',
          classNum: 1,
          questionText: 'Berapa sisi segitiga?',
          options: ['3', '4', '5', '6'],
          correctAnswerIndex: 0,
          explanation: 'Segitiga memiliki 3 sisi',
          subject: 'Matematika',
          topic: 'Bangun Datar dan Bangun Ruang',
        ),
      ];

      await CloudSyncService.recordCompletedQuizQuestions(quizQuestions);

      final engAnswered = await StorageService.loadAnsweredQuestionIds('Phonics, Alphabet & Basic Vocabulary');
      expect(engAnswered.contains('eng_1'), isTrue);

      final mathAnswered = await StorageService.loadAnsweredQuestionIds('Bangun Datar dan Bangun Ruang');
      expect(mathAnswered.contains('math_1'), isTrue);
    });

    test('getQuizQuestions prioritizes unattempted questions before attempted questions', () async {
      const topic = 'Pecahan dan Desimal';
      final List<Question> questions = List.generate(
        10,
        (i) => Question(
          id: 'pecahan_$i',
          gradeLevel: 'SD',
          classNum: 4,
          questionText: 'Soal Pecahan ke-$i',
          options: ['A', 'B', 'C', 'D'],
          correctAnswerIndex: 0,
          explanation: 'Penjelasan $i',
          subject: 'Matematika',
          topic: topic,
        ),
      );

      await StorageService.saveCachedCloudQuestions(questions);
      await CloudSyncService.ensureCacheLoaded(forceReload: true);

      // Mark pecahan_0 through pecahan_6 as attempted
      await StorageService.recordAnsweredQuestionIds(
        topic: topic,
        questionIds: ['pecahan_0', 'pecahan_1', 'pecahan_2', 'pecahan_3', 'pecahan_4', 'pecahan_5', 'pecahan_6'],
      );

      // Request 3 questions for quiz
      final quiz = await CloudSyncService.getQuizQuestions(
        subject: 'Matematika',
        topic: topic,
        gradeLevel: 'SD',
        classNum: 4,
        count: 3,
      );

      expect(quiz.length, equals(3));
      // Since pecahan_7, pecahan_8, pecahan_9 are unattempted, they MUST all be selected first!
      final unattemptedIds = {'pecahan_7', 'pecahan_8', 'pecahan_9'};
      for (var q in quiz) {
        expect(unattemptedIds.contains(q.id), isTrue);
      }
    });
  });
}
