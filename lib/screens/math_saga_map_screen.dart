import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/stats_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/parent_provider.dart';
import '../models/user_stats_model.dart';
import '../services/ai_question_generator_service.dart';
import 'quiz_screen.dart';

class SpacePlanetLevel {
  final int levelNumber;
  final String title;
  final String themeName;
  final String topicKeyword;
  final bool isBoss;
  final String planetEmoji;
  final List<Color> planetColors;

  SpacePlanetLevel({
    required this.levelNumber,
    required this.title,
    required this.themeName,
    required this.topicKeyword,
    this.isBoss = false,
    required this.planetEmoji,
    required this.planetColors,
  });
}

class MathSagaMapScreen extends StatelessWidget {
  const MathSagaMapScreen({super.key});

  static final List<SpacePlanetLevel> spacePlanets = [
    // Tema 1: Bilangan dan Operasi Hitung (Planet Es & Biru)
    SpacePlanetLevel(
      levelNumber: 1,
      title: 'Planet Merkurius',
      themeName: 'Bilangan & Operasi Hitung',
      topicKeyword: 'Pengenalan Bilangan dan Nilai Tempat',
      planetEmoji: '🪐',
      planetColors: [const Color(0xFF00C6FF), const Color(0xFF0072FF)],
    ),
    SpacePlanetLevel(
      levelNumber: 2,
      title: 'Planet Venus',
      themeName: 'Bilangan & Operasi Hitung',
      topicKeyword: 'Penjumlahan & Pengurangan Dasar',
      planetEmoji: '🌍',
      planetColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    ),
    SpacePlanetLevel(
      levelNumber: 3,
      title: 'Planet Bumi',
      themeName: 'Bilangan & Operasi Hitung',
      topicKeyword: 'Perkalian & Pembagian',
      planetEmoji: '🌕',
      planetColors: [const Color(0xFFFFB75E), const Color(0xFFED8F03)],
    ),
    SpacePlanetLevel(
      levelNumber: 4,
      title: 'Planet Mars',
      themeName: 'Bilangan & Operasi Hitung',
      topicKeyword: 'Pecahan, Desimal, dan Persen',
      planetEmoji: '🌌',
      planetColors: [const Color(0xFF4568DC), const Color(0xFFB06AB3)],
    ),
    SpacePlanetLevel(
      levelNumber: 5,
      title: 'Planet Boss Yupiter',
      themeName: 'Bilangan & Operasi Hitung',
      topicKeyword: 'Kelipatan dan Faktor (KPK & FPB)',
      isBoss: true,
      planetEmoji: '👑',
      planetColors: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    ),
    SpacePlanetLevel(
      levelNumber: 6,
      title: 'Planet Saturnus',
      themeName: 'Bilangan & Operasi Hitung',
      topicKeyword: 'Bilangan Bulat Negatif',
      planetEmoji: '☄️',
      planetColors: [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)],
    ),

    // Tema 2: Geometri (Planet Ungu & Cincin)
    SpacePlanetLevel(
      levelNumber: 7,
      title: 'Planet Uranus',
      themeName: 'Geometri',
      topicKeyword: 'Pengenalan Bentuk dan Sifat Dasar',
      planetEmoji: '🔮',
      planetColors: [const Color(0xFF8E24AA), const Color(0xFFCE93D8)],
    ),
    SpacePlanetLevel(
      levelNumber: 8,
      title: 'Planet Neptunus',
      themeName: 'Geometri',
      topicKeyword: 'Pengukuran Sudut dan Simetri',
      planetEmoji: '📐',
      planetColors: [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
    ),
    SpacePlanetLevel(
      levelNumber: 9,
      title: 'Planet Pluto',
      themeName: 'Geometri',
      topicKeyword: 'Keliling dan Luas Bangun Datar',
      planetEmoji: '💎',
      planetColors: [const Color(0xFF4A148C), const Color(0xFF7B1FA2)],
    ),
    SpacePlanetLevel(
      levelNumber: 10,
      title: 'Planet Boss Ceres',
      themeName: 'Geometri',
      topicKeyword: 'Bangun Ruang Lanjutan',
      isBoss: true,
      planetEmoji: '👑',
      planetColors: [const Color(0xFFFFD700), const Color(0xFFFF8C00)],
    ),

    // Tema 3: Pengukuran (Planet Hijau Emerald)
    SpacePlanetLevel(
      levelNumber: 11,
      title: 'Planet Eris',
      themeName: 'Pengukuran',
      topicKeyword: 'Pengukuran Dasar dan Satuan',
      planetEmoji: '⏰',
      planetColors: [const Color(0xFF009688), const Color(0xFF80CBC4)],
    ),
    SpacePlanetLevel(
      levelNumber: 12,
      title: 'Planet Haumea',
      themeName: 'Pengukuran',
      topicKeyword: 'Hubungan Antarsatuan / Konversi',
      planetEmoji: '🪜',
      planetColors: [const Color(0xFF00796B), const Color(0xFF4DB6AC)],
    ),
    SpacePlanetLevel(
      levelNumber: 13,
      title: 'Planet Boss Makemake',
      themeName: 'Pengukuran',
      topicKeyword: 'Pengukuran Gabungan',
      isBoss: true,
      planetEmoji: '👑',
      planetColors: [const Color(0xFFFF5722), const Color(0xFFFF9800)],
    ),

    // Tema 4: Analisis Data dan Peluang (Planet Emas/Plasma)
    SpacePlanetLevel(
      levelNumber: 14,
      title: 'Planet Sedna',
      themeName: 'Analisis Data dan Peluang',
      topicKeyword: 'Pengumpulan dan Pengelompokan Dasar',
      planetEmoji: '📊',
      planetColors: [const Color(0xFFF57C00), const Color(0xFFFFB74D)],
    ),
    SpacePlanetLevel(
      levelNumber: 15,
      title: 'Planet Kepler-22b',
      themeName: 'Analisis Data dan Peluang',
      topicKeyword: 'Penyajian Data Visual Dasar',
      planetEmoji: '📈',
      planetColors: [const Color(0xFFE65100), const Color(0xFFFF9800)],
    ),
    SpacePlanetLevel(
      levelNumber: 16,
      title: 'Planet Boss Proxima Centauri',
      themeName: 'Analisis Data dan Peluang',
      topicKeyword: 'Pengolahan Data Lanjutan & Statistika Dasar',
      isBoss: true,
      planetEmoji: '👑',
      planetColors: [const Color(0xFFFF1744), const Color(0xFFFF5252)],
    ),

    // Tema 5: Aljabar Sederhana (Planet Nebulas)
    SpacePlanetLevel(
      levelNumber: 17,
      title: 'Planet Alpha Centauri',
      themeName: 'Aljabar Sederhana',
      topicKeyword: 'Pengenalan Pola Gambar dan Bentuk',
      planetEmoji: '✨',
      planetColors: [const Color(0xFF3F51B5), const Color(0xFF7986CB)],
    ),
    SpacePlanetLevel(
      levelNumber: 18,
      title: 'Planet Andromeda',
      themeName: 'Aljabar Sederhana',
      topicKeyword: 'Pola Bilangan',
      planetEmoji: '🔢',
      planetColors: [const Color(0xFF303F9F), const Color(0xFF5C6BC0)],
    ),
    SpacePlanetLevel(
      levelNumber: 19,
      title: 'Planet Boss Supernova Finale',
      themeName: 'Aljabar Sederhana',
      topicKeyword: 'Rasio, Skala, dan Koordinat Dasar',
      isBoss: true,
      planetEmoji: '👑',
      planetColors: [const Color(0xFFFFD700), const Color(0xFFFF3D00)],
    ),
  ];

  bool _isLevelUnlocked(int levelNumber, UserStats stats) {
    if (levelNumber == 1) return true;
    for (int lvl = 1; lvl < levelNumber; lvl++) {
      final stars = stats.levelStars[lvl] ?? 0;
      if (stars < 1) return false;
    }
    return true;
  }

  int _getHighestUnlockedLevel(UserStats stats, int maxLevels) {
    int highest = 1;
    for (int lvl = 1; lvl <= maxLevels; lvl++) {
      if (_isLevelUnlocked(lvl, stats)) {
        highest = lvl;
      } else {
        break;
      }
    }
    return highest;
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatsProvider>(context);
    final stats = statsProvider.stats;

    final int highestUnlockedLevel = _getHighestUnlockedLevel(stats, spacePlanets.length);

    return Scaffold(
      body: Stack(
        children: [
          // 🚀 Petualangan Syalumi & Sinan Space Adventure Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/math_space_syalumi_sinan_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => CustomPaint(
                painter: SpaceBackgroundPainter(),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom Cosmic Space Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Petualangan Syalumi & Sinan 🚀',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Jelajahi planet demi planet & selesaikan kuis!',
                              style: TextStyle(fontSize: 12, color: Colors.cyanAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Space Status Bar (Nyawa ❤️, Bintang ⭐, XP ⚡)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: const [
                          Text('❤️', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 4),
                          Text('5/5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          Text('${stats.totalStars}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          Text('${stats.totalXp} XP', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Winding Planetary Galaxy Path (Bottom Level 1 to Top Level 19)
                Expanded(
                  child: ListView.builder(
                    reverse: true, // Level 1 is at the bottom, traveling upward into space!
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    itemCount: spacePlanets.length,
                    itemBuilder: (context, index) {
                      final planet = spacePlanets[index];
                      final isUnlocked = _isLevelUnlocked(planet.levelNumber, stats);
                      final isCurrent = planet.levelNumber == highestUnlockedLevel;

                      // Alternate planet alignment to form a cosmic orbit path
                      final double horizontalOffset = (index % 4 == 0)
                          ? 0.0
                          : (index % 4 == 1)
                              ? 0.45
                              : (index % 4 == 2)
                                  ? 0.0
                                  : -0.45;

                      return Align(
                        alignment: Alignment(horizontalOffset, 0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Spaceship Rocket hovering on Current Level
                              if (isCurrent)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.cyanAccent.withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.cyanAccent, width: 1.5),
                                  ),
                                  child: const Text('🚀', style: TextStyle(fontSize: 26)),
                                ).animate(onPlay: (c) => c.repeat(reverse: true)).slideY(begin: 0, end: -0.2, duration: 600.ms),

                              // Planet Level Button Node
                              GestureDetector(
                                onTap: () {
                                  if (!isUnlocked) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Raih minimal 1 Bintang ⭐ di Planet ${planet.levelNumber - 1} untuk membuka planet ini! 🔒'),
                                        backgroundColor: Colors.deepOrangeAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  // Dynamically generate 10 fresh randomized questions across 3 versions every time planet is accessed!
                                  final quizSet = AiQuestionGeneratorService.generateDynamicMathQuestions(
                                    gradeLevel: 'Umum',
                                    classNum: planet.levelNumber,
                                    count: 10,
                                    topic: planet.topicKeyword,
                                  );

                                  final parentProvider = Provider.of<ParentProvider>(context, listen: false);
                                  final quizProvider = Provider.of<QuizProvider>(context, listen: false);
                                  quizProvider.startQuiz(quizSet, timerSeconds: parentProvider.questionTimerSeconds);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                        subjectName: planet.title,
                                        gradeLevel: 'Umum',
                                        classNum: planet.levelNumber,
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Planetary Glow Ring for Active Level Planet
                                    if (isCurrent)
                                      Container(
                                        width: 96,
                                        height: 96,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.cyanAccent.withValues(alpha: 0.25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.cyanAccent.withValues(alpha: 0.8),
                                              blurRadius: 24,
                                              spreadRadius: 3,
                                            )
                                          ],
                                        ),
                                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                            begin: const Offset(1, 1),
                                            end: const Offset(1.12, 1.12),
                                            duration: 800.ms,
                                          ),

                                    // Planet Node Sphere
                                    Container(
                                      width: planet.isBoss ? 84 : 76,
                                      height: planet.isBoss ? 84 : 76,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: isUnlocked
                                              ? planet.planetColors
                                              : [Colors.grey.shade800, Colors.grey.shade900],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isUnlocked
                                                ? planet.planetColors.first.withValues(alpha: 0.7)
                                                : Colors.black54,
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          )
                                        ],
                                        border: Border.all(
                                          color: isUnlocked ? Colors.white : Colors.grey.shade600,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: isUnlocked
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(planet.planetEmoji, style: TextStyle(fontSize: planet.isBoss ? 26 : 22)),
                                                  Text(
                                                    'Lvl ${planet.levelNumber}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const Icon(Icons.lock, color: Colors.white60, size: 26),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Planet Title Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUnlocked ? planet.planetColors.first : Colors.grey.shade700,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  planet.title,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked ? Colors.white : Colors.grey.shade400,
                                  ),
                                ),
                              ),

                              // Stars Earned (⭐ / ☆) based on real level performance
                              if (isUnlocked)
                                Builder(
                                  builder: (context) {
                                    final starsEarned = stats.levelStars[planet.levelNumber] ?? 0;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            starsEarned >= 1 ? '⭐' : '☆',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: starsEarned >= 1 ? Colors.amber : Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            starsEarned >= 2 ? '⭐' : '☆',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: starsEarned >= 2 ? Colors.amber : Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            starsEarned >= 3 ? '⭐' : '☆',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: starsEarned >= 3 ? Colors.amber : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter to draw Deep Space Environment (Twinkling Stars, Nebulae, and Shooting Meteors)
class SpaceBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Deep Space Gradient
    final Rect rect = Offset.zero & size;
    const gradient = LinearGradient(
      colors: [
        Color(0xFF030214), // Deep Void Black/Navy
        Color(0xFF0A0826), // Cosmic Blue
        Color(0xFF140F3D), // Deep Violet Nebula
        Color(0xFF08061A), // Void Horizon
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Paint bgPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Cosmic Nebula Clouds (Glow Gradients)
    _drawNebula(canvas, Offset(size.width * 0.2, size.height * 0.2), 140, const Color(0xFF8E24AA).withValues(alpha: 0.18));
    _drawNebula(canvas, Offset(size.width * 0.8, size.height * 0.45), 180, const Color(0xFF3F51B5).withValues(alpha: 0.2));
    _drawNebula(canvas, Offset(size.width * 0.3, size.height * 0.75), 160, const Color(0xFF00E5FF).withValues(alpha: 0.15));
    _drawNebula(canvas, Offset(size.width * 0.75, size.height * 0.9), 150, const Color(0xFFE91E63).withValues(alpha: 0.15));

    // 3. Twinkling Stars (Deterministic Random for smooth rendering)
    final Random random = Random(42);
    final Paint starPaint = Paint()..color = Colors.white;

    for (int i = 0; i < 120; i++) {
      final double dx = random.nextDouble() * size.width;
      final double dy = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 1.8 + 0.5;
      final double opacity = random.nextDouble() * 0.7 + 0.3;

      starPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    }

    // 4. Glowing Meteor Comets ☄️
    _drawMeteor(canvas, Offset(size.width * 0.75, size.height * 0.15), 60);
    _drawMeteor(canvas, Offset(size.width * 0.15, size.height * 0.55), 80);
    _drawMeteor(canvas, Offset(size.width * 0.85, size.height * 0.8), 50);
  }

  void _drawNebula(Canvas canvas, Offset center, double radius, Color color) {
    final Paint nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, nebulaPaint);
  }

  void _drawMeteor(Canvas canvas, Offset start, double length) {
    final Paint meteorPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.cyanAccent.withValues(alpha: 0.8), Colors.white.withValues(alpha: 0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(start.dx, start.dy, length, length))
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      start,
      Offset(start.dx + length, start.dy + length * 0.8),
      meteorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
