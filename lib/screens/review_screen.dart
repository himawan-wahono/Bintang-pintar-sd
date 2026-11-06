import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../widgets/question_visual_widget.dart';
import '../utils/app_colors.dart';

class ReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int?> userAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    this.userAnswers = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: const Text(
          'Pembahasan Soal Lengkap 📖',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: questions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final q = questions[index];
            final correctOption = q.options[q.correctAnswerIndex];
            final userAnswerIndex = userAnswers[index];
            final isAnswered = userAnswerIndex != null;
            final isCorrect = isAnswered && userAnswerIndex == q.correctAnswerIndex;

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isCorrect ? Colors.green : Colors.red).withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Badges (Soal Number + Topic + Status Badge)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Soal #${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryCyan,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${q.subject} • ${q.topic}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Status Badge (🟢 Benar / 🔴 Salah / 🔴 ⏱️ Waktu Habis)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isCorrect ? '🟢 Benar' : (isAnswered ? '🔴 Salah' : '🔴 ⏱️ Waktu Habis (Salah)'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Question Visual Widget if any
                  QuestionVisualWidget(question: q),

                  // Question Text
                  Text(
                    q.questionText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // All Options List with Red/Green Highlights
                  Column(
                    children: List.generate(q.options.length, (optIdx) {
                      final optionText = q.options[optIdx];
                      final isOptionCorrect = optIdx == q.correctAnswerIndex;
                      final isUserSelected = optIdx == userAnswerIndex;
                      final optLetter = String.fromCharCode(65 + optIdx);

                      Color bgColor = Colors.grey.shade50;
                      Color borderColor = Colors.grey.shade200;
                      Color textColor = AppColors.textDark;
                      Widget? badgeIcon;

                      if (isOptionCorrect) {
                        bgColor = Colors.green.shade50;
                        borderColor = Colors.green.shade400;
                        textColor = Colors.green.shade900;
                        badgeIcon = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(' (Jawaban Benar)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                          ],
                        );
                      } else if (isUserSelected && !isOptionCorrect) {
                        // Tanda Merah untuk Jawaban Salah User 🔴
                        bgColor = Colors.red.shade50;
                        borderColor = Colors.red.shade400;
                        textColor = Colors.red.shade900;
                        badgeIcon = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(' (Jawaban Kamu - Salah)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                            const SizedBox(width: 4),
                            const Icon(Icons.cancel_rounded, color: Colors.red, size: 16),
                          ],
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor, width: (isOptionCorrect || isUserSelected) ? 1.5 : 1.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$optLetter. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isOptionCorrect
                                    ? Colors.green.shade900
                                    : (isUserSelected ? Colors.red.shade900 : Colors.grey.shade700),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                optionText,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: (isOptionCorrect || isUserSelected) ? FontWeight.bold : FontWeight.normal,
                                  color: textColor,
                                ),
                              ),
                            ),
                            ?badgeIcon,
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  // Result Status Summary Card (Green for Correct, RED for Wrong/Timeout)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCorrect) ...[
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Jawaban Kamu Benar! 🟢 ($correctOption)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (isAnswered) ...[
                          // TANDA MERAH JAWABAN SALAH 🔴
                          Row(
                            children: [
                              const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Jawaban Kamu: ${q.options[userAnswerIndex]} (Salah ❌)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Kunci Jawaban Benar: $correctOption',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // WAKTU HABIS / TIDAK DIJAWAB -> DIANGGAP SALAH 🔴
                          Row(
                            children: [
                              const Icon(Icons.timer_off_rounded, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Waktu Habis! Belum Mengisi Jawaban (Dianggap Salah 🔴)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Kunci Jawaban Benar: $correctOption',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pembahasan Explanation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withAlpha(60),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 16)),
                            Text(
                              'Pembahasan:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          q.explanation.isNotEmpty ? q.explanation : 'Jawaban yang tepat adalah $correctOption.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
