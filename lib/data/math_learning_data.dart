import '../models/math_theme_model.dart';

class MathLearningData {
  static const List<MathTheme> themes = [
    // -------------------------------------------------------------------------
    // TEMA 1: BILANGAN DAN OPERASI HITUNG
    // -------------------------------------------------------------------------
    MathTheme(
      id: 'tema_bilangan',
      title: 'Bilangan dan Operasi Hitung',
      description: 'Memahami nilai tempat, KABATAKU, pecahan, KPK/FPB, dan bilangan bulat negatif.',
      iconEmoji: '🔢',
      themeColorHex: '#3A86FF',
      topics: [
        MathTopic(
          id: 'topik_nilai_tempat',
          title: 'Pengenalan Bilangan dan Nilai Tempat',
          description: 'Memahami susunan ribuan, ratusan, puluhan, dan satuan.',
          summaryContent:
              'Setiap angka dalam sebuah bilangan memiliki nilai tempat tertentu bergantung pada posisinya:\n'
              '• Satuan = Paling kanan (1-9)\n'
              '• Puluhan = Angka kedua dari kanan (10-90)\n'
              '• Ratusan = Angka ketiga dari kanan (100-900)\n'
              '• Ribuan = Angka keempat dari kanan (1.000-9.000)',
          keyFormulas: [
            'Nilai Tempat = Angka × Nilai Posisi',
            '3.582 = 3.000 (Ribuan) + 500 (Ratusan) + 80 (Puluhan) + 2 (Satuan)',
          ],
          exampleProblem: 'Pada bilangan 4.752, manakah angka yang menempati nilai tempat Ratusan?',
          exampleSolution: 'Angka 7 menempati nilai tempat Ratusan (nilainya 700).',
        ),
        MathTopic(
          id: 'topik_penjumlahan_pengurangan',
          title: 'Penjumlahan & Pengurangan Dasar',
          description: 'Operasi hitung tambah dan kurang dengan teknik menyimpan dan meminjam.',
          summaryContent:
              'Penjumlahan menambah nilai suatu kelompok, sedangkan pengurangan mengurangi nilai kelompok.\n'
              '• Penjumlahan bersusun: Jumlahkan dari kolom satuan terkanan.\n'
              '• Pengurangan bersusun: Jika angka atas lebih kecil, pinjam 1 dari puluhan sebelah kiri.',
          keyFormulas: [
            'Penjumlahan: a + b = c',
            'Pengurangan: c - b = a',
          ],
          exampleProblem: 'Berapakah hasil dari 450 - 185?',
          exampleSolution: '450 - 185 = 265.',
        ),
        MathTopic(
          id: 'topik_perkalian_pembagian',
          title: 'Perkalian & Pembagian',
          description: 'Konsep penjumlahan berulang, perkalian susun, dan pembagian KABATAKU.',
          summaryContent:
              'Perkalian adalah penjumlahan berulang dari bilangan yang sama (misal 3 × 4 = 4 + 4 + 4 = 12).\n'
              'Pembagian adalah pengurangan berulang sampai habis (12 ÷ 4 = 3).\n'
              'Aturan KABATAKU: Dahulukan Perkalian & Pembagian sebelum Penjumlahan & Pengurangan!',
          keyFormulas: [
            'a × b = b + b + ... (sebanyak a kali)',
            'Aturan KABATAKU: (× dan ÷) > (+ dan -)',
          ],
          exampleProblem: 'Hitunglah hasil dari 25 + 15 × 4 - 20!',
          exampleSolution: 'Dahulukan perkalian: 15 × 4 = 60. Lalu 25 + 60 - 20 = 85 - 20 = 65.',
        ),
        MathTopic(
          id: 'topik_pecahan_desimal',
          title: 'Pecahan, Desimal, dan Persen',
          description: 'Mengubah bentuk pecahan biasa, campuran, desimal, dan persentase.',
          summaryContent:
              'Pecahan menggambarkan bagian dari keseluruhan.\n'
              '• Pembilang (atas) / Penyebut (bawah).\n'
              '• Mengubah Pecahan ke Desimal: Bagi pembilang dengan penyebut (1/2 = 0,5).\n'
              '• Mengubah Pecahan ke Persen: Kalikan pecahan dengan 100% (3/4 × 100% = 75%).',
          keyFormulas: [
            'Persen (%) = Pecahan × 100%',
            '3/4 = 0,75 = 75%',
          ],
          exampleProblem: 'Berapakah bentuk persen dari pecahan 3/4?',
          exampleSolution: '3/4 × 100% = 75%.',
        ),
        MathTopic(
          id: 'topik_kpk_fpb',
          title: 'Kelipatan dan Faktor (KPK & FPB)',
          description: 'Menentukan bilangan prima, KPK (Kelipatan Terkecil), dan FPB (Faktor Terbesar).',
          summaryContent:
              '• Faktor adalah bilangan yang dapat membagi habis suatu bilangan.\n'
              '• Bilangan Prima: Bilangan yang hanya memiliki 2 faktor (1 dan dirinya sendiri), seperti 2, 3, 5, 7, 11, 17.\n'
              '• KPK digunakan untuk jadwal pertemuan berulang bersama.\n'
              '• FPB digunakan untuk membagi benda ke dalam wadah sama banyak.',
          keyFormulas: [
            'FPB = Cari faktor persekutuan terbesar',
            'KPK = Cari kelipatan persekutuan terkecil',
          ],
          exampleProblem: 'Tentukan FPB dari 24 kue cokelat dan 36 kue keju!',
          exampleSolution: 'Faktor 24: 1, 2, 3, 4, 6, 8, 12, 24. Faktor 36: 1, 2, 3, 4, 6, 9, 12, 18, 36. FPB terbesar adalah 12.',
        ),
        MathTopic(
          id: 'topik_bilangan_bulat_negatif',
          title: 'Bilangan Bulat Negatif',
          description: 'Memahami garis bilangan, suhu di bawah nol, dan garis koordinat negatif.',
          summaryContent:
              'Bilangan bulat mencakup bilangan positif, nol, dan bilangan negatif.\n'
              '• Semakin ke kiri di garis bilangan, nilainya semakin kecil (-10 < -2).\n'
              '• Aturan Tanda: (-) ketemu (-) menjadi (+). Misal 7 - (-3) = 7 + 3 = 10.',
          keyFormulas: [
            'a - (-b) = a + b',
            '(-a) + b = b - a',
          ],
          exampleProblem: 'Berapakah hasil dari (-8) + 15 - (-3)?',
          exampleSolution: '(-8) + 15 = 7. Lalu 7 - (-3) = 7 + 3 = 10.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 2: GEOMETRI
    // -------------------------------------------------------------------------
    MathTheme(
      id: 'tema_geometri',
      title: 'Geometri',
      description: 'Mengenal bentuk 2D & 3D, sudut, keliling, serta luas dan volume.',
      iconEmoji: '📐',
      themeColorHex: '#8338EC',
      topics: [
        MathTopic(
          id: 'topik_bentuk_sifat',
          title: 'Pengenalan Bentuk dan Sifat Dasar',
          description: 'Jumlah sisi, rusuk, titik sudut pada bangun datar dan bangun ruang.',
          summaryContent:
              'Bangun Datar (2D) memiliki panjang dan lebar (Segitiga, Persegi, Lingkaran).\n'
              'Bangun Ruang (3D) memiliki panjang, lebar, dan tinggi serta volume (Kubus, Balok, Tabung, Kerucut).\n'
              '• Segitiga memilki 3 sisi dan 3 titik sudut.\n'
              '• Kubus memiliki 6 sisi persegi, 12 rusuk sama panjang, dan 8 titik sudut.',
          keyFormulas: [
            'Rusuk Kubus = 12',
            'Titik Sudut Kubus = 8',
          ],
          exampleProblem: 'Berapakah jumlah titik sudut dan rusuk pada sebuah kubus?',
          exampleSolution: 'Kubus memiliki 8 titik sudut dan 12 rusuk.',
        ),
        MathTopic(
          id: 'topik_sudut_simetri',
          title: 'Pengukuran Sudut dan Simetri',
          description: 'Memahami sudut lancip, siku-siku, tumpul, dan simetri lipat.',
          summaryContent:
              'Sudut dibentuk oleh dua garis lurus yang berpotongan di satu titik:\n'
              '• Sudut Lancip: Besarnya kurang dari 90° (< 90°)\n'
              '• Sudut Siku-siku: Besarnya persis 90° (= 90°)\n'
              '• Sudut Tumpul: Besarnya lebih dari 90° (> 90° dan < 180°)\n'
              '• Jam 03:00 menunjukkan sudut siku-siku persis 90°.',
          keyFormulas: [
            'Sudut Siku-siku = 90°',
            'Sudut Lurus = 180°',
          ],
          exampleProblem: 'Sudut yang besarnya tepat 90 derajat dinamakan sudut...',
          exampleSolution: 'Dinamakan Sudut Siku-siku.',
        ),
        MathTopic(
          id: 'topik_keliling_luas',
          title: 'Keliling dan Luas Bangun Datar',
          description: 'Rumus keliling dan luas persegi, persegi panjang, dan segitiga.',
          summaryContent:
              '• Keliling adalah jumlah seluruh panjang sisi luar bangun datar.\n'
              '• Luas adalah daerah permukaan yang tertutup oleh bangun datar.\n'
              '• Luas Persegi = Sisi × Sisi\n'
              '• Luas Persegi Panjang = Panjang × Lebar\n'
              '• Luas Segitiga = 1/2 × Alas × Tinggi',
          keyFormulas: [
            'Keliling Persegi Panjang = 2 × (p + l)',
            'Luas Segitiga = 1/2 × a × t',
          ],
          exampleProblem: 'Berapakah luas segitiga yang memiliki alas 8 cm dan tinggi 6 cm?',
          exampleSolution: 'Luas = 1/2 × 8 × 6 = 24 cm².',
        ),
        MathTopic(
          id: 'topik_bangun_ruang',
          title: 'Bangun Ruang Lanjutan',
          description: 'Menghitung volume balok, kubus, dan luas permukaan tabung.',
          summaryContent:
              'Volume menyatakan kapasitas isi ruang dari sebuah benda 3 dimensi.\n'
              '• Volume Kubus = s × s × s (s³)\n'
              '• Volume Balok = Panjang × Lebar × Tinggi (p × l × t)\n'
              '• Tabung memiliki 2 alas lingkaran identik dan 1 selimut melengkung.',
          keyFormulas: [
            'Volume Balok = p × l × t',
            'Volume Kubus = s³',
          ],
          exampleProblem: 'Sebuah balok memiliki panjang 10 cm, lebar 5 cm, dan tinggi 4 cm. Hitunglah volumenya!',
          exampleSolution: 'Volume = 10 × 5 × 4 = 200 cm³.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 3: PENGUKURAN
    // -------------------------------------------------------------------------
    MathTheme(
      id: 'tema_pengukuran',
      title: 'Pengukuran',
      description: 'Pengukuran panjang, berat, waktu, volume cair, dan konversi satuan.',
      iconEmoji: '📏',
      themeColorHex: '#FF006E',
      topics: [
        MathTopic(
          id: 'topik_pengukuran_dasar',
          title: 'Pengukuran Dasar dan Satuan',
          description: 'Mengenal penggaris, timbangan, jam analog, dan pengukur volume.',
          summaryContent:
              '• Satuan Panjang: Meter (m), Sentimeter (cm), Milimeter (mm).\n'
              '• Satuan Berat/Massa: Kilogram (kg), Gram (g).\n'
              '• Satuan Waktu: Jam, Menit, Detik (1 jam = 60 menit = 3.600 detik).',
          keyFormulas: [
            '1 m = 100 cm',
            '1 kg = 1.000 g',
            '1 jam = 60 menit',
          ],
          exampleProblem: 'Berapa menitkah waktu yang setara dengan 2 jam 30 menit?',
          exampleSolution: '(2 × 60) + 30 = 120 + 30 = 150 menit.',
        ),
        MathTopic(
          id: 'topik_konversi_satuan',
          title: 'Hubungan Antarsatuan / Konversi',
          description: 'Tangga satuan panjang (km, hm, dam, m, dm, cm, mm) dan berat.',
          summaryContent:
              'Setiap turun 1 tangga dikalikan 10 (× 10).\n'
              'Setiap naik 1 tangga dibagi 10 (÷ 10).\n'
              'Contoh: 3 km = 3 × 1.000 = 3.000 meter.',
          keyFormulas: [
            'km ➔ hm ➔ dam ➔ m ➔ dm ➔ cm ➔ mm (×10 per turun tangga)',
            '1 Ton = 1.000 kg',
          ],
          exampleProblem: '5 km setara dengan berapa meter?',
          exampleSolution: '5 km × 1.000 = 5.000 meter.',
        ),
        MathTopic(
          id: 'topik_pengukuran_gabungan',
          title: 'Pengukuran Gabungan',
          description: 'Menghitung gabungan waktu, jarak, dan kecepatan (J = K × W).',
          summaryContent:
              'Kecepatan menggambarkan seberapa jauh jarak yang ditempuh dalam satuan waktu tertentu.\n'
              '• Rumus Jarak (J) = Kecepatan (K) × Waktu (W)\n'
              '• Rumus Kecepatan (K) = Jarak ÷ Waktu\n'
              '• Rumus Waktu (W) = Jarak ÷ Kecepatan',
          keyFormulas: [
            'Jarak = Kecepatan × Waktu',
            'K = J / W',
          ],
          exampleProblem: 'Sebuah mobil melaju dengan kecepatan 60 km/jam selama 2 jam. Berapa jarak tempuhnya?',
          exampleSolution: 'Jarak = 60 km/jam × 2 jam = 120 km.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 4: ANALISIS DATA DAN PELUANG
    // -------------------------------------------------------------------------
    MathTheme(
      id: 'tema_analisis_data',
      title: 'Analisis Data dan Peluang',
      description: 'Pengumpulan data, membaca diagram batang/lingkaran, dan rata-rata (Mean).',
      iconEmoji: '📊',
      themeColorHex: '#FB5607',
      topics: [
        MathTopic(
          id: 'topik_pengumpulan_data',
          title: 'Pengumpulan dan Pengelompokan Dasar',
          description: 'Metode turus (tally chart) dan tabel frekuensi sederhana.',
          summaryContent:
              'Data adalah kumpulan informasi atau fakta yang diperoleh melalui pencatatan.\n'
              'Turus (Tally) membantu menghitung dengan cepat menggunakan garis-garis sejajar kelompok 5.',
          keyFormulas: [
            'Frekuensi = Jumlah kemunculan data',
            'Modus = Data dengan frekuensi terbanyak',
          ],
          exampleProblem: 'Data nilai matematika: 8, 7, 9, 8, 8, 10. Angka berapakah yang paling sering muncul (Modus)?',
          exampleSolution: 'Angka 8 muncul sebanyak 3 kali (Modus = 8).',
        ),
        MathTopic(
          id: 'topik_penyajian_data_visual',
          title: 'Penyajian Data Visual Dasar (Kelas 3–4)',
          description: 'Membaca dan membuat Diagram Batang dan Diagram Gambar (Piktogram).',
          summaryContent:
              'Diagram Batang menggunakan tinggi/panjang batang untuk menggambarkan jumlah frekuensi tiap kategori data.\n'
              'Piktogram menggunakan simbol gambar di mana 1 gambar bisa mewakili 5 atau 10 benda.',
          keyFormulas: [
            'Tinggi Batang = Jumlah Frekuensi Data',
          ],
          exampleProblem: 'Pada diagram batang panen buah, batang Apel setinggi angka 50 kg dan Jeruk setinggi 30 kg. Berapa selisihnya?',
          exampleSolution: 'Selisih = 50 kg - 30 kg = 20 kg.',
        ),
        MathTopic(
          id: 'topik_pengolahan_data_lanjutan',
          title: 'Pengolahan Data Lanjutan & Statistika Dasar (Kelas 5–6)',
          description: 'Menghitung Rata-rata (Mean), Nilai Tengah (Median), dan Modus.',
          summaryContent:
              '• Mean (Rata-rata): Jumlah seluruh nilai data dibagi banyaknya data.\n'
              '• Median: Nilai tengah setelah data diurutkan dari terkecil ke terbesar.\n'
              '• Modus: Nilai data yang paling sering muncul.',
          keyFormulas: [
            'Rata-rata (Mean) = Total Jumlah Nilai ÷ Banyaknya Data',
          ],
          exampleProblem: 'Nilai ulangan Andi: 8, 7, 9, 8. Berapakah nilai rata-ratanya?',
          exampleSolution: 'Total = 8 + 7 + 9 + 8 = 32. Banyak data = 4. Rata-rata = 32 ÷ 4 = 8.',
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // TEMA 5: ALJABAR SEDERHANA (POLA BILANGAN DAN RASIO)
    // -------------------------------------------------------------------------
    MathTheme(
      id: 'tema_aljabar',
      title: 'Aljabar Sederhana (Pola Bilangan dan Rasio)',
      description: 'Pola gambar, pola bilangan melompat, rasio/perbandingan, dan skala peta.',
      iconEmoji: '🧩',
      themeColorHex: '#FFBE0B',
      topics: [
        MathTopic(
          id: 'topik_pola_gambar',
          title: 'Pengenalan Pola Gambar dan Bentuk',
          description: 'Menentukan urutan simbol dan gambar berikutnya berdasarkan pola.',
          summaryContent:
              'Pola Gambar adalah susunan bentuk berulang yang memiliki aturan tetap.\n'
              'Contoh: 🔴 🔵 🔴 🔵 🔴 ... Gambar berikutnya pasti 🔵!',
          keyFormulas: [
            'Aturan Pola = Selisih berulang antara langkah n dan n+1',
          ],
          exampleProblem: 'Pola bentuk: Segitiga, Persegi, Segitiga, Persegi, Segitiga, ... Bentuk berikutnya adalah?',
          exampleSolution: 'Bentuk berikutnya adalah Persegi.',
        ),
        MathTopic(
          id: 'topik_pola_bilangan',
          title: 'Pola Bilangan',
          description: 'Pola lompatan bilangan loncat +2, +3, +5, atau perkalian ×2.',
          summaryContent:
              'Pola Bilangan susunan angka yang membentuk aturan tertentu.\n'
              'Contoh Pola Tambah 3: 2, 5, 8, 11, 14, ...\n'
              'Contoh Pola Perkalian 2: 1, 2, 4, 8, 16, 32, ...',
          keyFormulas: [
            'Suku berikutnya = Suku sebelumnya + Beda (Lonpatan)',
          ],
          exampleProblem: 'Tentukan dua angka berikutnya dari pola loncat: 4, 8, 12, 16, ..., ...',
          exampleSolution: 'Pola loncat +4. Dua angka berikutnya adalah 20 dan 24.',
        ),
        MathTopic(
          id: 'topik_rasio_skala',
          title: 'Rasio, Skala, dan Koordinat Dasar',
          description: 'Perbandingan rasio a:b, skala peta (1:100.000), dan titik posisi (x,y).',
          summaryContent:
              '• Rasio adalah perbandingan nilai dua besaran (Misal Rasio kelereng Andi : Budi = 2 : 3).\n'
              '• Skala Peta = Jarak pada Peta ÷ Jarak Sebenarnya.\n'
              '• Koordinat Kartesius: Titik ditulis (x, y) di mana x adalah mendatar dan y adalah tegak.',
          keyFormulas: [
            'Skala = Jarak Peta / Jarak Sebenarnya',
            'Jarak Sebenarnya = Jarak Peta × Angka Skala',
          ],
          exampleProblem: 'Jarak pada peta 2 cm dengan skala 1 : 100.000. Berapa jarak sebenarnya dalam kilometer?',
          exampleSolution: 'Jarak sebenarnya = 2 cm × 100.000 = 200.000 cm = 2 km.',
        ),
      ],
    ),
  ];
}
