import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../data/question_bank.dart';
import '../providers/parent_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../services/cloud_sync_service.dart';
import '../utils/app_colors.dart';
import 'quiz_screen.dart';

class MathThemeData {
  final String title;
  final IconData icon;
  final Color color;
  final List<MathTopicData> topics;

  MathThemeData({
    required this.title,
    required this.icon,
    required this.color,
    required this.topics,
  });
}

class MathTopicData {
  final String title;
  final String description;

  MathTopicData({
    required this.title,
    required this.description,
  });
}

class SubjectScreen extends StatefulWidget {
  final String gradeLevel;
  final int classNum;

  const SubjectScreen({
    super.key,
    this.gradeLevel = 'Umum',
    this.classNum = 1,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  MathThemeData? _selectedTheme;

  final List<MathThemeData> _mathThemes = [
    MathThemeData(
      title: 'Bilangan dan Operasi Hitung',
      icon: Icons.calculate,
      color: AppColors.mathColor,
      topics: [
        MathTopicData(
          title: 'Pengenalan Bilangan dan Nilai Tempat',
          description: 'Membaca, menulis, dan mengurutkan lambang bilangan (puluhan, ratusan, hingga ribuan)',
        ),
        MathTopicData(
          title: 'Penjumlahan & Pengurangan Dasar',
          description: 'Operasi hitung dasar bilangan cacah (angka di bawah 20 hingga ratusan/ribuan)',
        ),
        MathTopicData(
          title: 'Perkalian & Pembagian',
          description: 'Penjumlahan berulang, pembagian sebagai pengurangan berulang, & KABATAKU',
        ),
        MathTopicData(
          title: 'Pecahan, Desimal, dan Persen',
          description: 'Pecahan sederhana (1/2, 1/4), pecahan senilai, desimal, & persen',
        ),
        MathTopicData(
          title: 'Kelipatan dan Faktor (KPK & FPB)',
          description: 'Bilangan prima, pohon faktor, KPK (Kelipatan) & FPB (Faktor)',
        ),
        MathTopicData(
          title: 'Bilangan Bulat Negatif',
          description: 'Mengenal konsep bilangan di bawah nol menggunakan garis bilangan',
        ),
      ],
    ),
    MathThemeData(
      title: 'Geometri',
      icon: Icons.category,
      color: const Color(0xFF9C27B0),
      topics: [
        MathTopicData(
          title: 'Pengenalan Bentuk dan Sifat Dasar',
          description: 'Bangun datar (segiempat, segitiga, lingkaran), bangun ruang (kubus, balok, bola), & sisi/rusuk',
        ),
        MathTopicData(
          title: 'Pengukuran Sudut dan Simetri',
          description: 'Sudut (siku-siku, lancip, tumpul), busur derajat, & simetri lipat/putar',
        ),
        MathTopicData(
          title: 'Keliling dan Luas Bangun Datar',
          description: 'Menghitung keliling dan luas (persegi, persegi panjang, segitiga)',
        ),
        MathTopicData(
          title: 'Bangun Ruang Lanjutan',
          description: 'Jaring-jaring, volume, & luas permukaan (kubus, balok, tabung, prisma)',
        ),
      ],
    ),
    MathThemeData(
      title: 'Pengukuran',
      icon: Icons.straighten,
      color: const Color(0xFF009688),
      topics: [
        MathTopicData(
          title: 'Pengukuran Dasar dan Satuan',
          description: 'Satuan tidak baku (jengkal, langkah) & satuan baku (cm, m, kg, jam)',
        ),
        MathTopicData(
          title: 'Hubungan Antarsatuan / Konversi',
          description: 'Tangga satuan panjang (km-mm), berat (kg-mg), & konversi waktu',
        ),
        MathTopicData(
          title: 'Pengukuran Gabungan',
          description: 'Konsep Kecepatan (jarak/waktu) & Debit (volume/waktu)',
        ),
      ],
    ),
    MathThemeData(
      title: 'Analisis Data dan Peluang',
      icon: Icons.bar_chart,
      color: const Color(0xFFFF9800),
      topics: [
        MathTopicData(
          title: 'Pengumpulan dan Pengelompokan Dasar',
          description: 'Mengumpulkan & mengelompokkan benda berdasarkan atribut (warna, bentuk, ukuran)',
        ),
        MathTopicData(
          title: 'Penyajian Data Visual Dasar',
          description: 'Membaca, menafsirkan, & menyajikan data (tabel, piktogram, diagram batang)',
        ),
        MathTopicData(
          title: 'Pengolahan Data Lanjutan & Statistika Dasar',
          description: 'Diagram garis & lingkaran, Modus (sering muncul), Median (tengah), & Mean (rata-rata)',
        ),
      ],
    ),
    MathThemeData(
      title: 'Aljabar Sederhana (Pola Bilangan & Rasio)',
      icon: Icons.functions,
      color: const Color(0xFF3F51B5),
      topics: [
        MathTopicData(
          title: 'Pengenalan Pola Gambar dan Bentuk',
          description: 'Mengamati & melanjutkan susunan pola dari gambar, warna, atau bentuk geometri',
        ),
        MathTopicData(
          title: 'Pola Bilangan',
          description: 'Deret angka berpola membesar (+, ×) dan mengecil (-, ÷)',
        ),
        MathTopicData(
          title: 'Rasio, Skala, dan Koordinat Dasar',
          description: 'Perbandingan/rasio, skala peta, & titik koordinat Kartesius dasar',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context);

    // Merge built-in initial questions with custom parent questions
    final List<Question> allAvailable = [
      ...QuestionBank.initialQuestions,
      ...parentProvider.customQuestions,
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(_selectedTheme == null ? 'Roadmap Matematika 📐' : _selectedTheme!.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        leading: _selectedTheme != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedTheme = null),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _selectedTheme == null
              ? _buildThemeList(context, allAvailable)
              : _buildTopicList(context, _selectedTheme!, allAvailable),
        ),
      ),
    );
  }

  Widget _buildThemeList(BuildContext context, List<Question> allAvailable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Tema Kurikulum Matematika 🎯',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Roadmap Pembelajaran Matematika (5 Tema Utama)',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: _mathThemes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final theme = _mathThemes[index];

              return InkWell(
                onTap: () => setState(() => _selectedTheme = theme),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.color.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: theme.color.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(theme.icon, color: theme.color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              theme.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${theme.topics.length} Sub-Topik Materi',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopicList(BuildContext context, MathThemeData theme, List<Question> allAvailable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topik & Materi ${theme.title} 📚',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pilih sub-topik materi untuk memulai kuis latihan:',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: theme.topics.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final topic = theme.topics[index];
              return InkWell(
                onTap: () async {
                  final parentProvider = Provider.of<ParentProvider>(context, listen: false);
                  final quizProvider = Provider.of<QuizProvider>(context, listen: false);
                  final userProvider = Provider.of<UserProvider>(context, listen: false);

                  final quizSet = await CloudSyncService.getQuizQuestions(
                    subject: 'Matematika',
                    topic: topic.title,
                    gradeLevel: widget.gradeLevel,
                    classNum: widget.classNum,
                    count: 10,
                    customQuestions: parentProvider.customQuestions,
                    isGuest: userProvider.isGuest,
                  );

                  if (!context.mounted) return;

                  quizProvider.startQuiz(quizSet, timerSeconds: parentProvider.questionTimerSeconds);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        subjectName: topic.title,
                        gradeLevel: widget.gradeLevel,
                        classNum: widget.classNum,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.color.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: theme.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.play_circle_fill,
                        color: AppColors.primaryCyan,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
