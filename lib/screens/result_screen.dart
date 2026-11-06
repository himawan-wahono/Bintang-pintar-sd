import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/quiz_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/parent_provider.dart';
import '../providers/user_provider.dart';
import '../services/cloud_sync_service.dart';
import '../utils/app_colors.dart';
import 'quiz_screen.dart';
import 'review_screen.dart';

class ResultScreen extends StatefulWidget {
  final String subjectName;
  final String gradeLevel;
  final int classNum;

  const ResultScreen({
    super.key,
    required this.subjectName,
    required this.gradeLevel,
    required this.classNum,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _recorded = false;
  bool _isRestarting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_recorded) {
        final quizProvider = Provider.of<QuizProvider>(context, listen: false);
        final statsProvider = Provider.of<StatsProvider>(context, listen: false);
        statsProvider.recordQuizResult(
          correctCount: quizProvider.correctAnswersCount,
          totalQuestions: quizProvider.totalQuestions,
          starsEarned: quizProvider.starsEarned,
          levelNumber: widget.classNum,
        );
        // Record completed question IDs for topic progress tracking
        CloudSyncService.recordCompletedQuizQuestions(quizProvider.questions);
        _recorded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final stars = quizProvider.starsEarned;
    final correct = quizProvider.correctAnswersCount;
    final total = quizProvider.totalQuestions;
    final xpEarned = (correct * 20) + (stars * 15);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Celebration Icon / Trophy
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text('🏆', style: TextStyle(fontSize: 64)),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

              const SizedBox(height: 20),

              const Text(
                'Kuis Selesai! 🎉',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Mata Pelajaran ${widget.subjectName} (Kelas ${widget.classNum} ${widget.gradeLevel})',
                style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),

              const SizedBox(height: 24),

              // Star Rating Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isEarned = index < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Icon(
                      Icons.star,
                      size: 48,
                      color: isEarned ? AppColors.accentYellow : Colors.grey.shade300,
                    ),
                  );
                }),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 28),

              // Score Summary Card
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Jawaban Benar', '$correct / $total', Icons.check_circle, AppColors.successGreen),
                    Container(width: 1, height: 40, color: Colors.grey.shade200),
                    _buildStatItem('Total XP', '+$xpEarned XP', Icons.bolt, AppColors.primaryCyan),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Action Buttons
              // Play Again / Restart Quiz Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isRestarting
                      ? null
                      : () async {
                          setState(() {
                            _isRestarting = true;
                          });

                          try {
                            final parentProvider = Provider.of<ParentProvider>(context, listen: false);
                            final quizProvider = Provider.of<QuizProvider>(context, listen: false);

                            String subject = 'Matematika';
                            String topic = widget.subjectName;

                            if (widget.gradeLevel == 'English' || widget.subjectName.toLowerCase().contains('inggris')) {
                              subject = 'Bahasa Inggris';
                            }

                            if (widget.subjectName.contains(' - ')) {
                              final parts = widget.subjectName.split(' - ');
                              if (parts.isNotEmpty) {
                                if (parts[0].toLowerCase().contains('inggris')) {
                                  subject = 'Bahasa Inggris';
                                } else if (parts[0].toLowerCase().contains('matematika')) {
                                  subject = 'Matematika';
                                }
                                topic = parts.sublist(1).join(' - ').trim();
                              }
                            }

                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            final newSet = await CloudSyncService.getQuizQuestions(
                              subject: subject,
                              topic: topic,
                              gradeLevel: widget.gradeLevel,
                              classNum: widget.classNum,
                              count: 10,
                              customQuestions: parentProvider.customQuestions,
                              isGuest: userProvider.isGuest,
                            );

                            if (!context.mounted) return;

                            quizProvider.startQuiz(newSet, timerSeconds: parentProvider.questionTimerSeconds);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  subjectName: widget.subjectName,
                                  gradeLevel: widget.gradeLevel,
                                  classNum: widget.classNum,
                                ),
                              ),
                            );
                          } catch (e) {
                            debugPrint('Error restarting quiz: $e');
                            if (mounted) {
                              setState(() {
                                _isRestarting = false;
                              });
                            }
                          }
                        },
                  icon: _isRestarting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.replay_rounded, color: Colors.white),
                  label: Text(
                    _isRestarting ? 'Menyiapkan Kuis Baru...' : 'Main Lagi / Kuis Baru 🔄',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewScreen(
                          questions: quizProvider.questions,
                          userAnswers: quizProvider.userAnswers,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book, color: Colors.white),
                  label: const Text(
                    'Lihat Pembahasan Soal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home, color: AppColors.textDark),
                  label: const Text(
                    'Kembali ke Beranda Utama',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textDark, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
