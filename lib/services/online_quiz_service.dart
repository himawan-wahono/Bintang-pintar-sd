import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';
import '../utils/storage_service.dart';
import '../utils/csv_parser_service.dart';
import '../utils/word_parser_service.dart';

class OnlineQuizService {
  /// Fetches questions from an online URL (Google Sheets CSV, JSON API, or Raw Text)
  static Future<List<Question>> fetchOnlineQuestions(String url) async {
    final cleanUrl = url.trim();
    if (cleanUrl.isEmpty) {
      throw Exception('URL Online tidak boleh kosong');
    }

    final Uri uri = Uri.parse(cleanUrl);
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final body = response.body.trim();
      List<Question> fetchedQuestions = [];

      if (body.startsWith('[') || body.startsWith('{')) {
        // Parse JSON format
        final List dynamicList = jsonDecode(body);
        for (var i = 0; i < dynamicList.length; i++) {
          final item = dynamicList[i];
          if (item is Map<String, dynamic>) {
            fetchedQuestions.add(
              Question.fromJson({
                ...item,
                'id': item['id'] ?? 'online_${DateTime.now().millisecondsSinceEpoch}_$i',
                'isCustom': true,
              }),
            );
          }
        }
      } else if (body.contains(',') || body.contains('\t')) {
        // Parse CSV/Excel format from Google Sheets
        fetchedQuestions = CsvParserService.parseCsvText(body);
      } else {
        // Parse Raw Word Document Text
        fetchedQuestions = WordParserService.parseWordText(
          body,
          defaultGradeLevel: 'SD',
          defaultClassNum: 4,
          defaultSubject: 'Matematika',
        );
      }

      // Automatically persist fetched online questions to local storage
      for (var q in fetchedQuestions) {
        await StorageService.saveCustomQuestion(q);
      }

      return fetchedQuestions;
    } else {
      throw Exception('Gagal mengunduh soal online. Status: ${response.statusCode}');
    }
  }
}
