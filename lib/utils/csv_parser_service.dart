import '../models/question_model.dart';

class CsvParserService {
  static List<Question> parseCsvText(String rawText) {
    final List<Question> result = [];
    final lines = rawText.split(RegExp(r'\r?\n'));

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      // Skip header row if contains 'Jenjang' or 'Pertanyaan'
      if (i == 0 && (line.toLowerCase().contains('jenjang') || line.toLowerCase().contains('pertanyaan'))) {
        continue;
      }

      // Split by tab (\t) or comma (,)
      List<String> parts = [];
      if (line.contains('\t')) {
        parts = line.split('\t');
      } else {
        parts = _splitCsvLine(line);
      }

      if (parts.length >= 9) {
        final gradeLevel = parts[0].trim().toUpperCase() == 'SMP' ? 'SMP' : 'SD';
        final classNum = int.tryParse(parts[1].trim()) ?? (gradeLevel == 'SD' ? 4 : 7);
        final subject = parts[2].trim();
        final topic = parts[3].trim().isNotEmpty ? parts[3].trim() : 'Soal Impor Massal';
        final questionText = parts[4].trim();
        final optionA = parts[5].trim();
        final optionB = parts[6].trim();
        final optionC = parts[7].trim();
        final optionD = parts[8].trim();

        int correctIndex = 0;
        if (parts.length > 9) {
          final keyStr = parts[9].trim().toUpperCase();
          if (keyStr == 'B' || keyStr == '1') {
            correctIndex = 1;
          } else if (keyStr == 'C' || keyStr == '2') {
            correctIndex = 2;
          } else if (keyStr == 'D' || keyStr == '3') {
            correctIndex = 3;
          } else {
            correctIndex = 0;
          }
        }

        final explanation = parts.length > 10 ? parts[10].trim() : '';

        if (questionText.isNotEmpty && optionA.isNotEmpty && optionB.isNotEmpty) {
          result.add(
            Question(
              id: 'bulk_${DateTime.now().millisecondsSinceEpoch}_$i',
              gradeLevel: gradeLevel,
              classNum: classNum,
              subject: subject,
              topic: topic,
              questionText: questionText,
              options: [optionA, optionB, optionC, optionD],
              correctAnswerIndex: correctIndex,
              explanation: explanation,
              isCustom: true,
            ),
          );
        }
      }
    }

    return result;
  }

  static List<String> _splitCsvLine(String line) {
    final List<String> result = [];
    final StringBuffer sb = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(sb.toString());
        sb.clear();
      } else {
        sb.write(char);
      }
    }
    result.add(sb.toString());
    return result;
  }
}
