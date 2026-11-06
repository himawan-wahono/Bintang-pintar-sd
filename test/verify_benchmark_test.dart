import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pintar_bersama/models/question_model.dart';

void main() {
  test('Verify bank_soal_base.json integrity', () {
    final stopwatch = Stopwatch()..start();
    final file = File('assets/data/bank_soal_base.json');
    expect(file.existsSync(), true);

    final jsonString = file.readAsStringSync();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final questionsRaw = data['questions'] as List;

    int parsedCount = 0;
    int visualCount = 0;
    final Map<String, int> subjects = {};

    for (var raw in questionsRaw) {
      final q = Question.fromJson(raw as Map<String, dynamic>);
      parsedCount++;
      if (q.visualType != null && q.visualType!.isNotEmpty) {
        visualCount++;
      }
      subjects[q.subject] = (subjects[q.subject] ?? 0) + 1;
    }
    stopwatch.stop();

    print('==================================================');
    print('🎉 VERIFIKASI BANK SOAL BASE SUKSES!');
    print('Total Soal Berhasil Diurai: $parsedCount butir');
    print('Soal dengan Diagram Visual: $visualCount butir');
    print('Distribusi Mapel: $subjects');
    print('Waktu Parsing: ${stopwatch.elapsedMilliseconds} ms');
    print('==================================================');

    expect(parsedCount, greaterThanOrEqualTo(10000));
  });
}
