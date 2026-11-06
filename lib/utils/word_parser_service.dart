import '../models/question_model.dart';

class WordParserService {
  /// Parses raw text copy-pasted from Word, PDF, or TXT documents
  /// Supports numbered questions (1. 2. 3.) and bulleted/lettered options (a. b. c. d. or • a. • b.)
  static List<Question> parseWordText(
    String rawText, {
    required String defaultGradeLevel,
    required int defaultClassNum,
    required String defaultSubject,
  }) {
    final List<Question> questions = [];
    final lines = rawText.split(RegExp(r'\r?\n'));

    String currentQuestionText = '';
    final List<String> currentOptions = [];
    int currentKeyIndex = 0;

    void saveCurrentQuestion() {
      if (currentQuestionText.trim().isNotEmpty && currentOptions.length >= 2) {
        // Pad options to 4 if less than 4
        while (currentOptions.length < 4) {
          currentOptions.add('-');
        }

        // Clean up LaTeX formatting (e.g. $85 + 34 - 27$ -> 85 + 34 - 27, \square -> [ ? ])
        String cleanQuestionText = currentQuestionText.trim()
            .replaceAll('\$', '')
            .replaceAll(r'\square', '[ ? ]');

        questions.add(
          Question(
            id: 'word_${DateTime.now().millisecondsSinceEpoch}_${questions.length}',
            gradeLevel: defaultGradeLevel,
            classNum: defaultClassNum,
            subject: defaultSubject,
            topic: 'Hasil Impor Word',
            questionText: cleanQuestionText,
            options: List.from(currentOptions.take(4)),
            correctAnswerIndex: currentKeyIndex,
            explanation: 'Soal diimpor otomatis dari dokumen Word/PDF.',
            isCustom: true,
          ),
        );
      }
      currentQuestionText = '';
      currentOptions.clear();
      currentKeyIndex = 0;
    }

    for (var i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty) continue;

      // Remove bullet points like '•', '-', '*' at line start
      line = line.replaceAll(RegExp(r'^[•\-\*]\s*'), '').trim();

      // Check if line starts with question number: e.g. "1.", "2)", "Soal 1:"
      final isQuestionStart = RegExp(r'^(\d+)[\.\)]\s+').hasMatch(line) ||
          RegExp(r'^Soal\s+\d+[:\.]?', caseSensitive: false).hasMatch(line);

      // Check if line starts with option letter: e.g. "a.", "b)", "A."
      final isOptionLine = RegExp(r'^[a-dA-D][\.\)]\s+').hasMatch(line);

      if (isQuestionStart) {
        // Save previous question before starting new one
        saveCurrentQuestion();

        // Strip question number prefix: "1. Hasil dari..." -> "Hasil dari..."
        currentQuestionText = line.replaceAll(RegExp(r'^(\d+)[\.\)]\s+'), '')
            .replaceAll(RegExp(r'^Soal\s+\d+[:\.]?\s*', caseSensitive: false), '')
            .trim();
      } else if (isOptionLine) {
        // Strip option letter prefix: "a. 82" -> "82"
        final optionText = line.replaceAll(RegExp(r'^[a-dA-D][\.\)]\s+'), '').trim();
        currentOptions.add(optionText);
      } else {
        // Continuation line for current question or explanation
        if (currentOptions.isEmpty) {
          if (currentQuestionText.isNotEmpty) {
            currentQuestionText += ' $line';
          } else {
            currentQuestionText = line;
          }
        }
      }
    }

    // Save final question in document
    saveCurrentQuestion();

    return questions;
  }
}
