import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppOnboardingDialog extends StatefulWidget {
  final VoidCallback onComplete;

  const AppOnboardingDialog({
    super.key,
    required this.onComplete,
  });

  static void show(BuildContext context, {required VoidCallback onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppOnboardingDialog(onComplete: onComplete),
    );
  }

  @override
  State<AppOnboardingDialog> createState() => _AppOnboardingDialogState();
}

class _AppOnboardingDialogState extends State<AppOnboardingDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'emoji': '🎓',
      'badge': 'Standardisasi Kurikulum Merdeka & Nasional SD',
      'title': 'Bintang Pintar SD',
      'subtitle': 'Platform media pembelajaran dan latihan soal interaktif terstruktur untuk siswa SD Kelas 1 hingga 6, dirancang secara pedagogis untuk mengasah pemahaman materi dan ketangkasan berpikir anak.',
      'highlights': [
        '📘 100% Selaras Kurikulum SD (Matematika & Bahasa Inggris)',
        '🎯 Latihan Bertingkat Presisi (Tingkat Dasar, Sedang, & HOTS)',
        '⚡ Algoritma Generator Soal Dinamis (Bebas Soal Kembar/Ganda)',
      ],
      'gradient': [const Color(0xFF1E1B4B), const Color(0xFF312E81), const Color(0xFF4338CA)],
    },
    {
      'emoji': '📊',
      'badge': 'Media Pembelajaran Visual & Terukur',
      'title': 'Visualisasi Konsep & Evaluasi',
      'subtitle': 'Menyajikan konsep matematika dan kosa kata Bahasa Inggris melalui diagram visual 3D, piktogram, dan sistem evaluasi transparan dengan penandaan jawaban yang jelas.',
      'highlights': [
        '📐 Diagram Batang, Piktogram, Bangun 3D, & Timbangan Aljabar',
        '🔴 Evaluasi Mandiri Transparan (Penandaan Merah untuk Salah & Hijau)',
        '⏱️ Pengaturan Waktu Terukur (Penilaian 0 Poin jika Waktu Habis)',
      ],
      'gradient': [const Color(0xFF064E3B), const Color(0xFF047857), const Color(0xFF0D9488)],
    },
    {
      'emoji': '🛡️',
      'badge': 'Portal Orang Tua & Cetak Raport',
      'title': 'Portal Evaluasi & Raport PDF',
      'subtitle': 'Orang tua dapat memantau akumulasi skor dan perkembangan belajar anak secara real-time, mengunduh raport hasil belajar format PDF, serta mengelola kuis kustom.',
      'highlights': [
        '📄 Cetak & Unduh Raport Hasil Belajar Resmi Format PDF',
        '🔒 Keamanan Portal Orang Tua Dilindungi Kode PIN Keamanan',
        '📝 Fasilitas Tambah Soal Kustom Mandiri (Import CSV & Word)',
      ],
      'gradient': [const Color(0xFF311B92), const Color(0xFF512DA8), const Color(0xFF7E57C2)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 630),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.5), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 28,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Header Banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _onboardingPages[_currentPage]['gradient'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _onboardingPages[_currentPage]['emoji'] as String,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            _onboardingPages[_currentPage]['badge'] as String,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _onboardingPages[_currentPage]['title'] as String,
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Page View Body
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _onboardingPages[index];
                  final highlights = page['highlights'] as List<String>;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          page['subtitle'] as String,
                          style: const TextStyle(fontSize: 13.5, color: Color(0xFFCBD5E1), height: 1.45),
                        ),
                        const SizedBox(height: 18),

                        const Text(
                          'Keunggulan & Fitur Utama:',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                        ),
                        const SizedBox(height: 10),

                        ...highlights.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF334155), width: 1),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('✨ ', style: TextStyle(fontSize: 13)),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white, height: 1.35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer Dot Indicators & Navigation Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? const Color(0xFF38BDF8) : Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Action Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_currentPage < _onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: 300.ms,
                          curve: Curves.easeOut,
                        );
                      } else {
                        Navigator.pop(context);
                        widget.onComplete();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _onboardingPages.length - 1 ? 'Mulai Sekarang 🚀' : 'Lanjut ➔',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
