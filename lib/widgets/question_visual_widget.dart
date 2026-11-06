import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question_model.dart';

/// Reusable Widget to render dynamic vector diagrams (Fractions, Clocks, Geometry)
/// and network CDN images for SD Elementary School questions.
class QuestionVisualWidget extends StatelessWidget {
  final Question question;

  const QuestionVisualWidget({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Render Network Image CDN if available (e.g. English Vocab / Photos)
    if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            question.imageUrl!,
            height: 180,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 180,
                color: Colors.grey.shade100,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: 140,
              color: Colors.amber.shade50,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_rounded, size: 40, color: Colors.amber),
                  SizedBox(height: 8),
                  Text('Gambar Latihan', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 2. Render Dynamic Vector Canvas or English Visual Card based on visualType
    final visualType = question.visualType ?? '';
    if (visualType.isEmpty) return const SizedBox.shrink();

    // Dedicated Rich Reading Passage Card for English Reading Comprehension
    if (visualType == 'english_reading_passage') {
      return _buildReadingPassageCard(context, question);
    }

    // Dedicated Rich Visual Card for English Questions
    if (visualType.startsWith('english_')) {
      return _buildEnglishVisualCard(context, visualType, question);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: 220,
            child: CustomPaint(
              painter: _getPainter(visualType, question),
            ),
          ),
          if (question.visualLabel != null && question.visualLabel!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                question.visualLabel!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnglishVisualCard(BuildContext context, String visualType, Question question) {
    final visualData = question.visualData ?? {};
    final emoji = visualData['emoji']?.toString() ?? '🔤';
    final title = visualData['title']?.toString() ?? question.topic;
    var subtitle = visualData['subtitle']?.toString() ?? '';
    final colorHex = visualData['colorHex']?.toString();

    // Safety Guard: Prevent leaking answer text on visual cards
    bool leaksAnswer(String? text) {
      if (text == null || text.trim().isEmpty) return false;
      final textLower = text.toLowerCase().trim();
      for (var opt in question.options) {
        final optLower = opt.toLowerCase().trim();
        if (optLower.length >= 2 && (textLower == optLower || textLower.contains(optLower))) {
          return true;
        }
      }
      return false;
    }

    if (leaksAnswer(subtitle)) {
      subtitle = 'Gambar Petunjuk';
    }

    var displayLabel = question.visualLabel ?? '';
    if (leaksAnswer(displayLabel)) {
      displayLabel = 'Petunjuk Visual';
    }

    Color cardBg = Colors.purple.shade50;
    Color accentColor = Colors.purple.shade700;

    if (colorHex != null && colorHex.isNotEmpty) {
      try {
        final buffer = StringBuffer();
        if (colorHex.length == 6 || colorHex.length == 7) buffer.write('ff');
        buffer.write(colorHex.replaceFirst('#', ''));
        accentColor = Color(int.parse(buffer.toString(), radix: 16));
        cardBg = accentColor.withAlpha(25);
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withAlpha(90), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(30),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.palette_rounded, size: 14, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  'Visual Illustration • $title',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Central Large Visual Icon Frame
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withAlpha(120), width: 3),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withAlpha(45),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Highlighting Word / Target Badge
          if (subtitle.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          if (displayLabel.isNotEmpty && displayLabel != subtitle)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                displayLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadingPassageCard(BuildContext context, Question question) {
    final visualData = question.visualData ?? {};
    final storyTitle = visualData['storyTitle']?.toString() ?? 'Story Passage';
    final storyText = visualData['storyText']?.toString() ?? '';
    final emoji = visualData['emoji']?.toString() ?? '📖';
    final themeColorHex = visualData['colorHex']?.toString() ?? '#3A86FF';

    Color themeColor = const Color(0xFF3A86FF);
    if (themeColorHex.isNotEmpty) {
      try {
        final buffer = StringBuffer();
        if (themeColorHex.length == 6 || themeColorHex.length == 7) buffer.write('ff');
        buffer.write(themeColorHex.replaceFirst('#', ''));
        themeColor = Color(int.parse(buffer.toString(), radix: 16));
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8), // Warm parchment paper tone
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor.withValues(alpha: 0.35), width: 2),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              border: Border(
                bottom: BorderSide(color: themeColor.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📖 Teks Bacaan Cerita (Reading Passage)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: themeColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        storyTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: themeColor.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_stories_rounded, size: 14, color: themeColor),
                      const SizedBox(width: 4),
                      const Text(
                        'Baca Teks',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Story Text Body with quotes
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storyText,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.65,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                    fontFamily: 'serif',
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.help_outline_rounded, size: 15, color: Colors.blueGrey.shade600),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pahami isi cerita di atas untuk menjawab soal di bawah ini 👇',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade700,
                        ),
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

  CustomPainter _getPainter(String visualType, Question question) {
    switch (visualType) {
      case 'fraction_pie':
        return PieFractionPainter(
          slices: question.visualData?['slices'] ?? 4,
          shaded: question.visualData?['shaded'] ?? 3,
        );
      case 'analog_clock':
        return AnalogClockPainter(
          hour: question.visualData?['hour'] ?? 7,
          minute: question.visualData?['minute'] ?? 30,
        );
      case 'shape_rectangle':
        return RectanglePainter(
          length: question.visualData?['length']?.toString() ?? '12 cm',
          width: question.visualData?['width']?.toString() ?? '5 cm',
        );
      case 'shape_triangle':
        return TrianglePainter(
          base: question.visualData?['base']?.toString() ?? '8 cm',
          height: question.visualData?['height']?.toString() ?? '6 cm',
        );
      case 'shape_cylinder':
        return CylinderPainter(
          radius: question.visualData?['radius']?.toString() ?? '7 cm',
          height: question.visualData?['height']?.toString() ?? '10 cm',
        );
      case 'shape_cube':
        return CubePainter(
          side: question.visualData?['side']?.toString() ?? '6 cm',
        );
      case 'shape_circle':
        return CirclePainter(
          radius: question.visualData?['radius']?.toString() ?? '7 cm',
        );
      case 'shape_angle':
        return AnglePainter(
          degrees: question.visualData?['degrees'] ?? 90,
          label: question.visualData?['label']?.toString() ?? 'Siku-siku',
        );
      case 'bar_chart':
        return BarChartPainter(
          categories: List<String>.from(question.visualData?['categories'] ?? ['Senin', 'Selasa', 'Rabu', 'Kamis']),
          values: List<int>.from(question.visualData?['values'] ?? [15, 30, 20, 25]),
        );
      case 'pictogram':
        return PictogramPainter(
          category: question.visualData?['category']?.toString() ?? 'Apel',
          count: question.visualData?['count'] ?? 15,
          scale: question.visualData?['scale'] ?? 5,
          symbol: question.visualData?['symbol']?.toString() ?? '🍎',
        );
      case 'algebra_balance':
        return AlgebraBalancePainter(
          leftText: question.visualData?['leftText']?.toString() ?? 'x + 3',
          rightText: question.visualData?['rightText']?.toString() ?? '7',
        );
      case 'pattern_boxes':
        return PatternBoxesPainter(
          sequence: List<String>.from(question.visualData?['sequence'] ?? ['2', '5', '8', '?']),
        );
      default:
        return DefaultShapePainter();
    }
  }
}

// ============================================================================
// CUSTOM PAINTERS (VECTOR ENGINE)
// ============================================================================

/// 1. Painter Kue Pecahan (Fraction Pie Chart)
class PieFractionPainter extends CustomPainter {
  final int slices;
  final int shaded;

  PieFractionPainter({required this.slices, required this.shaded});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final linePaint = Paint()
      ..color = Colors.indigo.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final shadedPaint = Paint()
      ..color = Colors.amber.shade400
      ..style = PaintingStyle.fill;

    final unshadedPaint = Paint()
      ..color = Colors.blue.shade50
      ..style = PaintingStyle.fill;

    // Draw base unshaded circle
    canvas.drawCircle(center, radius, unshadedPaint);

    // Draw shaded slices
    final sweepAngle = (2 * pi) / slices;
    for (int i = 0; i < shaded; i++) {
      final startAngle = -pi / 2 + (i * sweepAngle);
      canvas.drawArc(rect, startAngle, sweepAngle, true, shadedPaint);
    }

    // Draw slice dividing lines
    canvas.drawCircle(center, radius, linePaint);
    for (int i = 0; i < slices; i++) {
      final angle = -pi / 2 + (i * sweepAngle);
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(dx, dy), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 2. Painter Jam Dinding Analog (Analog Clock)
class AnalogClockPainter extends CustomPainter {
  final int hour;
  final int minute;

  AnalogClockPainter({required this.hour, required this.minute});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    final clockBg = Paint()
      ..color = Colors.lightBlue.shade50
      ..style = PaintingStyle.fill;

    final clockBorder = Paint()
      ..color = Colors.indigo.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, clockBg);
    canvas.drawCircle(center, radius, clockBorder);

    // Draw clock numbers & ticks
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * (pi / 180);
      final textOffset = Offset(
        center.dx + (radius - 20) * cos(angle) - 6,
        center.dy + (radius - 20) * sin(angle) - 8,
      );
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
      );
      textPainter.layout();
      textPainter.paint(canvas, textOffset);
    }

    // Draw Hour Hand
    final hourAngle = ((hour % 12 + minute / 60) * 30 - 90) * (pi / 180);
    final hourHandLength = radius * 0.5;
    final hourPaint = Paint()
      ..color = Colors.indigo.shade900
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(center.dx + hourHandLength * cos(hourAngle), center.dy + hourHandLength * sin(hourAngle)),
      hourPaint,
    );

    // Draw Minute Hand
    final minuteAngle = (minute * 6 - 90) * (pi / 180);
    final minuteHandLength = radius * 0.75;
    final minutePaint = Paint()
      ..color = Colors.red.shade600
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(center.dx + minuteHandLength * cos(minuteAngle), center.dy + minuteHandLength * sin(minuteAngle)),
      minutePaint,
    );

    // Center pin
    canvas.drawCircle(center, 5, Paint()..color = Colors.indigo.shade900);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 3. Painter Geometri Persegi Panjang (Rectangle Painter with labels)
class RectanglePainter extends CustomPainter {
  final String length;
  final String width;

  RectanglePainter({required this.length, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(30, 30, size.width - 60, size.height - 60);
    final bgPaint = Paint()..color = Colors.purple.shade50;
    final borderPaint = Paint()
      ..color = Colors.purple.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect, borderPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Length label (Bottom)
    textPainter.text = TextSpan(
      text: 'p = $length',
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.purple),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - 20, size.height - 25));

    // Width label (Right)
    textPainter.text = TextSpan(
      text: 'l = $width',
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.purple),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 25, size.height / 2 - 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 4. Painter Geometri Segitiga (Triangle Painter)
class TrianglePainter extends CustomPainter {
  final String base;
  final String height;

  TrianglePainter({required this.base, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 20)
      ..lineTo(20, size.height - 30)
      ..lineTo(size.width - 20, size.height - 30)
      ..close();

    final bgPaint = Paint()..color = Colors.teal.shade50;
    final borderPaint = Paint()
      ..color = Colors.teal.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, borderPaint);

    // Dotted Height Line
    final dashPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (double i = 20; i < size.height - 30; i += 8) {
      canvas.drawLine(Offset(size.width / 2, i), Offset(size.width / 2, i + 4), dashPaint);
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    // Base label
    textPainter.text = TextSpan(
      text: 'a = $base',
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - 20, size.height - 25));

    // Height label
    textPainter.text = TextSpan(
      text: 't = $height',
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 + 5, size.height / 2 - 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 5. Painter Geometri Tabung (Cylinder Painter)
class CylinderPainter extends CustomPainter {
  final String radius;
  final String height;

  CylinderPainter({required this.radius, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final topEllipse = Rect.fromLTWH(40, 15, size.width - 80, 30);
    final bottomEllipse = Rect.fromLTWH(40, size.height - 45, size.width - 80, 30);

    final bgPaint = Paint()..color = Colors.orange.shade50;
    final borderPaint = Paint()
      ..color = Colors.deepOrange.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawOval(topEllipse, bgPaint);
    canvas.drawOval(topEllipse, borderPaint);

    // Body lines
    canvas.drawLine(const Offset(40, 30), Offset(40, size.height - 30), borderPaint);
    canvas.drawLine(Offset(size.width - 40, 30), Offset(size.width - 40, size.height - 30), borderPaint);

    canvas.drawOval(bottomEllipse, borderPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    // Radius label
    textPainter.text = TextSpan(
      text: 'r = $radius',
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepOrange),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - 15, 20));

    // Height label
    textPainter.text = TextSpan(
      text: 't = $height',
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepOrange),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 35, size.height / 2 - 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 6. Painter Diagram Batang (Bar Chart)
class BarChartPainter extends CustomPainter {
  final List<String> categories;
  final List<int> values;

  BarChartPainter({required this.categories, required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (categories.isEmpty || values.isEmpty) return;

    final maxVal = values.reduce(max).toDouble();
    final effectiveMax = maxVal == 0 ? 10.0 : maxVal * 1.25;

    final axisPaint = Paint()
      ..color = Colors.blueGrey.shade700
      ..strokeWidth = 2;

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final leftPadding = 30.0;
    final bottomPadding = 25.0;
    final topPadding = 15.0;
    final rightPadding = 15.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Grid lines & Y Axis labels
    for (int i = 0; i <= 4; i++) {
      final y = topPadding + chartHeight - (i * (chartHeight / 4));
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width - rightPadding, y), gridPaint);
      final valTick = ((effectiveMax / 4) * i).round();
      final tp = TextPainter(
        text: TextSpan(text: '$valTick', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 4, y - 5));
    }

    // Axes
    canvas.drawLine(Offset(leftPadding, topPadding), Offset(leftPadding, topPadding + chartHeight), axisPaint);
    canvas.drawLine(Offset(leftPadding, topPadding + chartHeight), Offset(size.width - rightPadding, topPadding + chartHeight), axisPaint);

    final barCount = categories.length;
    final groupWidth = chartWidth / barCount;
    final barWidth = min(groupWidth * 0.55, 24.0);

    final barColors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
    ];

    for (int i = 0; i < barCount; i++) {
      final val = values[i];
      final barH = (val / effectiveMax) * chartHeight;
      final barX = leftPadding + (i * groupWidth) + (groupWidth - barWidth) / 2;
      final barY = topPadding + chartHeight - barH;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barH),
        const Radius.circular(4),
      );

      final barPaint = Paint()..color = barColors[i % barColors.length];
      canvas.drawRRect(rect, barPaint);

      // Value label on top
      final valTp = TextPainter(
        text: TextSpan(text: '$val', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
        textDirection: TextDirection.ltr,
      )..layout();
      valTp.paint(canvas, Offset(barX + (barWidth - valTp.width) / 2, barY - 12));

      // Category label on bottom
      final catTp = TextPainter(
        text: TextSpan(text: categories[i], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800)),
        textDirection: TextDirection.ltr,
      )..layout();
      catTp.paint(canvas, Offset(barX + (barWidth - catTp.width) / 2, topPadding + chartHeight + 4));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 7. Painter Diagram Gambar (Pictogram)
class PictogramPainter extends CustomPainter {
  final String category;
  final int count;
  final int scale;
  final String symbol;

  PictogramPainter({required this.category, required this.count, required this.scale, this.symbol = '🍎'});

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(textDirection: TextDirection.ltr);

    // Title / Legend
    tp.text = TextSpan(
      text: '$category (1 $symbol = $scale unit)',
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
    );
    tp.layout();
    tp.paint(canvas, Offset((size.width - tp.width) / 2, 8));

    // Render symbols grid
    final numSymbols = (count / scale).round().clamp(1, 10);
    final symbolsPerRow = 5;

    for (int i = 0; i < numSymbols; i++) {
      final col = i % symbolsPerRow;
      final row = i ~/ symbolsPerRow;
      final x = 20.0 + (col * 36.0);
      final y = 35.0 + (row * 36.0);

      tp.text = TextSpan(
        text: symbol,
        style: const TextStyle(fontSize: 24),
      );
      tp.layout();
      tp.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 8. Painter Geometri Kubus (3D Cube)
class CubePainter extends CustomPainter {
  final String side;

  CubePainter({required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = 45.0;

    final fillPaint = Paint()..color = Colors.indigo.shade50;
    final borderPaint = Paint()
      ..color = Colors.indigo.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final frontRect = Rect.fromLTWH(cx - s, cy - s / 2, s * 1.2, s * 1.2);
    canvas.drawRect(frontRect, fillPaint);
    canvas.drawRect(frontRect, borderPaint);

    final topPath = Path()
      ..moveTo(frontRect.left, frontRect.top)
      ..lineTo(frontRect.left + 20, frontRect.top - 20)
      ..lineTo(frontRect.right + 20, frontRect.top - 20)
      ..lineTo(frontRect.right, frontRect.top)
      ..close();
    canvas.drawPath(topPath, Paint()..color = Colors.indigo.shade100);
    canvas.drawPath(topPath, borderPaint);

    final rightPath = Path()
      ..moveTo(frontRect.right, frontRect.top)
      ..lineTo(frontRect.right + 20, frontRect.top - 20)
      ..lineTo(frontRect.right + 20, frontRect.bottom - 20)
      ..lineTo(frontRect.right, frontRect.bottom)
      ..close();
    canvas.drawPath(rightPath, Paint()..color = Colors.indigo.shade200);
    canvas.drawPath(rightPath, borderPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: 's = $side',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - s / 2, frontRect.bottom + 6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 9. Painter Lingkaran (Circle with Radius)
class CirclePainter extends CustomPainter {
  final String radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2 - 20;

    final bgPaint = Paint()..color = Colors.cyan.shade50;
    final borderPaint = Paint()
      ..color = Colors.cyan.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, r, bgPaint);
    canvas.drawCircle(center, r, borderPaint);

    // Center point
    canvas.drawCircle(center, 4, Paint()..color = Colors.cyan.shade900);

    // Radius line
    final radiusEnd = Offset(center.dx + r, center.dy);
    canvas.drawLine(
      center,
      radiusEnd,
      Paint()
        ..color = Colors.red.shade600
        ..strokeWidth = 2.5,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: 'r = $radius',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx + r / 3, center.dy - 18));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 10. Painter Sudut (Angle Rays)
class AnglePainter extends CustomPainter {
  final int degrees;
  final String label;

  AnglePainter({required this.degrees, required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    final vertex = Offset(50, size.height - 35);
    final rayLength = size.width - 90;

    final rayPaint = Paint()
      ..color = Colors.deepOrange.shade800
      ..strokeWidth = 3;

    // Base horizontal ray
    canvas.drawLine(vertex, Offset(vertex.dx + rayLength, vertex.dy), rayPaint);

    // Angled ray
    final rad = -degrees * (pi / 180);
    final endX = vertex.dx + rayLength * cos(rad);
    final endY = vertex.dy + rayLength * sin(rad);
    canvas.drawLine(vertex, Offset(endX, endY), rayPaint);

    // Arc indicator
    final arcRect = Rect.fromCircle(center: vertex, radius: 35);
    canvas.drawArc(
      arcRect,
      0,
      rad,
      false,
      Paint()
        ..color = Colors.amber.shade700
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: '$degrees° ($label)',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepOrange),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(vertex.dx + 45, vertex.dy - 25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 11. Painter Timbangan Aljabar (Balance Scale)
class AlgebraBalancePainter extends CustomPainter {
  final String leftText;
  final String rightText;

  AlgebraBalancePainter({required this.leftText, required this.rightText});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    final linePaint = Paint()
      ..color = Colors.blueGrey.shade800
      ..strokeWidth = 3;

    // Base triangle fulcrum
    final fulcrum = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx - 15, cy + 30)
      ..lineTo(cx + 15, cy + 30)
      ..close();
    canvas.drawPath(fulcrum, Paint()..color = Colors.blueGrey.shade400);
    canvas.drawPath(fulcrum, linePaint);

    // Balance beam
    final beamY = cy - 5;
    canvas.drawLine(Offset(cx - 75, beamY), Offset(cx + 75, beamY), linePaint);

    final boxPaint = Paint()
      ..color = Colors.amber.shade100
      ..style = PaintingStyle.fill;
    final boxBorder = Paint()
      ..color = Colors.amber.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Left pan box
    final leftRect = Rect.fromLTWH(cx - 95, beamY - 35, 45, 35);
    canvas.drawRRect(RRect.fromRectAndRadius(leftRect, const Radius.circular(8)), boxPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(leftRect, const Radius.circular(8)), boxBorder);

    final tpLeft = TextPainter(
      text: TextSpan(text: leftText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown)),
      textDirection: TextDirection.ltr,
    )..layout();
    tpLeft.paint(canvas, Offset(leftRect.left + (leftRect.width - tpLeft.width) / 2, leftRect.top + (leftRect.height - tpLeft.height) / 2));

    // Right pan box
    final rightRect = Rect.fromLTWH(cx + 50, beamY - 35, 45, 35);
    canvas.drawRRect(RRect.fromRectAndRadius(rightRect, const Radius.circular(8)), boxPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rightRect, const Radius.circular(8)), boxBorder);

    final tpRight = TextPainter(
      text: TextSpan(text: rightText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown)),
      textDirection: TextDirection.ltr,
    )..layout();
    tpRight.paint(canvas, Offset(rightRect.left + (rightRect.width - tpRight.width) / 2, rightRect.top + (rightRect.height - tpRight.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 12. Painter Pola Kotak Berurutan (Pattern Boxes)
class PatternBoxesPainter extends CustomPainter {
  final List<String> sequence;

  PatternBoxesPainter({required this.sequence});

  @override
  void paint(Canvas canvas, Size size) {
    if (sequence.isEmpty) return;

    final boxCount = sequence.length;
    final boxWidth = 36.0;
    final boxHeight = 36.0;
    final gap = 14.0;

    final totalW = (boxCount * boxWidth) + ((boxCount - 1) * gap);
    final startX = (size.width - totalW) / 2;
    final startY = (size.height - boxHeight) / 2;

    final boxBg = Paint()..color = Colors.teal.shade50;
    final boxBorder = Paint()
      ..color = Colors.teal.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final arrowPaint = Paint()
      ..color = Colors.teal.shade900
      ..strokeWidth = 2;

    for (int i = 0; i < boxCount; i++) {
      final x = startX + i * (boxWidth + gap);
      final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(x, startY, boxWidth, boxHeight), const Radius.circular(8));
      canvas.drawRRect(rrect, boxBg);
      canvas.drawRRect(rrect, boxBorder);

      final val = sequence[i];
      final tp = TextPainter(
        text: TextSpan(
          text: val,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: val == '?' ? Colors.red.shade700 : Colors.teal.shade900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + (boxWidth - tp.width) / 2, startY + (boxHeight - tp.height) / 2));

      // Draw arrow to next box
      if (i < boxCount - 1) {
        final arrowStartX = x + boxWidth + 2;
        final arrowEndX = arrowStartX + gap - 4;
        final arrowY = startY + boxHeight / 2;
        canvas.drawLine(Offset(arrowStartX, arrowY), Offset(arrowEndX, arrowY), arrowPaint);
        canvas.drawLine(Offset(arrowEndX, arrowY), Offset(arrowEndX - 4, arrowY - 3), arrowPaint);
        canvas.drawLine(Offset(arrowEndX, arrowY), Offset(arrowEndX - 4, arrowY + 3), arrowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DefaultShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
