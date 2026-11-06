import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/user_profile_model.dart';
import '../models/user_stats_model.dart';
import '../models/parent_reward_model.dart';

class PdfReportService {
  static String _formatDate(DateTime dt) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  /// Generate dokumen PDF dalam bentuk bytes
  static Future<Uint8List> generateReportPdf({
    required UserProfile profile,
    required UserStats stats,
    required List<String> recommendations,
    required List<ParentReward> rewards,
  }) async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final dateStr = _formatDate(now);
    final accuracy = stats.accuracyRate;

    String predicateGrade;
    String predicateDescription;
    PdfColor predicateColor;

    if (accuracy >= 85) {
      predicateGrade = 'SANGAT BAIK (Grade A)';
      predicateDescription =
          'Siswa menunjukkan penguasaan materi yang sangat memuaskan, mandiri, dan konsisten.';
      predicateColor = PdfColors.green700;
    } else if (accuracy >= 70) {
      predicateGrade = 'BAIK (Grade B)';
      predicateDescription =
          'Siswa memiliki pemahaman materi yang baik dan mampu menyelesaikan soal dengan lancar.';
      predicateColor = PdfColors.blue700;
    } else if (accuracy >= 55) {
      predicateGrade = 'CUKUP (Grade C)';
      predicateDescription =
          'Siswa cukup memahami konsep dasar. Disarankan memperbanyak latihan pada materi yang menantang.';
      predicateColor = PdfColors.orange700;
    } else {
      predicateGrade = 'PERLU BIMBINGAN (Grade D)';
      predicateDescription =
          'Siswa memerlukan pendampingan orang tua dalam mengulang materi dasar dan latihan bertahap.';
      predicateColor = PdfColors.red700;
    }

    final primaryNavy = PdfColor.fromHex('#1E293B');
    final accentBlue = PdfColor.fromHex('#2563EB');
    final bgCard = PdfColor.fromHex('#F8FAFC');
    final borderCard = PdfColor.fromHex('#E2E8F0');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Header Banner
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: primaryNavy,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BINTANG PINTAR - RAPORT HASIL BELAJAR',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Laporan Perkembangan Akademik Siswa Kurikulum Merdeka',
                          style: pw.TextStyle(
                            color: PdfColors.grey400,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'TANGGAL CETAK',
                          style: pw.TextStyle(
                            color: PdfColors.grey400,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          dateStr,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // 2. Data Profil Siswa
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: borderCard, width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Nama Siswa / Anak',
                          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          profile.name.isNotEmpty ? profile.name : 'Bintang Pintar',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Jenjang & Kelas',
                          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          '${profile.gradeLevel} - Kelas ${profile.classNum}',
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Status Aktivitas Belajar',
                          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.green100,
                            borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                          ),
                          child: pw.Text(
                            'Aktif Belajar',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // 3. Ringkasan Statistik Belajar (4 Kartu)
              pw.Row(
                children: [
                  _buildStatCard(
                    title: 'Akurasi Jawaban',
                    value: '${accuracy.toStringAsFixed(1)}%',
                    sub: 'Tingkat Ketepatan',
                    color: accentBlue,
                  ),
                  pw.SizedBox(width: 10),
                  _buildStatCard(
                    title: 'Kuis Selesai',
                    value: '${stats.quizzesCompleted}',
                    sub: 'Sesi Latihan',
                    color: PdfColors.teal700,
                  ),
                  pw.SizedBox(width: 10),
                  _buildStatCard(
                    title: 'Total Bintang',
                    value: '${stats.totalStars} Bintang',
                    sub: 'Prestasi Kuis',
                    color: PdfColors.amber800,
                  ),
                  pw.SizedBox(width: 10),
                  _buildStatCard(
                    title: 'Total XP Belajar',
                    value: '${stats.totalXp} XP',
                    sub: 'Poin Pengalaman',
                    color: PdfColors.purple700,
                  ),
                ],
              ),

              pw.SizedBox(height: 14),

              // 4. Detail Statistik Pengerjaan Soal (Tabel)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: borderCard, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Rincian Pengerjaan Soal',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryNavy,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInlineDetail('Total Soal Dikerjakan', '${stats.totalQuestionsAnswered} Soal'),
                        _buildInlineDetail('Jawaban Benar', '${stats.totalCorrectAnswers} Soal'),
                        _buildInlineDetail(
                          'Jawaban Belum Tepat',
                          '${stats.totalQuestionsAnswered >= stats.totalCorrectAnswers ? stats.totalQuestionsAnswered - stats.totalCorrectAnswers : 0} Soal',
                        ),
                        _buildInlineDetail('Konsistensi Belajar', '${stats.streakDays} Hari Berturut-turut'),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // 5. Predikat & Analisis Hasil Belajar
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: predicateColor, width: 1.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Evaluasi Capaian Akademik:',
                          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                        ),
                        pw.Text(
                          predicateGrade,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: predicateColor,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      predicateDescription,
                      style: pw.TextStyle(fontSize: 10, color: primaryNavy),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // 6. Rekomendasi Belajar untuk Orang Tua
              pw.Text(
                'Saran & Rekomendasi Pendampingan Belajar:',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: borderCard, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: recommendations.isNotEmpty
                      ? recommendations.map((rec) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('• ', style: pw.TextStyle(color: accentBlue, fontWeight: pw.FontWeight.bold)),
                                pw.Expanded(
                                  child: pw.Text(rec, style: const pw.TextStyle(fontSize: 9.5)),
                                ),
                              ],
                            ),
                          );
                        }).toList()
                      : [
                          pw.Text(
                            'Pertahankan ritme belajar harian dengan menyelesaikan minimal 1 kuis topik per hari.',
                            style: const pw.TextStyle(fontSize: 9.5),
                          )
                        ],
                ),
              ),

              // 7. Target Reward Anak (Jika ada)
              if (rewards.isNotEmpty) ...[
                pw.SizedBox(height: 14),
                pw.Text(
                  'Target Hadiah (Motivasi Orang Tua):',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: bgCard,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    border: pw.Border.all(color: borderCard, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: rewards.take(3).map((r) {
                      final isAchieved = stats.totalStars >= r.targetStars;
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Target: ${r.title}', style: const pw.TextStyle(fontSize: 9.5)),
                            pw.Text(
                              isAchieved
                                  ? 'TERCAPAI (${r.targetStars} Bintang)'
                                  : 'Target: ${r.targetStars} Bintang (${r.targetStars - stats.totalStars} lagi)',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: isAchieved ? PdfColors.green700 : PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              pw.Spacer(),

              // 8. Tanda Tangan Orang Tua / Wali
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Mengetahui,',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 40),
                      pw.Container(width: 140, height: 1, color: PdfColors.grey500),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Orang Tua / Wali Siswa',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Dicetak dari Aplikasi Bintang Pintar',
                        style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Sah sebagai laporan belajar mandiri',
                        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildStatCard({
    required String title,
    required String value,
    required String sub,
    required PdfColor color,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#F8FAFC'),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0'), width: 1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              sub,
              style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildInlineDetail(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#1E293B')),
        ),
      ],
    );
  }

  /// Langsung menampilkan Preview PDF di layar Android (Native PDF Print/Preview)
  static Future<void> previewReport({
    required BuildContext context,
    required UserProfile profile,
    required UserStats stats,
    required List<String> recommendations,
    required List<ParentReward> rewards,
  }) async {
    final cleanName = profile.name.replaceAll(RegExp(r'[^\w\s]+'), '').trim().replaceAll(' ', '_');
    final filename = 'Raport_Belajar_${cleanName.isNotEmpty ? cleanName : "Anak"}.pdf';

    await Printing.layoutPdf(
      name: filename,
      onLayout: (PdfPageFormat format) async {
        return generateReportPdf(
          profile: profile,
          stats: stats,
          recommendations: recommendations,
          rewards: rewards,
        );
      },
    );
  }

  /// Membuka dialog Share / Simpan PDF ke File Manager, Drive, atau WhatsApp
  static Future<void> shareReport({
    required BuildContext context,
    required UserProfile profile,
    required UserStats stats,
    required List<String> recommendations,
    required List<ParentReward> rewards,
  }) async {
    final cleanName = profile.name.replaceAll(RegExp(r'[^\w\s]+'), '').trim().replaceAll(' ', '_');
    final filename = 'Raport_Belajar_${cleanName.isNotEmpty ? cleanName : "Anak"}.pdf';

    final bytes = await generateReportPdf(
      profile: profile,
      stats: stats,
      recommendations: recommendations,
      rewards: rewards,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: filename,
    );
  }

  /// Menampilkan pilihan aksi kepada orang tua (Preview & Cetak, atau Simpan/Kirim)
  static void showDownloadOptionsModal({
    required BuildContext context,
    required UserProfile profile,
    required UserStats stats,
    required List<String> recommendations,
    required List<ParentReward> rewards,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Raport Belajar PDF Anak 📄✨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih cara membuka atau menyimpan raport hasil belajar:',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Opsi 1: Preview & Cetak
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  tileColor: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: Color(0xFF2563EB)),
                  ),
                  title: const Text(
                    'Buka & Cetak PDF (Preview)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Lihat tampilan raport di layar & simpan langsung sebagai PDF',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(ctx);
                    previewReport(
                      context: context,
                      profile: profile,
                      stats: stats,
                      recommendations: recommendations,
                      rewards: rewards,
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Opsi 2: Bagikan / Simpan File
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  tileColor: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.teal.shade100),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share, color: Colors.teal),
                  ),
                  title: const Text(
                    'Simpan / Bagikan File PDF',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Kirim ke WhatsApp, simpan ke Google Drive atau File Manager',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(ctx);
                    shareReport(
                      context: context,
                      profile: profile,
                      stats: stats,
                      recommendations: recommendations,
                      rewards: rewards,
                    );
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
