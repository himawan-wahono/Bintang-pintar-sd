import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/quiz_provider.dart';
import '../widgets/option_card.dart';
import '../widgets/timer_badge.dart';
import '../widgets/combo_indicator.dart';
import '../widgets/question_visual_widget.dart';
import '../utils/app_colors.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subjectName;
  final String gradeLevel;
  final int classNum;

  const QuizScreen({
    super.key,
    required this.subjectName,
    required this.gradeLevel,
    required this.classNum,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _navigatedToResult = false;

  void _navigateToResult() {
    if (_navigatedToResult || !mounted) return;
    _navigatedToResult = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          subjectName: widget.subjectName,
          gradeLevel: widget.gradeLevel,
          classNum: widget.classNum,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final question = quizProvider.currentQuestion;

    if (quizProvider.isQuizFinished || question == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToResult();
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double progress = quizProvider.totalQuestions > 0
        ? (quizProvider.currentIndex / quizProvider.totalQuestions).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('${widget.subjectName} - Kelas ${widget.classNum} ${widget.gradeLevel}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        actions: [
          // Lifeline Hint Button
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: quizProvider.isAnswered ? null : () => quizProvider.useHint(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentYellow, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Hint (${quizProvider.coins})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Question Progress & Timer & Combo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soal ${quizProvider.currentIndex + 1} / ${quizProvider.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  ComboIndicator(streak: quizProvider.comboStreak),
                  if (quizProvider.timerDuration > 0)
                    TimerBadge(timeLeft: quizProvider.timeLeft)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.successGreen, width: 1.5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.all_inclusive, color: AppColors.successGreen, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Santai',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Linear Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryCyan),
                ),
              ),
              const SizedBox(height: 14),

              // Scrollable Quiz Body (Question Card + Option Cards + Next Button)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Text & Image Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question Level Badge (🟢 Dasar, 🟡 Sedang, 🔴 HOTS)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: question.level == 'HOTS'
                                    ? Colors.red.shade50
                                    : question.level == 'Sedang'
                                        ? Colors.amber.shade50
                                        : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: question.level == 'HOTS'
                                      ? Colors.red.shade300
                                      : question.level == 'Sedang'
                                          ? Colors.amber.shade400
                                          : Colors.green.shade400,
                                ),
                              ),
                              child: Text(
                                question.level == 'HOTS'
                                    ? '🔴 Level: HOTS / Tantangan'
                                    : question.level == 'Sedang'
                                        ? '🟡 Level: Sedang'
                                        : '🟢 Level: Dasar',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: question.level == 'HOTS'
                                      ? Colors.red.shade700
                                      : question.level == 'Sedang'
                                          ? Colors.amber.shade900
                                          : Colors.green.shade700,
                                ),
                              ),
                            ),

                            // Render Dynamic Vector Diagram or CDN Image Visual
                            QuestionVisualWidget(question: question),
                            Text(
                              question.questionText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 16),

                      // Options List
                      ...question.options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final optionText = entry.value;
                        final isSelected = quizProvider.selectedOptionIndex == index;
                        final isCorrect = index == question.correctAnswerIndex;
                        final isHidden = quizProvider.hiddenOptionIndices.contains(index);

                        return OptionCard(
                          optionText: optionText,
                          index: index,
                          isSelected: isSelected,
                          isAnswered: quizProvider.isAnswered,
                          isCorrect: isCorrect,
                          isHidden: isHidden,
                          onTap: () {
                            quizProvider.selectOption(index);
                          },
                        );
                      }),

                      // Red Timeout Warning Banner if answered due to timeout
                      if (quizProvider.isAnswered && quizProvider.selectedOptionIndex == null)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10, bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer_off_rounded, color: Colors.red, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '⏰ Waktu Habis! Belum memilih jawaban (Dianggap SALAH 🔴)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(),

                      // Next Button (Shows when answered)
                      if (quizProvider.isAnswered)
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0, bottom: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _navigatedToResult
                                  ? null
                                  : () {
                                      quizProvider.nextQuestion();
                                      if (quizProvider.isQuizFinished) {
                                        _navigateToResult();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryCyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                quizProvider.currentIndex + 1 < quizProvider.totalQuestions
                                    ? 'Lanjut Soal Berikutnya ➔'
                                    : 'Lihat Hasil Kuis 🏆',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
