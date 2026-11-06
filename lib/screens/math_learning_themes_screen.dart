import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/math_learning_data.dart';
import '../models/math_theme_model.dart';
import '../services/cloud_sync_service.dart';
import '../utils/app_colors.dart';
import 'math_topic_detail_screen.dart';

class MathLearningThemesScreen extends StatefulWidget {
  const MathLearningThemesScreen({super.key});

  @override
  State<MathLearningThemesScreen> createState() => _MathLearningThemesScreenState();
}

class _MathLearningThemesScreenState extends State<MathLearningThemesScreen> {
  final Map<String, TopicProgressStats> _progressMap = {};

  @override
  void initState() {
    super.initState();
    _loadAllProgress();
  }

  Future<void> _loadAllProgress() async {
    final themes = MathLearningData.themes;
    for (var theme in themes) {
      for (var topic in theme.topics) {
        final stats = await CloudSyncService.getTopicProgressStats(
          subject: 'Matematika',
          topic: topic.title,
        );
        _progressMap[topic.title] = stats;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final themes = MathLearningData.themes;

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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🧠 ', style: TextStyle(fontSize: 20)),
            Text(
              'Pintar Matematika SD',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A86FF), Color(0xFF8338EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8338EC).withAlpha(60),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '📐 Kurikulum Merdeka SD',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Modul Materi & Latihan Topik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Pilih Tema di bawah ini untuk belajar rumus ringkas, trik cepat, dan latihan soal!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🧠', style: TextStyle(fontSize: 36)),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.1, end: 0),

              const SizedBox(height: 24),

              const Text(
                '📚 Pilih Tema Matematika:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Theme List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  final themeColor = _hexToColor(theme.themeColorHex);

                  return _buildThemeCard(context, theme, themeColor, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, MathTheme theme, Color themeColor, int index) {
    // Calculate total questions & completed in this theme
    int themeTotal = 0;
    int themeCompleted = 0;
    for (var top in theme.topics) {
      final s = _progressMap[top.title];
      if (s != null) {
        themeTotal += s.totalQuestions;
        themeCompleted += s.completedQuestions;
      } else {
        themeTotal += 20;
      }
    }
    final themePercent = themeTotal > 0 ? (themeCompleted / themeTotal).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: themeColor.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: index == 0,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: themeColor.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(theme.iconEmoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          title: Text(
            theme.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: themeColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${theme.topics.length} Topik • $themeCompleted/$themeTotal Soal Selesai (${(themePercent * 100).toInt()}%)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: themePercent,
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      themePercent >= 1.0 ? const Color(0xFF2EC4B6) : themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Container(
              color: const Color(0xFFFAFCFF),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  ...theme.topics.asMap().entries.map((entry) {
                    final tIdx = entry.key;
                    final topic = entry.value;
                    final globalIndex = _getGlobalIndex(index, tIdx, MathLearningData.themes);
                    return _buildTopicItem(context, theme, topic, themeColor, globalIndex);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.05, end: 0);
  }

  int _getGlobalIndex(int themeIndex, int topicIndexInTheme, List<MathTheme> themes) {
    int count = 0;
    for (int i = 0; i < themeIndex; i++) {
      count += themes[i].topics.length;
    }
    return count + topicIndexInTheme;
  }

  Widget _buildTopicItem(
    BuildContext context,
    MathTheme theme,
    MathTopic topic,
    Color themeColor,
    int globalIndex,
  ) {
    final stats = _progressMap[topic.title] ??
        const TopicProgressStats(
          totalQuestions: 20,
          completedQuestions: 0,
          remainingQuestions: 20,
          progressPercent: 0.0,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: stats.isCompleted ? const Color(0xFF2EC4B6).withAlpha(100) : Colors.grey.shade200,
          width: stats.isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: stats.isCompleted
                  ? const Color(0xFF2EC4B6).withAlpha(30)
                  : themeColor.withAlpha(20),
              radius: 18,
              child: Icon(
                stats.isCompleted ? Icons.check_circle_rounded : Icons.calculate_outlined,
                color: stats.isCompleted ? const Color(0xFF2EC4B6) : themeColor,
                size: 18,
              ),
            ),
            title: Text(
              topic.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            subtitle: Text(
              topic.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: themeColor,
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MathTopicDetailScreen(
                    theme: theme,
                    topic: topic,
                  ),
                ),
              );
              // Refresh progress stats on return from quiz
              _loadAllProgress();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildBadge('📊 Total: ${stats.totalQuestions} Soal', Colors.blueGrey.shade700, Colors.blueGrey.shade50),
                    _buildBadge('✅ ${stats.completedQuestions} Dikerjakan', const Color(0xFF0F9D58), const Color(0xFFE8F8EE)),
                    if (stats.isCompleted)
                      _buildBadge('🎉 100% Tuntas ⭐', const Color(0xFFD97706), const Color(0xFFFFFBEB))
                    else
                      _buildBadge('⏳ ${stats.remainingQuestions} Belum', const Color(0xFFE65100), const Color(0xFFFFF3E0)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: stats.progressPercent,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            stats.isCompleted ? const Color(0xFF0F9D58) : themeColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(stats.progressPercent * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: stats.isCompleted ? const Color(0xFF0F9D58) : themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withAlpha(40), width: 0.8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
