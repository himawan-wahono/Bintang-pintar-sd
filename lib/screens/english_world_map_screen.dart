import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/stats_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/parent_provider.dart';
import '../models/user_stats_model.dart';
import '../services/ai_english_generator_service.dart';
import 'quiz_screen.dart';

class WorldCountryLevel {
  final int levelNumber;
  final String countryName;
  final String flagEmoji;
  final String landmarkTitle;
  final String topicKeyword;
  final List<Color> accentColors;

  WorldCountryLevel({
    required this.levelNumber,
    required this.countryName,
    required this.flagEmoji,
    required this.landmarkTitle,
    required this.topicKeyword,
    required this.accentColors,
  });
}

class EnglishWorldMapScreen extends StatefulWidget {
  const EnglishWorldMapScreen({super.key});

  @override
  State<EnglishWorldMapScreen> createState() => _EnglishWorldMapScreenState();
}

class _EnglishWorldMapScreenState extends State<EnglishWorldMapScreen> {
  final List<WorldCountryLevel> worldCountries = [
    WorldCountryLevel(
      levelNumber: 1,
      countryName: 'Indonesia',
      flagEmoji: '🇮🇩',
      landmarkTitle: 'Monas, Jakarta',
      topicKeyword: 'Phonics, Alphabet & Basic Vocabulary',
      accentColors: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    ),
    WorldCountryLevel(
      levelNumber: 2,
      countryName: 'Singapura',
      flagEmoji: '🇸🇬',
      landmarkTitle: 'Merlion Park',
      topicKeyword: 'Greetings, Pronouns & Simple Sentences',
      accentColors: [const Color(0xFF00B4DB), const Color(0xFF0083B0)],
    ),
    WorldCountryLevel(
      levelNumber: 3,
      countryName: 'Malaysia',
      flagEmoji: '🇲🇾',
      landmarkTitle: 'Petronas Towers',
      topicKeyword: 'Simple Present Tense & Daily Routines',
      accentColors: [const Color(0xFFF7971E), const Color(0xFFFFD200)],
    ),
    WorldCountryLevel(
      levelNumber: 4,
      countryName: 'Jepang',
      flagEmoji: '🇯🇵',
      landmarkTitle: 'Tokyo & Mt. Fuji',
      topicKeyword: 'Descriptive Text, Adjectives & Prepositions',
      accentColors: [const Color(0xFFFF758C), const Color(0xFFFF7EB3)],
    ),
    WorldCountryLevel(
      levelNumber: 5,
      countryName: 'Inggris',
      flagEmoji: '🇬🇧',
      landmarkTitle: 'London, Big Ben',
      topicKeyword: 'Simple Past Tense & Storytelling',
      accentColors: [const Color(0xFF4568DC), const Color(0xFFB06AB3)],
    ),
    WorldCountryLevel(
      levelNumber: 6,
      countryName: 'Amerika Serikat',
      flagEmoji: '🇺🇸',
      landmarkTitle: 'Statue of Liberty',
      topicKeyword: 'Future Tense, Modals & Intentions',
      accentColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    ),
    WorldCountryLevel(
      levelNumber: 7,
      countryName: 'Kanada',
      flagEmoji: '🇨🇦',
      landmarkTitle: 'Toronto Maple Trail',
      topicKeyword: 'Degrees of Comparison & Procedure Text',
      accentColors: [const Color(0xFFEB5757), const Color(0xFF000000)],
    ),
    WorldCountryLevel(
      levelNumber: 8,
      countryName: 'Australia',
      flagEmoji: '🇦🇺',
      landmarkTitle: 'Sydney Opera House',
      topicKeyword: 'Present Perfect & Passive Voice',
      accentColors: [const Color(0xFFFF8008), const Color(0xFFFFC837)],
    ),
  ];

  bool _isLevelUnlocked(int levelNumber, UserStats stats) {
    if (levelNumber == 1) return true;
    for (int lvl = 1; lvl < levelNumber; lvl++) {
      final stars = stats.levelStars[100 + lvl] ?? 0; // Using 100+ offset for English levels
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

    final int highestUnlockedLevel = _getHighestUnlockedLevel(stats, worldCountries.length);

    return Scaffold(
      body: Stack(
        children: [
          // 🌏 Petualangan Syalumi & Sinan World Tour Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/english_world_map_syalumi_sinan_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => CustomPaint(
                painter: WorldBackgroundPainter(),
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
                // Custom Passport Header
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
                              'World Passport Adventure ✈️🌏',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Terbang dari Indonesia keliling dunia & kuasai Bahasa Inggris!',
                              style: TextStyle(fontSize: 12, color: Colors.yellowAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // World Tour Status Bar (Hearts ❤️, Stars ⭐, XP ⚡)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
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

                // World Tour Country Path (Bottom Indonesia 🇮🇩 to Top Australia 🇦🇺)
                Expanded(
                  child: ListView.builder(
                    reverse: true, // Start from Indonesia at bottom!
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    itemCount: worldCountries.length,
                    itemBuilder: (context, index) {
                      final country = worldCountries[index];
                      final isUnlocked = _isLevelUnlocked(country.levelNumber, stats);
                      final isCurrent = country.levelNumber == highestUnlockedLevel;

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
                              // Airplane hovering over current active country
                              if (isCurrent)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.yellowAccent.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.yellowAccent, width: 1.5),
                                  ),
                                  child: const Text('✈️', style: TextStyle(fontSize: 26)),
                                ).animate(onPlay: (c) => c.repeat(reverse: true)).slideY(begin: 0, end: -0.2, duration: 600.ms),

                              // Country Node Button
                              GestureDetector(
                                onTap: () {
                                  if (!isUnlocked) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Raih minimal 1 Bintang ⭐ di ${worldCountries[country.levelNumber - 2].countryName} untuk membuka negara ini! 🔒'),
                                        backgroundColor: Colors.deepOrangeAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  // Dynamically generate 10 fresh English questions across 3 versions
                                  final quizSet = AiEnglishGeneratorService.generateDynamicEnglishQuestions(
                                    gradeLevel: 'Umum',
                                    classNum: 100 + country.levelNumber,
                                    count: 10,
                                    topic: country.topicKeyword,
                                  );

                                  final parentProvider = Provider.of<ParentProvider>(context, listen: false);
                                  final quizProvider = Provider.of<QuizProvider>(context, listen: false);
                                  quizProvider.startQuiz(quizSet, timerSeconds: parentProvider.questionTimerSeconds);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                        subjectName: '${country.flagEmoji} ${country.countryName}',
                                        gradeLevel: 'English',
                                        classNum: 100 + country.levelNumber,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isUnlocked
                                        ? LinearGradient(
                                            colors: country.accentColors,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : LinearGradient(
                                            colors: [Colors.grey.shade700, Colors.grey.shade900],
                                          ),
                                    border: Border.all(
                                      color: isCurrent
                                          ? Colors.yellowAccent
                                          : isUnlocked
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                      width: isCurrent ? 3.5 : 2.0,
                                    ),
                                    boxShadow: isUnlocked
                                        ? [
                                            BoxShadow(
                                              color: country.accentColors.first.withValues(alpha: 0.4),
                                              blurRadius: 16,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: isUnlocked
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(country.flagEmoji, style: const TextStyle(fontSize: 28)),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Lvl ${country.levelNumber}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Icon(Icons.lock, color: Colors.white60, size: 26),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Country Landmark Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUnlocked ? country.accentColors.first : Colors.grey.shade700,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '${country.flagEmoji} ${country.countryName}: ${country.landmarkTitle}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked ? Colors.white : Colors.grey.shade400,
                                  ),
                                ),
                              ),

                              // Real Stars Earned (⭐ / ☆)
                              if (isUnlocked)
                                Builder(
                                  builder: (context) {
                                    final starsEarned = stats.levelStars[100 + country.levelNumber] ?? 0;
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

/// Custom Background Painter for Vibrant World Tour Passport Theme
class WorldBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Vibrant Ocean & Atmosphere Gradient
    final rect = Offset.zero & size;
    final oceanGradient = const LinearGradient(
      colors: [
        Color(0xFF0D1B2A),
        Color(0xFF1B263B),
        Color(0xFF1B4965),
        Color(0xFF0F2C59),
        Color(0xFF071952),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);

    canvas.drawRect(rect, Paint()..shader = oceanGradient);

    // 2. Latitude & Longitude Grid Lines
    final gridPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double y = 50; y < size.height; y += 75) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 40; x < size.width; x += 65) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // 3. Vibrant Glowing Continents & Island Archipelagos
    // Indonesian Archipelago 🇮🇩 (Emerald Green & Gold)
    final indoPaint = Paint()
      ..color = const Color(0xFF2EC4B6).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    final indoOutline = Paint()
      ..color = const Color(0xFFFF9F1C)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final indoPath = Path()
      ..addOval(Rect.fromLTWH(size.width * 0.18, size.height * 0.81, 95, 38))
      ..addOval(Rect.fromLTWH(size.width * 0.42, size.height * 0.83, 85, 42))
      ..addOval(Rect.fromLTWH(size.width * 0.68, size.height * 0.82, 80, 32));
    canvas.drawPath(indoPath, indoPaint);
    canvas.drawPath(indoPath, indoOutline);

    // Asia & Japan 🇯🇵 (Coral Pink & Magenta Glow)
    final asiaPaint = Paint()
      ..color = const Color(0xFFFF70A6).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final asiaOutline = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final asiaPath = Path()
      ..addOval(Rect.fromLTWH(size.width * 0.35, size.height * 0.38, 190, 145))
      ..addOval(Rect.fromLTWH(size.width * 0.76, size.height * 0.41, 55, 85));
    canvas.drawPath(asiaPath, asiaPaint);
    canvas.drawPath(asiaPath, asiaOutline);

    // Europe & UK 🇬🇧 (Cyan & Royal Blue Glow)
    final europePaint = Paint()
      ..color = const Color(0xFF70D6FF).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final europeOutline = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final europePath = Path()
      ..addOval(Rect.fromLTWH(size.width * 0.12, size.height * 0.27, 130, 95))
      ..addOval(Rect.fromLTWH(size.width * 0.06, size.height * 0.21, 50, 65));
    canvas.drawPath(europePath, europePaint);
    canvas.drawPath(europePath, europeOutline);

    // Americas 🇺🇸 🇨🇦 (Bright Gold & Sunset Amber)
    final americasPaint = Paint()
      ..color = const Color(0xFFFFD166).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final americasOutline = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final americasPath = Path()
      ..addOval(Rect.fromLTWH(size.width * 0.04, size.height * 0.07, 170, 135));
    canvas.drawPath(americasPath, americasPaint);
    canvas.drawPath(americasPath, americasOutline);

    // Australia 🇦🇺 (Warm Sunburst Orange)
    final ozPaint = Paint()
      ..color = const Color(0xFFF77F00).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final ozOutline = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final ozPath = Path()
      ..addOval(Rect.fromLTWH(size.width * 0.64, size.height * 0.71, 115, 90));
    canvas.drawPath(ozPath, ozPaint);
    canvas.drawPath(ozPath, ozOutline);

    // 4. Flight Path Dashed Curve (Jalur Penerbangan Pesawat ✈️)
    final flightPathPaint = Paint()
      ..color = Colors.yellowAccent.withValues(alpha: 0.45)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final flightPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.85)
      ..cubicTo(size.width * 0.8, size.height * 0.6, size.width * 0.2, size.height * 0.4, size.width * 0.5, size.height * 0.15);

    canvas.drawPath(flightPath, flightPathPaint);

    // 5. Detailed Golden Compass Rose 🧭 Watermark
    final center = Offset(size.width * 0.82, 100);
    final compassRing = Paint()
      ..color = Colors.amber.withValues(alpha: 0.35)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 34, compassRing);
    canvas.drawCircle(center, 26, compassRing);

    final needlePaint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(center.dx, center.dy - 40), Offset(center.dx, center.dy + 40), needlePaint);
    canvas.drawLine(Offset(center.dx - 40, center.dy), Offset(center.dx + 40, center.dy), needlePaint);

    // 6. Twinkling Travel Stars
    final starPaint = Paint()..color = Colors.white;
    final random = Random(42);
    for (int i = 0; i < 40; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final r = random.nextDouble() * 2.0 + 1.0;
      starPaint.color = Colors.white.withValues(alpha: random.nextDouble() * 0.6 + 0.4);
      canvas.drawCircle(Offset(dx, dy), r, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
