import '../models/question_model.dart';

class QuestionBank {
  static final List<Question> initialQuestions = [
    // =========================================================================
    // TEMA 1: BILANGAN DAN OPERASI HITUNG (19 Sub-Topik Matrix)
    // =========================================================================
    
    // 1. Pengenalan Bilangan dan Nilai Tempat
    Question(
      id: 'bil_001',
      gradeLevel: 'Umum',
      classNum: 1,
      subject: 'Matematika',
      topic: 'Pengenalan Bilangan dan Nilai Tempat',
      level: 'Dasar',
      questionText: 'Pada bilangan 3.582, angka 5 menempati nilai tempat .....',
      options: ['Ribuan', 'Ratusan', 'Puluhan', 'Satuan'],
      correctAnswerIndex: 1,
      explanation: 'Angka 3 = Ribuan (3.000), 5 = Ratusan (500), 8 = Puluhan (80), 2 = Satuan (2).',
    ),
    Question(
      id: 'bil_002',
      gradeLevel: 'Umum',
      classNum: 2,
      subject: 'Matematika',
      topic: 'Pengenalan Bilangan dan Nilai Tempat',
      level: 'Sedang',
      questionText: 'Manakah urutan bilangan berikut dari yang terkecil hingga terbesar?',
      options: ['1.250, 1.150, 1.350', '1.150, 1.250, 1.350', '1.350, 1.250, 1.150', '1.250, 1.350, 1.150'],
      correctAnswerIndex: 1,
      explanation: '1.150 < 1.250 < 1.350 adalah urutan yang benar dari terkecil ke terbesar.',
    ),
    Question(
      id: 'bil_003',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Pengenalan Bilangan dan Nilai Tempat',
      level: 'HOTS',
      questionText: 'Aku adalah bilangan 4 angka. Angka ribuanku 7, puluhanku 4, dan jumlah seluruh angkaku adalah 15. Bilangan manakah aku?',
      options: ['7.044', '7.404', '7.242', '7.341'],
      correctAnswerIndex: 0,
      explanation: '7 + 0 + 4 + 4 = 15. Ribuan = 7, Puluhan = 4.',
    ),

    // 2. Penjumlahan & Pengurangan Dasar
    Question(
      id: 'bil_004',
      gradeLevel: 'Umum',
      classNum: 1,
      subject: 'Matematika',
      topic: 'Penjumlahan & Pengurangan Dasar',
      level: 'Dasar',
      questionText: 'Berapakah hasil dari 14 + 8 ?',
      options: ['20', '21', '22', '23'],
      correctAnswerIndex: 2,
      explanation: '14 + 8 = 22.',
    ),
    Question(
      id: 'bil_005',
      gradeLevel: 'Umum',
      classNum: 3,
      subject: 'Matematika',
      topic: 'Penjumlahan & Pengurangan Dasar',
      level: 'Sedang',
      questionText: 'Hasil dari 450 - 185 adalah .....',
      options: ['255', '265', '275', '285'],
      correctAnswerIndex: 1,
      explanation: '450 - 185 = 265.',
    ),
    Question(
      id: 'bil_006',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Penjumlahan & Pengurangan Dasar',
      level: 'HOTS',
      questionText: 'Hasil dari 85 + 34 - 27 adalah .....',
      options: ['82', '92', '119', '146'],
      correctAnswerIndex: 1,
      explanation: 'Hitung berurutan: 85 + 34 = 119, lalu 119 - 27 = 92.',
    ),

    // 3. Perkalian & Pembagian (KABATAKU)
    Question(
      id: 'bil_007',
      gradeLevel: 'Umum',
      classNum: 2,
      subject: 'Matematika',
      topic: 'Perkalian & Pembagian',
      level: 'Dasar',
      questionText: 'Berapakah hasil perkalian 7 × 6 ?',
      options: ['36', '40', '42', '48'],
      correctAnswerIndex: 2,
      explanation: '7 × 6 = 42.',
    ),
    Question(
      id: 'bil_008',
      gradeLevel: 'Umum',
      classNum: 3,
      subject: 'Matematika',
      topic: 'Perkalian & Pembagian',
      level: 'Sedang',
      questionText: 'Jika 72 buah apel dibagi rata kepada 8 anak, masing-masing anak mendapat ..... buah.',
      options: ['7', '8', '9', '10'],
      correctAnswerIndex: 2,
      explanation: '72 ÷ 8 = 9.',
    ),
    Question(
      id: 'bil_009',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Perkalian & Pembagian',
      level: 'HOTS',
      questionText: 'Hasil dari 25 + 15 × 4 - 20 adalah .....',
      options: ['65', '140', '120', '85'],
      correctAnswerIndex: 0,
      explanation: 'Utamakan perkalian (KABATAKU): 15 × 4 = 60. Lalu 25 + 60 - 20 = 85 - 20 = 65.',
    ),

    // 4. Pecahan, Desimal, dan Persen
    Question(
      id: 'bil_010',
      gradeLevel: 'Umum',
      classNum: 3,
      subject: 'Matematika',
      topic: 'Pecahan, Desimal, dan Persen',
      level: 'Dasar',
      questionText: 'Berapakah nilai pecahan dari bagian kue yang diarsir pada gambar lingkaran berikut?',
      visualType: 'fraction_pie',
      visualData: const {'slices': 4, 'shaded': 3},
      visualLabel: 'Gambar Model Kue Pecahan 3/4',
      options: ['1/4', '2/4', '3/4', '4/4'],
      correctAnswerIndex: 2,
      explanation: 'Ada 3 potongan kue yang diarsir dari total 4 potongan sama besar, sehingga nilainya adalah 3/4.',
    ),
    Question(
      id: 'bil_011',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Pecahan, Desimal, dan Persen',
      level: 'Sedang',
      questionText: 'Bentuk persen dari 3/4 adalah .....',
      options: ['25%', '50%', '75%', '80%'],
      correctAnswerIndex: 2,
      explanation: '3/4 × 100% = 75%.',
    ),
    Question(
      id: 'bil_012',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Pecahan, Desimal, dan Persen',
      level: 'HOTS',
      questionText: 'Hasil penjumlahan 2/5 + 0,4 adalah .....',
      options: ['0,6', '0,8', '1,0', '0,45'],
      correctAnswerIndex: 1,
      explanation: '2/5 = 0,4. Maka 0,4 + 0,4 = 0,8.',
    ),

    // 5. Kelipatan dan Faktor (KPK & FPB)
    Question(
      id: 'bil_013',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Kelipatan dan Faktor (KPK & FPB)',
      level: 'Dasar',
      questionText: 'Manakah dari bilangan berikut yang merupakan bilangan prima?',
      options: ['9', '15', '17', '21'],
      correctAnswerIndex: 2,
      explanation: '17 hanya bisa dibagi 1 dan 17 sendiri, sehingga merupakan bilangan prima.',
    ),
    Question(
      id: 'bil_014',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Kelipatan dan Faktor (KPK & FPB)',
      level: 'Sedang',
      questionText: 'KPK dari 12 dan 18 adalah .....',
      options: ['24', '36', '48', '72'],
      correctAnswerIndex: 1,
      explanation: 'Kelipatan 12: 12, 24, 36... Kelipatan 18: 18, 36... KPK terkecil adalah 36.',
    ),
    Question(
      id: 'bil_015',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Kelipatan dan Faktor (KPK & FPB)',
      level: 'HOTS',
      questionText: 'Ibu memiliki 24 kue cokelat dan 36 kue keju yang akan dimasukkan ke kotak sama banyak. Berapa kotak terbanyak yang dibutuhkan? (FPB)',
      options: ['6', '8', '12', '18'],
      correctAnswerIndex: 2,
      explanation: 'FPB dari 24 dan 36 adalah 12.',
    ),

    // 6. Bilangan Bulat Negatif
    Question(
      id: 'bil_016',
      gradeLevel: 'Umum',
      classNum: 6,
      subject: 'Matematika',
      topic: 'Bilangan Bulat Negatif',
      level: 'Dasar',
      questionText: 'Suhu 5 derajat di bawah nol ditulis .....',
      options: ['5°C', '-5°C', '0,5°C', '-0,5°C'],
      correctAnswerIndex: 1,
      explanation: 'Suhu di bawah nol ditulis menggunakan tanda negatif (-5°C).',
    ),
    Question(
      id: 'bil_017',
      gradeLevel: 'Umum',
      classNum: 6,
      subject: 'Matematika',
      topic: 'Bilangan Bulat Negatif',
      level: 'HOTS',
      questionText: 'Hasil dari (-8) + 15 - (-3) adalah .....',
      options: ['4', '10', '14', '7'],
      correctAnswerIndex: 1,
      explanation: '(-8) + 15 = 7. Lalu 7 - (-3) = 7 + 3 = 10.',
    ),

    // =========================================================================
    // TEMA 2: GEOMETRI
    // =========================================================================

    // 7. Pengenalan Bentuk dan Sifat Dasar
    Question(
      id: 'geo_001',
      gradeLevel: 'Umum',
      classNum: 2,
      subject: 'Matematika',
      topic: 'Pengenalan Bentuk dan Sifat Dasar',
      level: 'Dasar',
      questionText: 'Berapakah keliling dari bangun persegi panjang berikut jika p = 12 cm dan l = 5 cm?',
      visualType: 'shape_rectangle',
      visualData: const {'length': '12 cm', 'width': '5 cm'},
      visualLabel: 'Persegi Panjang',
      options: ['17 cm', '24 cm', '34 cm', '60 cm'],
      correctAnswerIndex: 2,
      explanation: 'Keliling persegi panjang = 2 × (p + l) = 2 × (12 + 5) = 2 × 17 = 34 cm.',
    ),
    Question(
      id: 'geo_002',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Pengenalan Bentuk dan Sifat Dasar',
      level: 'Sedang',
      questionText: 'Jumlah rusuk pada sebuah kubus adalah .....',
      options: ['6', '8', '12', '16'],
      correctAnswerIndex: 2,
      explanation: 'Kubus memiliki 12 rusuk sama panjang.',
    ),

    // 8. Pengukuran Sudut dan Simetri
    Question(
      id: 'geo_003',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Pengukuran Sudut dan Simetri',
      level: 'Dasar',
      questionText: 'Pukul berapakah yang ditunjukkan oleh jarum jam analog di bawah ini?',
      visualType: 'analog_clock',
      visualData: const {'hour': 7, 'minute': 30},
      visualLabel: 'Jam Dinding Analog',
      options: ['06:30', '07:30', '08:30', '07:00'],
      correctAnswerIndex: 1,
      explanation: 'Jarum pendek berada di antara angka 7 dan 8, sedangkan jarum panjang di angka 6 (30 menit). Waktu menunjukkan pukul 07:30.',
    ),

    // 9. Keliling dan Luas Bangun Datar
    Question(
      id: 'geo_004',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Keliling dan Luas Bangun Datar',
      level: 'Sedang',
      questionText: 'Sebuah persegi memiliki panjang sisi 8 cm. Luas persegi tersebut adalah .....',
      options: ['32 cm²', '64 cm²', '16 cm²', '48 cm²'],
      correctAnswerIndex: 1,
      explanation: 'Luas persegi = s × s = 8 × 8 = 64 cm².',
    ),
    Question(
      id: 'geo_005',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Keliling dan Luas Bangun Datar',
      level: 'HOTS',
      questionText: 'Hitunglah luas segitiga yang memiliki alas a = 8 cm dan tinggi t = 6 cm seperti pada gambar berikut!',
      visualType: 'shape_triangle',
      visualData: const {'base': '8 cm', 'height': '6 cm'},
      visualLabel: 'Diagram Segitiga',
      options: ['48 cm²', '24 cm²', '14 cm²', '32 cm²'],
      correctAnswerIndex: 1,
      explanation: 'Luas segitiga = 1/2 × alas × tinggi = 1/2 × 8 × 6 = 24 cm².',
    ),

    // 10. Bangun Ruang Lanjutan
    Question(
      id: 'geo_006',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Bangun Ruang Lanjutan',
      level: 'Sedang',
      questionText: 'Berapakah jari-jari r dan tinggi t dari bangun ruang tabung di bawah ini?',
      visualType: 'shape_cylinder',
      visualData: const {'radius': '7 cm', 'height': '10 cm'},
      visualLabel: 'Bangun Ruang Tabung',
      options: ['r = 7 cm, t = 10 cm', 'r = 10 cm, t = 7 cm', 'r = 14 cm, t = 10 cm', 'r = 7 cm, t = 20 cm'],
      correctAnswerIndex: 0,
      explanation: 'Berdasarkan label diagram tabung, r = 7 cm dan t = 10 cm.',
    ),
    Question(
      id: 'geo_007',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Bangun Ruang Lanjutan',
      level: 'HOTS',
      questionText: 'Sebuah balok berukuran panjang 10 cm, lebar 5 cm, dan tinggi 4 cm. Volume balok tersebut adalah .....',
      options: ['200 cm³', '100 cm³', '50 cm³', '19 cm³'],
      correctAnswerIndex: 0,
      explanation: 'Volume balok = p × l × t = 10 × 5 × 4 = 200 cm³.',
    ),

    // =========================================================================
    // TEMA 3: PENGUKURAN
    // =========================================================================

    // 11. Pengukuran Dasar dan Satuan
    Question(
      id: 'peng_001',
      gradeLevel: 'Umum',
      classNum: 3,
      subject: 'Matematika',
      topic: 'Pengukuran Dasar dan Satuan',
      level: 'Dasar',
      questionText: '1 jam sama dengan berapa menit?',
      options: ['30 menit', '60 menit', '90 menit', '100 menit'],
      correctAnswerIndex: 1,
      explanation: '1 jam = 60 menit.',
    ),

    // 12. Hubungan Antarsatuan / Konversi
    Question(
      id: 'peng_002',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Hubungan Antarsatuan / Konversi',
      level: 'Sedang',
      questionText: '3 kilometer (km) sama dengan berapa meter (m)?',
      options: ['30 m', '300 m', '3.000 m', '30.000 m'],
      correctAnswerIndex: 2,
      explanation: '1 km = 1.000 m, jadi 3 km = 3.000 m.',
    ),

    // 13. Pengukuran Gabungan (Kecepatan & Debit)
    Question(
      id: 'peng_003',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Pengukuran Gabungan',
      level: 'HOTS',
      questionText: 'Sebuah mobil menempuh jarak 120 km dalam waktu 2 jam. Berapakah kecepatan rata-rata mobil tersebut?',
      options: ['50 km/jam', '60 km/jam', '70 km/jam', '80 km/jam'],
      correctAnswerIndex: 1,
      explanation: 'Kecepatan = Jarak / Waktu = 120 km / 2 jam = 60 km/jam.',
    ),

    // =========================================================================
    // TEMA 4: ANALISIS DATA DAN PELUANG
    // =========================================================================

    // 14-16. Statistika (Mean, Median, Modus)
    Question(
      id: 'stat_001',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Pengolahan Data Lanjutan & Statistika Dasar',
      level: 'Sedang',
      questionText: 'Diberikan data nilai ujian: 6, 7, 7, 8, 8, 8, 9. Nilai yang paling sering muncul (modus) adalah .....',
      options: ['6', '7', '8', '9'],
      correctAnswerIndex: 2,
      explanation: 'Modus adalah data dengan frekuensi terbanyak. Angka 8 muncul 3 kali.',
    ),
    Question(
      id: 'stat_002',
      gradeLevel: 'Umum',
      classNum: 6,
      subject: 'Matematika',
      topic: 'Pengolahan Data Lanjutan & Statistika Dasar',
      level: 'HOTS',
      questionText: 'Nilai rata-rata (mean) dari data: 70, 80, 90, 100 adalah .....',
      options: ['80', '85', '90', '95'],
      correctAnswerIndex: 1,
      explanation: 'Rata-rata = (70 + 80 + 90 + 100) / 4 = 340 / 4 = 85.',
    ),

    // =========================================================================
    // TEMA 5: ALJABAR SEDERHANA (POLA BILANGAN DAN RASIO)
    // =========================================================================

    // 14. Pengumpulan dan Pengelompokan Dasar
    Question(
      id: 'stat_003',
      gradeLevel: 'Umum',
      classNum: 3,
      subject: 'Matematika',
      topic: 'Pengumpulan dan Pengelompokan Dasar',
      level: 'Dasar',
      questionText: 'Turus "|||| ||" menunjukkan frekuensi jumlah benda sebanyak .....',
      options: ['5', '6', '7', '8'],
      correctAnswerIndex: 2,
      explanation: 'Satu kelompok turus terikat "||||" bernilai 5, ditambah 2 garis menjadi 7.',
    ),

    // 15. Penyajian Data Visual Dasar
    Question(
      id: 'stat_004',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Penyajian Data Visual Dasar',
      level: 'Sedang',
      questionText: 'Berdasarkan diagram piktogram di atas (1 🍎 = 10 buah), jika terdapat 4 gambar 🍎, berapakah jumlah apel seluruhnya?',
      visualType: 'pictogram',
      visualData: const {
        'category': 'Penjualan Buah Apel',
        'count': 40,
        'scale': 10,
        'symbol': '🍎',
      },
      visualLabel: 'Piktogram Penjualan Apel',
      options: ['14 buah', '30 buah', '40 buah', '50 buah'],
      correctAnswerIndex: 2,
      explanation: '4 gambar × 10 buah = 40 buah apel.',
    ),
    Question(
      id: 'stat_005',
      gradeLevel: 'Umum',
      classNum: 5,
      subject: 'Matematika',
      topic: 'Penyajian Data Visual Dasar',
      level: 'HOTS',
      questionText: 'Perhatikan diagram batang panen di atas! Berapakah total hasil panen dari hari Senin hingga Rabu?',
      visualType: 'bar_chart',
      visualData: const {
        'categories': ['Senin', 'Selasa', 'Rabu'],
        'values': [20, 35, 25],
      },
      visualLabel: 'Diagram Batang Panen (kg)',
      options: ['60 kg', '70 kg', '80 kg', '90 kg'],
      correctAnswerIndex: 2,
      explanation: 'Total panen = 20 + 35 + 25 = 80 kg.',
    ),

    // 17. Pengenalan Pola Gambar dan Bentuk
    Question(
      id: 'alj_003',
      gradeLevel: 'Umum',
      classNum: 2,
      subject: 'Matematika',
      topic: 'Pengenalan Pola Gambar dan Bentuk',
      level: 'Dasar',
      questionText: 'Perhatikan urutan pola kotak angka di atas: 2, 4, 6, [ ? ]. Angka berikutnya adalah .....',
      visualType: 'pattern_boxes',
      visualData: const {
        'sequence': ['2', '4', '6', '?'],
      },
      visualLabel: 'Pola Gambar Loncat (+2)',
      options: ['7', '8', '9', '10'],
      correctAnswerIndex: 1,
      explanation: 'Pola bertambah 2 (+2): 6 + 2 = 8.',
    ),

    // 18. Pola Bilangan & Aljabar
    Question(
      id: 'alj_004',
      gradeLevel: 'Umum',
      classNum: 4,
      subject: 'Matematika',
      topic: 'Pola Bilangan',
      level: 'Sedang',
      questionText: 'Perhatikan timbangan seimbang di atas! Jika x + 3 = 7, berapakah nilai x?',
      visualType: 'algebra_balance',
      visualData: const {
        'leftText': 'x + 3',
        'rightText': '7',
      },
      visualLabel: 'Timbangan Aljabar (Seimbang)',
      options: ['2', '3', '4', '5'],
      correctAnswerIndex: 2,
      explanation: 'x + 3 = 7 ➔ x = 7 - 3 = 4.',
    ),
  ];

  /// Filter questions matching gradeLevel, classNum, topic, or level
  static List<Question> getQuestions({
    required String gradeLevel,
    required int classNum,
    String? mathTopic,
    String? level,
  }) {
    return initialQuestions.where((q) {
      final matchTopic = mathTopic == null ||
          q.topic.toLowerCase().trim() == mathTopic.toLowerCase().trim() ||
          q.topic.toLowerCase().contains(mathTopic.toLowerCase().trim());
      final matchLevel = level == null || q.level == level;
      return matchTopic && matchLevel;
    }).toList();
  }
}
