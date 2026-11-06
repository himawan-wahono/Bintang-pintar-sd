import 'package:flutter_test/flutter_test.dart';
import 'package:pintar_bersama/services/ai_english_generator_service.dart';

void main() {
  group('AiEnglishGeneratorService Reading Tests', () {
    test('Descriptive Paragraph Reading generates reading passages and not landmarks', () {
      final questions = AiEnglishGeneratorService.generateDynamicEnglishQuestions(
        gradeLevel: 'SD',
        classNum: 1,
        count: 10,
        topic: 'Descriptive Paragraph Reading',
      );

      expect(questions.length, 10);
      for (var q in questions) {
        expect(q.visualType, 'english_reading_passage');
        expect(q.visualData, isNotNull);
        expect(q.visualData!['storyTitle'], isNotNull);
        expect(q.visualData!['storyText'], isNotNull);
        expect((q.visualData!['storyText'] as String).length, greaterThan(100));
        // Must NOT contain landmark questions
        expect(q.questionText.contains('Monas'), isFalse);
        expect(q.questionText.contains('Big Ben'), isFalse);
      }
    });

    test('Bahasa Inggris - Descriptive Paragraph Reading (from QuizScreen) routes to reading', () {
      final questions = AiEnglishGeneratorService.generateDynamicEnglishQuestions(
        gradeLevel: 'SD',
        classNum: 1,
        count: 10,
        topic: 'Bahasa Inggris - Descriptive Paragraph Reading',
      );

      expect(questions.length, 10);
      for (var q in questions) {
        expect(q.visualType, 'english_reading_passage');
        expect(q.visualData!['storyTitle'], isNotNull);
        expect((q.visualData!['storyText'] as String).length, greaterThan(100));
        expect(q.questionText.contains('Monas'), isFalse);
      }
    });

    test('World Culture & Landmark Passports routes to landmarks', () {
      final questions = AiEnglishGeneratorService.generateDynamicEnglishQuestions(
        gradeLevel: 'SD',
        classNum: 1,
        count: 8,
        topic: 'World Culture & Landmark Passports',
      );

      expect(questions.length, 8);
      for (var q in questions) {
        expect(q.visualType, isNot('english_reading_passage'));
        expect(q.visualData!['title'], contains('World Culture'));
      }
    });

    test('Asking & Offering Help does NOT generate reading passage and produces polite dialogue', () {
      final questions = AiEnglishGeneratorService.generateDynamicEnglishQuestions(
        gradeLevel: 'SD',
        classNum: 1,
        count: 5,
        topic: 'Bahasa Inggris - Asking & Offering Help - Kelas 1 SD',
      );

      expect(questions.length, 5);
      for (var q in questions) {
        expect(q.visualType, isNot('english_reading_passage'));
        expect(q.visualData!['title'], 'Asking & Offering Help');
      }
    });
  });
}
