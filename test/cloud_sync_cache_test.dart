import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pintar_bersama/models/question_model.dart';
import 'package:pintar_bersama/utils/storage_service.dart';
import 'package:pintar_bersama/services/cloud_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CloudSyncService & StorageService 1000 Question Cache Tests', () {
    test('saveCachedCloudQuestions and loadCachedCloudQuestions roundtrip works', () async {
      final sampleQuestions = [
        Question(
          id: 'test_1',
          gradeLevel: 'SD',
          classNum: 4,
          subject: 'Matematika',
          topic: 'Pecahan, Desimal, dan Persen',
          level: 'Sedang',
          questionText: 'Berapa 1/2 dalam bentuk desimal?',
          options: ['0.5', '0.25', '0.75', '1.0'],
          correctAnswerIndex: 0,
          explanation: '1 dibagi 2 adalah 0.5',
        ),
        Question(
          id: 'test_2',
          gradeLevel: 'SD',
          classNum: 4,
          subject: 'Matematika',
          topic: 'Pola Bilangan',
          level: 'Sedang',
          questionText: '2, 4, 6, ... angka berikutnya adalah?',
          options: ['8', '10', '12', '7'],
          correctAnswerIndex: 0,
          explanation: 'Pola kelipatan 2',
        ),
        Question(
          id: 'test_3',
          gradeLevel: 'SD',
          classNum: 4,
          subject: 'Matematika',
          topic: 'Pengenalan Pola Gambar dan Bentuk',
          level: 'Sedang',
          questionText: 'Pola segitiga, lingkaran, segitiga, ...?',
          options: ['Lingkaran', 'Kotak', 'Bintang', 'Persegi'],
          correctAnswerIndex: 0,
          explanation: 'Pola bergantian bentuk',
        ),
      ];

      await StorageService.saveCachedCloudQuestions(sampleQuestions);
      final loaded = await StorageService.loadCachedCloudQuestions();

      expect(loaded.length, equals(3));
      expect(loaded[0].id, equals('test_1'));
      expect(loaded[1].topic, equals('Pola Bilangan'));
      expect(loaded[2].topic, equals('Pengenalan Pola Gambar dan Bentuk'));
    });

    test('Strict topic matching does NOT mix Pola Bilangan with Pengenalan Pola Gambar', () async {
      final sampleQuestions = [
        Question(
          id: 'pola_bil_1',
          gradeLevel: 'SD',
          classNum: 4,
          subject: 'Matematika',
          topic: 'Pola Bilangan',
          level: 'Sedang',
          questionText: 'Soal Pola Bilangan 1',
          options: ['A', 'B', 'C', 'D'],
          correctAnswerIndex: 0,
          explanation: '',
        ),
        Question(
          id: 'pola_gbr_1',
          gradeLevel: 'SD',
          classNum: 4,
          subject: 'Matematika',
          topic: 'Pengenalan Pola Gambar dan Bentuk',
          level: 'Sedang',
          questionText: 'Soal Pola Gambar 1',
          options: ['A', 'B', 'C', 'D'],
          correctAnswerIndex: 0,
          explanation: '',
        ),
      ];

      await StorageService.saveCachedCloudQuestions(sampleQuestions);
      await CloudSyncService.ensureCacheLoaded();

      // Request quiz specifically for "Pola Bilangan"
      final quizQuestions = await CloudSyncService.getQuizQuestions(
        subject: 'Matematika',
        topic: 'Pola Bilangan',
        gradeLevel: 'SD',
        classNum: 4,
        count: 10,
      );

      // Verify that "Soal Pola Gambar 1" is NEVER included
      expect(quizQuestions.any((q) => q.id == 'pola_gbr_1'), isFalse);
      // Verify that "pola_bil_1" is included
      expect(quizQuestions.any((q) => q.id == 'pola_bil_1'), isTrue);
      // Verify total count is 10 (padded by math generator)
      expect(quizQuestions.length, equals(10));
    });

    test('getQuizQuestions supports 20 questions requested count', () async {
      final quizQuestions20 = await CloudSyncService.getQuizQuestions(
        subject: 'Matematika',
        topic: 'Penjumlahan & Pengurangan Dasar',
        gradeLevel: 'SD',
        classNum: 2,
        count: 20,
      );

      expect(quizQuestions20.length, equals(20));
      for (var q in quizQuestions20) {
        expect(q.options.length, greaterThanOrEqualTo(4));
        expect(q.questionText.isNotEmpty, isTrue);
      }
    });
  });
}
