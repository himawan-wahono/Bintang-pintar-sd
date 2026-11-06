import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/english_theme_model.dart';
import '../services/cloud_sync_service.dart';
import '../providers/quiz_provider.dart';
import '../providers/parent_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_colors.dart';
import 'quiz_screen.dart';

class EnglishTopicDetailScreen extends StatefulWidget {
  final EnglishTheme theme;
  final EnglishTopic topic;

  const EnglishTopicDetailScreen({
    super.key,
    required this.theme,
    required this.topic,
  });

  @override
  State<EnglishTopicDetailScreen> createState() => _EnglishTopicDetailScreenState();
}

class _EnglishTopicDetailScreenState extends State<EnglishTopicDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedQuestionCount = 10;

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  TopicProgressStats? _topicStats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTopicStats();
  }

  Future<void> _loadTopicStats() async {
    final stats = await CloudSyncService.getTopicProgressStats(
      subject: 'Bahasa Inggris',
      topic: widget.topic.title,
    );
    if (mounted) {
      setState(() {
        _topicStats = stats;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startPracticeQuiz(BuildContext context) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final parentProvider = Provider.of<ParentProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Fetch questions prioritizing Database Soal with AI generator fallback (Soal bawaan jika Tamu)
    final questions = await CloudSyncService.getQuizQuestions(
      subject: 'Bahasa Inggris',
      topic: widget.topic.title,
      gradeLevel: 'SD',
      classNum: 1,
      count: _selectedQuestionCount,
      customQuestions: parentProvider.customQuestions,
      isGuest: userProvider.isGuest,
    );

    if (!context.mounted) return;

    quizProvider.startQuiz(
      questions,
      timerSeconds: parentProvider.questionTimerSeconds,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          subjectName: 'Bahasa Inggris - ${widget.topic.title}',
          gradeLevel: 'SD',
          classNum: 1,
        ),
      ),
    );
    _loadTopicStats();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _hexToColor(widget.theme.themeColorHex);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.topic.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              widget.theme.title,
              style: TextStyle(fontSize: 11, color: themeColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: themeColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: themeColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded, size: 18), text: 'Materi Pengenalan'),
            Tab(icon: Icon(Icons.edit_note_rounded, size: 18), text: 'Latihan Soal Topik'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: MATERI PENGENALAN
          _buildMateriTab(context, themeColor),

          // TAB 2: LATIHAN SOAL TOPIK
          _buildLatihanTab(context, themeColor),
        ],
      ),
    );
  }

  Widget _buildMateriTab(BuildContext context, Color themeColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ringkasan Konsep Bahasa Inggris
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.record_voice_over_rounded, color: themeColor, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Concept & Explanation 🇬🇧',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.topic.summaryContent,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.05, end: 0),

          const SizedBox(height: 16),

          // Key Phrases & Grammar Rules
          if (widget.topic.keyPhrases.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: themeColor.withAlpha(15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: themeColor.withAlpha(50), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.forum_rounded, color: themeColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Key Phrases & Vocabulary 💬',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...widget.topic.keyPhrases.map(
                    (phrase) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              phrase,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
            const SizedBox(height: 16),
          ],

          // Contoh Kalimat & Terjemahan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.teal.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.translate_rounded, color: Colors.teal, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Example Sentence & Translation 📝',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '🇬🇧 English: "${widget.topic.exampleSentence}"',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🇮🇩 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          widget.topic.exampleTranslation,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 24),

          // Tombol Mulai Latihan Soal
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
              label: const Text(
                'Lanjut ke Latihan Soal English ✍️',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                _tabController.animateTo(1);
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLatihanTab(BuildContext context, Color themeColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 10),
                Text(
                  'English Practice: ${widget.topic.title}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose how many practice questions you want to solve:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                // Topic Progress Stats Card
                if (_topicStats != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '📊 Progres Topik:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                            Text(
                              '${_topicStats!.completedQuestions} / ${_topicStats!.totalQuestions} Soal (${(_topicStats!.progressPercent * 100).toInt()}%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _topicStats!.isCompleted ? const Color(0xFF0F9D58) : themeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _topicStats!.progressPercent,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _topicStats!.isCompleted ? const Color(0xFF0F9D58) : themeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '✅ Selesai: ${_topicStats!.completedQuestions}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF0F9D58), fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _topicStats!.isCompleted ? '🎉 Tuntas 100%' : '⏳ Belum: ${_topicStats!.remainingQuestions}',
                              style: TextStyle(
                                fontSize: 11,
                                color: _topicStats!.isCompleted ? const Color(0xFFD97706) : const Color(0xFFE65100),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Question Count Choice Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [5, 10, 15, 20].map((count) {
                    final isSelected = _selectedQuestionCount == count;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedQuestionCount = count;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? themeColor : themeColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? themeColor : themeColor.withAlpha(40),
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: themeColor.withAlpha(60),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isSelected ? Colors.white : themeColor,
                              ),
                            ),
                            Text(
                              'Questions',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Start Quiz Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 24),
                    label: Text(
                      'Start Practice $_selectedQuestionCount Questions 🚀',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPressed: () => _startPracticeQuiz(context),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }
}
