import 'dart:math';
import '../models/question_model.dart';

class AiQuestionGeneratorService {
  static const List<String> _studentNames = [
    'Budi', 'Ani', 'Siti', 'Edo', 'Dayu', 'Rani', 'Dito', 'Lani', 'Made', 'Udin'
  ];

  static const List<String> _storeNames = [
    'toko buah', 'koperasi sekolah', 'perpustakaan', 'toko buku', 'pasar tradisional'
  ];

  /// Procedural & Topic-Specific Dynamic Question Generator for Math SD
  /// Generates 100% UNIQUE, topic-authentic math questions matching exact curriculum topics.
  static List<Question> generateDynamicMathQuestions({
    required String gradeLevel,
    required int classNum,
    required int count,
    String topic = 'Umum',
  }) {
    final List<Question> questions = [];
    final Set<String> seenQuestionTexts = {};
    final random = Random();
    final tLower = topic.toLowerCase().trim();

    int attempts = 0;
    while (questions.length < count && attempts < 1000) {
      attempts++;
      final versionType = random.nextInt(10);

      String qText = '';
      int? correctAnsNum;
      String explanationText = '';
      String levelTag = 'Sedang';
      List<String>? textOptions;
      int? textCorrectIndex;
      String? visualType;
      Map<String, dynamic>? visualData;
      String? visualLabel;

      final nameA = _studentNames[random.nextInt(_studentNames.length)];
      final otherNames = _studentNames.where((n) => n != nameA).toList();
      final nameB = otherNames[random.nextInt(otherNames.length)];

      // -----------------------------------------------------------------------
      // 1. PENGENALAN BILANGAN DAN NILAI TEMPAT
      // -----------------------------------------------------------------------
      if (tLower.contains('nilai tempat') || (tLower.contains('pengenalan') && tLower.contains('bilangan'))) {
        final thousands = (random.nextInt(8) + 1) * 1000;
        final hundreds = (random.nextInt(9) + 1) * 100;
        final tens = (random.nextInt(9) + 1) * 10;
        final units = random.nextInt(9) + 1;
        final totalNum = thousands + hundreds + tens + units;

        if (versionType == 0) {
          levelTag = 'Dasar';
          final targetDigit = (hundreds / 100).round();
          qText = 'Pada bilangan $totalNum, angka $targetDigit menempati nilai tempat .....';
          explanationText = 'Angka $targetDigit menempati nilai tempat Ratusan ($hundreds).';
          textOptions = ['Ribuan', 'Ratusan', 'Puluhan', 'Satuan'];
          textCorrectIndex = 1;
        } else if (versionType == 1) {
          levelTag = 'Dasar';
          final targetDigit = (thousands / 1000).round();
          qText = 'Pada bilangan $totalNum, nilai tempat Ribuan ditempati oleh angka .....';
          explanationText = 'Angka $targetDigit berada di posisi pertama dari kiri (Ribuan).';
          correctAnsNum = targetDigit;
        } else if (versionType == 2) {
          levelTag = 'Sedang';
          final numA = thousands + hundreds + tens + units;
          final numB = thousands + (hundreds + 100) + tens;
          qText = 'Manakah tanda perbandingan yang tepat untuk $numA ..... $numB ?';
          explanationText = '$numA lebih kecil dari $numB ($numA < $numB).';
          textOptions = ['< (Kurang dari)', '> (Lebih dari)', '= (Sama dengan)', '≥ (Lebih dari sama dengan)'];
          textCorrectIndex = 0;
        } else if (versionType == 3) {
          levelTag = 'HOTS';
          final hDigit = random.nextInt(8) + 1;
          final uDigit = random.nextInt(8) + 1;
          final val = 3000 + (hDigit * 100) + 40 + uDigit;
          final sum = 3 + hDigit + 4 + uDigit;
          qText = 'Aku adalah bilangan 4 angka. Angka ribuanku 3, puluhanku 4, dan jumlah seluruh angkaku $sum. Bilangan manakah aku?';
          explanationText = '3 + $hDigit + 4 + $uDigit = $sum. Bilangan tersebut adalah $val.';
          correctAnsNum = val;
        } else if (versionType == 4) {
          levelTag = 'Sedang';
          final savings = (random.nextInt(8) + 2) * 1000 + (random.nextInt(9) + 1) * 100;
          qText = '$nameA menabung uang di bank sebanyak Rp $savings. Pada nominal uang $nameA, berapakah nilai tempat dari angka ${(savings ~/ 1000)}?';
          explanationText = 'Angka ${(savings ~/ 1000)} bernilai ${(savings ~/ 1000) * 1000} rupiah, sehingga menempati nilai tempat Ribuan.';
          textOptions = ['Ribuan', 'Ratusan', 'Puluhan', 'Satuan'];
          textCorrectIndex = 0;
        } else if (versionType == 5) {
          levelTag = 'HOTS';
          qText = 'Di perpustakaan sekolah terdapat $totalNum buku. Jika angka ratusan ($hundreds) dan puluhannya ($tens) ditukar, berapa jumlah angka baru di posisi ratusan?';
          final tensDigit = tens ~/ 10;
          explanationText = 'Angka puluhan semula $tensDigit dipindah ke posisi Ratusan.';
          correctAnsNum = tensDigit;
        } else if (versionType == 6) {
          levelTag = 'Sedang';
          final b1 = 2540 + random.nextInt(50);
          final b2 = 2590 + random.nextInt(50);
          final b3 = 2650 + random.nextInt(50);
          qText = 'Manakah urutan bilangan berikut dari yang terkecil hingga terbesar?';
          explanationText = 'Urutan yang benar dari terkecil ke terbesar adalah $b1, $b2, $b3.';
          textOptions = [
            '$b1, $b2, $b3',
            '$b3, $b2, $b1',
            '$b2, $b1, $b3',
            '$b1, $b3, $b2',
          ];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          levelTag = 'Dasar';
          final tensVal = (random.nextInt(8) + 1) * 10;
          final val = 4000 + tensVal;
          qText = 'Lambang bilangan $val jika ditulis dalam bentuk kata (huruf) adalah .....';
          explanationText = '4.000 (empat ribu) + $tensVal = empat ribu ${tensVal ~/ 10} puluh.';
          textOptions = [
            'Empat ribu ${tensVal ~/ 10} puluh',
            'Empat ratus ${tensVal ~/ 10} puluh',
            'Empat puluh ribu',
            'Empat ribu ${tensVal ~/ 10} ratus',
          ];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          levelTag = 'Sedang';
          final riceGrams = (random.nextInt(5) + 3) * 1000 + 750;
          qText = '$nameB membeli beras seberat $riceGrams gram di ${_storeNames[random.nextInt(_storeNames.length)]}. Angka 7 pada berat beras tersebut menempati nilai tempat .....';
          explanationText = '700 gram menempati posisi Ratusan.';
          textOptions = ['Ratusan', 'Ribuan', 'Puluhan', 'Satuan'];
          textCorrectIndex = 0;
        } else {
          levelTag = 'HOTS';
          final r = (random.nextInt(4) + 2) * 1000;
          final rat = (random.nextInt(5) + 1) * 100;
          final pul = (random.nextInt(8) + 1) * 10;
          final sat = random.nextInt(8) + 1;
          final total = r + rat + pul + sat;
          qText = 'Bentuk panjang dari bilangan $total adalah .....';
          explanationText = '$total = $r + $rat + $pul + $sat.';
          final optCorrect = '$r + $rat + $pul + $sat';
          final opt1 = '${r ~/ 10} + $rat + $pul + $sat';
          final opt2 = '$r + ${rat * 10} + $pul + $sat';
          final opt3 = '$r + $rat + ${pul * 10} + $sat';
          final opts = [optCorrect, opt1, opt2, opt3]..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(optCorrect);
        }
      }

      // -----------------------------------------------------------------------
      // 2. PENJUMLAHAN & PENGURANGAN DASAR
      // -----------------------------------------------------------------------
      else if (tLower.contains('penjumlahan') || tLower.contains('pengurangan')) {
        levelTag = 'Sedang';
        final a = random.nextInt(400) + 100;
        final b = random.nextInt(300) + 50;

        if (versionType == 0) {
          correctAnsNum = a + b;
          qText = 'Berapakah hasil penjumlahan dari $a + $b ?';
          explanationText = 'Penjumlahan bersusun: $a + $b = $correctAnsNum.';
        } else if (versionType == 1) {
          correctAnsNum = a;
          final total = a + b;
          qText = 'Berapakah nilai N jika N + $b = $total ?';
          explanationText = 'N = $total - $b = $correctAnsNum.';
        } else if (versionType == 2) {
          final maxA = max(a, b);
          final minB = min(a, b);
          correctAnsNum = maxA - minB;
          qText = 'Berapakah hasil dari $maxA - $minB ?';
          explanationText = 'Pengurangan bersusun: $maxA - $minB = $correctAnsNum.';
        } else if (versionType == 3) {
          final c = random.nextInt(50) + 10;
          correctAnsNum = a + b - c;
          qText = 'Hitunglah hasil dari $a + $b - $c !';
          explanationText = '$a + $b = ${a + b}, lalu ${a + b} - $c = $correctAnsNum.';
        } else if (versionType == 4) {
          levelTag = 'Dasar';
          final applesA = random.nextInt(30) + 15;
          final applesB = random.nextInt(25) + 10;
          correctAnsNum = applesA + applesB;
          qText = '$nameA membawa $applesA buah apel dan $nameB membawa $applesB buah apel. Berapa jumlah seluruh apel yang mereka bawa?';
          explanationText = 'Total apel = $applesA + $applesB = $correctAnsNum buah.';
        } else if (versionType == 5) {
          levelTag = 'Sedang';
          final initialMoney = (random.nextInt(8) + 5) * 1000;
          final spentMoney = (random.nextInt(3) + 1) * 1000 + 500;
          correctAnsNum = initialMoney - spentMoney;
          qText = '$nameA memiliki tabungan awal Rp $initialMoney. Ia membeli buku cerita seharga Rp $spentMoney. Berapa sisa uang tabungan $nameA?';
          explanationText = 'Sisa uang = Rp $initialMoney - Rp $spentMoney = Rp $correctAnsNum.';
        } else if (versionType == 6) {
          levelTag = 'HOTS';
          final harvest1 = random.nextInt(150) + 200;
          final harvest2 = random.nextInt(120) + 150;
          final rotten = random.nextInt(30) + 20;
          correctAnsNum = harvest1 + harvest2 - rotten;
          qText = 'Seorang petani memanen $harvest1 kg mangga di pagi hari dan $harvest2 kg di sore hari. Jika $rotten kg mangga busuk, berapa kg mangga yang masih bagus?';
          explanationText = '($harvest1 + $harvest2) - $rotten = ${harvest1 + harvest2} - $rotten = $correctAnsNum kg.';
        } else if (versionType == 7) {
          levelTag = 'Sedang';
          final p1 = random.nextInt(40) + 20;
          final p2 = random.nextInt(30) + 15;
          final p3 = random.nextInt(20) + 10;
          correctAnsNum = p1 + p2 + p3;
          qText = 'Hitunglah penjumlahan tiga bilangan berikut: $p1 + $p2 + $p3 = .....';
          explanationText = '$p1 + $p2 = ${p1 + p2}, lalu ${p1 + p2} + $p3 = $correctAnsNum.';
        } else if (versionType == 8) {
          levelTag = 'HOTS';
          final busPass = random.nextInt(20) + 25;
          final passUp = random.nextInt(12) + 5;
          final passDown = random.nextInt(10) + 4;
          correctAnsNum = busPass + passUp - passDown;
          qText = 'Sebuah bus berisi $busPass penumpang. Di halte A naik $passUp penumpang dan turun $passDown penumpang. Berapa jumlah penumpang di dalam bus sekarang?';
          explanationText = 'Jumlah penumpang = $busPass + $passUp - $passDown = $correctAnsNum orang.';
        } else {
          levelTag = 'Dasar';
          final valX = random.nextInt(150) + 100;
          final valY = random.nextInt(80) + 40;
          correctAnsNum = (valX - valY).abs();
          qText = 'Berapakah selisih antara bilangan $valX dan $valY ?';
          explanationText = 'Selisih = |$valX - $valY| = $correctAnsNum.';
        }
      }

      // -----------------------------------------------------------------------
      // 3. PERKALIAN & PEMBAGIAN (KABATAKU)
      // -----------------------------------------------------------------------
      else if (tLower.contains('perkalian') || tLower.contains('pembagian') || tLower.contains('kabataku')) {
        levelTag = 'HOTS';
        final a = random.nextInt(9) + 2;
        final b = random.nextInt(9) + 2;

        if (versionType == 0) {
          correctAnsNum = a * b;
          qText = 'Berapakah hasil perkalian dari $a × $b ?';
          explanationText = '$a × $b = $correctAnsNum.';
        } else if (versionType == 1) {
          final prod = a * b;
          correctAnsNum = a;
          qText = 'Hasil dari $prod ÷ $b adalah .....';
          explanationText = '$prod ÷ $b = $correctAnsNum.';
        } else if (versionType == 2) {
          final c = random.nextInt(20) + 10;
          correctAnsNum = c + (a * b);
          qText = 'Hitunglah hasil dari $c + ($a × $b) !';
          explanationText = 'Aturan KABATAKU: Dahulukan perkalian ($a × $b = ${a * b}). Lalu $c + ${a * b} = $correctAnsNum.';
        } else if (versionType == 3) {
          final c = random.nextInt(15) + 5;
          correctAnsNum = (a * b) - c;
          qText = 'Berapakah hasil dari $a × $b - $c ?';
          explanationText = '$a × $b = ${a * b}. Lalu ${a * b} - $c = $correctAnsNum.';
        } else if (versionType == 4) {
          levelTag = 'Sedang';
          final boxes = random.nextInt(5) + 4;
          final itemsPerBox = random.nextInt(6) + 5;
          correctAnsNum = boxes * itemsPerBox;
          qText = 'Ibu $nameA membeli $boxes kotak kue di ${_storeNames[random.nextInt(_storeNames.length)]}. Setiap kotak berisi $itemsPerBox kue. Berapa jumlah seluruh kue yang dibeli Ibu?';
          explanationText = 'Total kue = $boxes × $itemsPerBox = $correctAnsNum buah.';
        } else if (versionType == 5) {
          levelTag = 'Sedang';
          final totalCandies = (random.nextInt(6) + 4) * 8;
          final kids = 8;
          correctAnsNum = totalCandies ~/ kids;
          qText = '$nameB mempunyai $totalCandies permen yang akan dibagikan sama rata kepada $kids orang temannya. Berapa permen yang diterima oleh setiap anak?';
          explanationText = 'Permen per anak = $totalCandies ÷ $kids = $correctAnsNum permen.';
        } else if (versionType == 6) {
          levelTag = 'HOTS';
          final shelves = random.nextInt(4) + 3;
          final booksPerShelf = random.nextInt(15) + 20;
          correctAnsNum = shelves * booksPerShelf;
          qText = 'Di perpustakaan sekolah terdapat $shelves rak buku besar. Jika setiap rak memuat $booksPerShelf buku cerita, berapakah jumlah seluruh buku cerita di perpustakaan tersebut?';
          explanationText = 'Jumlah buku = $shelves × $booksPerShelf = $correctAnsNum buku.';
        } else if (versionType == 7) {
          levelTag = 'HOTS';
          final divA = (random.nextInt(5) + 2) * 6;
          final divB = 6;
          final addC = random.nextInt(20) + 15;
          correctAnsNum = (divA ~/ divB) + addC;
          qText = 'Hitunglah hasil dari ($divA ÷ $divB) + $addC !';
          explanationText = '$divA ÷ $divB = ${divA ~/ divB}. Lalu ${divA ~/ divB} + $addC = $correctAnsNum.';
        } else if (versionType == 8) {
          levelTag = 'Sedang';
          final rows = random.nextInt(6) + 4;
          final plantsPerRow = random.nextInt(8) + 6;
          correctAnsNum = rows * plantsPerRow;
          qText = 'Pak Ahmad menanam jagung sebanyak $rows baris di kebunnya. Jika tiap baris terdiri dari $plantsPerRow tanaman, berapa total tanaman jagung Pak Ahmad?';
          explanationText = 'Total tanaman = $rows × $plantsPerRow = $correctAnsNum pohon.';
        } else {
          levelTag = 'HOTS';
          final m1 = 12;
          final m2 = random.nextInt(7) + 3;
          correctAnsNum = m1 * m2;
          qText = 'Berapakah hasil dari $m1 × $m2 ?';
          explanationText = 'Perkalian 12: $m1 × $m2 = $correctAnsNum.';
        }
      }

      // -----------------------------------------------------------------------
      // 4. PECAHAN, DESIMAL, DAN PERSEN
      // -----------------------------------------------------------------------
      else if (tLower.contains('pecahan') || tLower.contains('desimal') || tLower.contains('persen')) {
        levelTag = 'Sedang';
        final fractionList = [
          {'n': 1, 'd': 2, 'dec': '0,5', 'pct': '50%'},
          {'n': 1, 'd': 4, 'dec': '0,25', 'pct': '25%'},
          {'n': 3, 'd': 4, 'dec': '0,75', 'pct': '75%'},
          {'n': 1, 'd': 5, 'dec': '0,2', 'pct': '20%'},
          {'n': 2, 'd': 5, 'dec': '0,4', 'pct': '40%'},
          {'n': 3, 'd': 5, 'dec': '0,6', 'pct': '60%'},
          {'n': 4, 'd': 5, 'dec': '0,8', 'pct': '80%'},
          {'n': 1, 'd': 10, 'dec': '0,1', 'pct': '10%'},
          {'n': 7, 'd': 10, 'dec': '0,7', 'pct': '70%'},
        ];
        final fItem = fractionList[random.nextInt(fractionList.length)];

        if (versionType == 0) {
          visualType = 'fraction_pie';
          visualData = {'numerator': fItem['n'], 'denominator': fItem['d']};
          visualLabel = 'Model Pecahan ${fItem['n']}/${fItem['d']}';
          qText = 'Berapakah nilai desimal dari pecahan ${fItem['n']}/${fItem['d']} ?';
          explanationText = '${fItem['n']} ÷ ${fItem['d']} = ${fItem['dec']} (setara ${fItem['pct']}).';
          final opts = [fItem['dec'] as String, '0,15', '0,35', '0,65']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(fItem['dec'] as String);
        } else if (versionType == 1) {
          qText = 'Bentuk persen dari pecahan ${fItem['n']}/${fItem['d']} adalah .....';
          explanationText = '${fItem['n']}/${fItem['d']} × 100% = ${fItem['pct']}.';
          final opts = [fItem['pct'] as String, '15%', '30%', '85%']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(fItem['pct'] as String);
        } else if (versionType == 2) {
          qText = 'Manakah pecahan yang senilai dengan ${fItem['n']}/${fItem['d']} ?';
          final doubleN = (fItem['n'] as int) * 2;
          final doubleD = (fItem['d'] as int) * 2;
          final equivStr = '$doubleN/$doubleD';
          explanationText = '${fItem['n']}/${fItem['d']} jika pembilang & penyebut dikali 2 menjadi $equivStr.';
          final opts = [equivStr, '${doubleN + 1}/$doubleD', '$doubleN/${doubleD + 1}', '${doubleN + 2}/${doubleD + 2}']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(equivStr);
        } else if (versionType == 3) {
          final n1 = random.nextInt(3) + 1;
          final n2 = random.nextInt(3) + 1;
          final den = 5;
          final ansN = n1 + n2;
          qText = 'Hasil penjumlahan pecahan $n1/$den + $n2/$den adalah .....';
          explanationText = 'Penyebut sudah sama ($den), jumlahkan pembilang: $n1 + $n2 = $ansN/$den.';
          final opts = ['$ansN/$den', '${ansN + 1}/$den', '$ansN/${den * 2}', '${ansN - 1}/$den']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('$ansN/$den');
        } else if (versionType == 4) {
          levelTag = 'Dasar';
          final totalSlices = 8;
          final eatenSlices = random.nextInt(4) + 2;
          qText = 'Ibu $nameA memotong kue bolu menjadi $totalSlices bagian sama besar. $nameA memakan $eatenSlices bagian. Berapa nilai pecahan kue yang dimakan $nameA?';
          explanationText = '$eatenSlices bagian dari $totalSlices potong kue ditulis dalam pecahan $eatenSlices/$totalSlices.';
          final ansStr = '$eatenSlices/$totalSlices';
          final opts = [ansStr, '${eatenSlices + 1}/$totalSlices', '${eatenSlices - 1}/$totalSlices', '$totalSlices/$eatenSlices']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(ansStr);
        } else if (versionType == 5) {
          levelTag = 'Sedang';
          final slices = 8;
          final eaten1 = 2;
          final eaten2 = 3;
          final left = slices - (eaten1 + eaten2);
          qText = 'Sebuah semangka dipotong menjadi 8 bagian sama besar. $nameA makan 2 bagian dan $nameB makan 3 bagian. Berapa sisa semangka dalam bentuk pecahan?';
          explanationText = 'Sisa bagian = 8 - (2 + 3) = 3 bagian, ditulis 3/8.';
          final opts = ['$left/8', '2/8', '5/8', '1/8']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('$left/8');
        } else if (versionType == 6) {
          levelTag = 'Sedang';
          final decVal = '0,75';
          qText = 'Bentuk pecahan biasa yang paling sederhana dari desimal $decVal adalah .....';
          explanationText = '0,75 = 75/100 = 3/4.';
          final opts = ['3/4', '1/2', '2/5', '4/5']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('3/4');
        } else if (versionType == 7) {
          final n1 = 7;
          final n2 = 3;
          final den = 10;
          final ansN = n1 - n2;
          qText = 'Hitunglah pengurangan pecahan berikut: $n1/$den - $n2/$den = .....';
          explanationText = 'Penyebut sama ($den): $n1 - $n2 = $ansN/$den.';
          final opts = ['$ansN/$den', '${ansN + 1}/$den', '$ansN/20', '${ansN + 2}/$den']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('$ansN/$den');
        } else if (versionType == 8) {
          levelTag = 'HOTS';
          final discountPct = 20;
          final originalPrice = 100000;
          final discountVal = (originalPrice * discountPct) ~/ 100;
          correctAnsNum = discountVal;
          qText = 'Sebuah tas sekolah seharga Rp $originalPrice mendapat potongan harga (diskon) sebesar $discountPct%. Berapakah besar besarnya potongan harga tersebut?';
          explanationText = 'Potongan harga = 20% × Rp 100.000 = Rp $discountVal.';
        } else {
          levelTag = 'Sedang';
          qText = 'Manakah dari pecahan berikut yang nilainya paling besar?';
          explanationText = '3/4 (0,75) lebih besar dibanding 1/2 (0,5), 1/4 (0,25), dan 1/5 (0,2).';
          textOptions = ['3/4', '1/2', '1/4', '1/5'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 5. KELIPATAN DAN FAKTOR (KPK & FPB)
      // -----------------------------------------------------------------------
      else if (tLower.contains('kpk') || tLower.contains('fpb') || tLower.contains('faktor') || tLower.contains('kelipatan')) {
        levelTag = 'HOTS';
        if (versionType == 0) {
          final fpbPairs = [
            {'a': 12, 'b': 18, 'fpb': 6},
            {'a': 8, 'b': 12, 'fpb': 4},
            {'a': 15, 'b': 20, 'fpb': 5},
            {'a': 24, 'b': 36, 'fpb': 12},
            {'a': 16, 'b': 24, 'fpb': 8},
            {'a': 20, 'b': 30, 'fpb': 10},
          ];
          final fItem = fpbPairs[random.nextInt(fpbPairs.length)];
          qText = 'Tentukan FPB (Faktor Persekutuan Terbesar) dari ${fItem['a']} dan ${fItem['b']} !';
          explanationText = 'FPB dari ${fItem['a']} dan ${fItem['b']} adalah ${fItem['fpb']}.';
          correctAnsNum = fItem['fpb'] as int;
        } else if (versionType == 1) {
          final kpkPairs = [
            {'a': 4, 'b': 6, 'kpk': 12},
            {'a': 6, 'b': 8, 'kpk': 24},
            {'a': 12, 'b': 18, 'kpk': 36},
            {'a': 5, 'b': 10, 'kpk': 10},
            {'a': 3, 'b': 5, 'kpk': 15},
          ];
          final kItem = kpkPairs[random.nextInt(kpkPairs.length)];
          qText = 'Tentukan KPK (Kelipatan Persekutuan Terkecil) dari ${kItem['a']} dan ${kItem['b']} !';
          explanationText = 'KPK dari ${kItem['a']} dan ${kItem['b']} adalah ${kItem['kpk']}.';
          correctAnsNum = kItem['kpk'] as int;
        } else if (versionType == 2) {
          final primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29];
          final selectedPrime = primes[random.nextInt(primes.length)];
          qText = 'Manakah dari bilangan berikut yang merupakan bilangan prima?';
          explanationText = '$selectedPrime hanya memiliki 2 faktor (1 dan $selectedPrime) sehingga merupakan bilangan prima.';
          final opts = [selectedPrime.toString(), (selectedPrime + 1).toString(), (selectedPrime + 3).toString(), (selectedPrime + 7).toString()]..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(selectedPrime.toString());
        } else if (versionType == 3) {
          final numF = (random.nextInt(4) + 2) * 6;
          qText = 'Ibu memiliki $numF kue cokelat dan ${numF + 6} kue keju. Berapa kotak terbanyak yang dibutuhkan agar isi tiap kotak sama banyak? (FPB)';
          explanationText = 'Cari FPB dari $numF dan ${numF + 6}, yaitu 6 kotak.';
          correctAnsNum = 6;
        } else if (versionType == 4) {
          levelTag = 'HOTS';
          final dA = 4;
          final dB = 6;
          final kpkVal = 12;
          qText = '$nameA les matematika setiap $dA hari sekali, sedangkan $nameB les setiap $dB hari sekali. Jika hari ini mereka les bersama, berapa hari lagi mereka akan les bersama kembali? (KPK)';
          explanationText = 'KPK dari $dA dan $dB adalah $kpkVal hari.';
          correctAnsNum = kpkVal;
        } else if (versionType == 5) {
          levelTag = 'Sedang';
          final numBase = random.nextInt(4) + 3;
          final multList = [numBase, numBase * 2, numBase * 3, numBase * 4];
          qText = 'Kelipatan persekutuan pertama dari bilangan $numBase adalah .....';
          explanationText = 'Kelipatan dari $numBase: ${multList.join(", ")}.';
          final opts = [multList.join(", "), '1, 2, 3', '10, 20, 30', '5, 10, 15']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf(multList.join(", "));
        } else if (versionType == 6) {
          levelTag = 'Sedang';
          final targetNum = 12;
          qText = 'Faktor dari bilangan $targetNum adalah .....';
          explanationText = 'Faktor dari 12 adalah 1, 2, 3, 4, 6, 12 (bilangan yang habis membagi 12).';
          textOptions = ['1, 2, 3, 4, 6, 12', '1, 2, 4, 8, 12', '2, 4, 6, 8, 10', '1, 3, 6, 12'];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          levelTag = 'HOTS';
          final targetVal = 24;
          qText = 'Faktorisasi prima dari $targetVal adalah .....';
          explanationText = '24 = 2 × 2 × 2 × 3 = 2³ × 3.';
          textOptions = ['2³ × 3', '2² × 3', '2 × 3²', '2 × 12'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          levelTag = 'HOTS';
          final lenA = 16;
          final lenB = 24;
          final fpbVal = 8;
          qText = '$nameA memiliki pita merah sepanjang $lenA cm dan pita biru sepanjang $lenB cm. Ia ingin memotong kedua pita menjadi beberapa bagian sama panjang tanpa sisa. Berapa cm panjang potongan terpanjang yang mungkin?';
          explanationText = 'Potongan terpanjang = FPB($lenA, $lenB) = $fpbVal cm.';
          correctAnsNum = fpbVal;
        } else {
          levelTag = 'Dasar';
          qText = 'Bilangan prima terkecil adalah .....';
          explanationText = '2 adalah satu-satunya bilangan prima genap dan sekaligus bilangan prima terkecil.';
          correctAnsNum = 2;
        }
      }

      // -----------------------------------------------------------------------
      // 6. BILANGAN BULAT NEGATIF
      // -----------------------------------------------------------------------
      else if (tLower.contains('negatif') || tLower.contains('bilangan bulat')) {
        levelTag = 'Sedang';
        final a = random.nextInt(15) + 5;
        final b = random.nextInt(20) + 5;

        if (versionType == 0) {
          correctAnsNum = (-a) + b;
          qText = 'Berapakah hasil dari (-$a) + $b ?';
          explanationText = '(-$a) + $b = $b - $a = $correctAnsNum.';
        } else if (versionType == 1) {
          correctAnsNum = (-a) - b;
          qText = 'Berapakah hasil dari (-$a) - $b ?';
          explanationText = '(-$a) - $b = -($a + $b) = $correctAnsNum.';
        } else if (versionType == 2) {
          qText = 'Suhu di kota A adalah $a°C di bawah nol. Suhu tersebut dapat ditulis .....';
          explanationText = 'Suhu di bawah nol ditulis menggunakan tanda negatif (-$a°C).';
          final opts = ['-$a°C', '$a°C', '0,$a°C', '-0,$a°C']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('-$a°C');
        } else if (versionType == 3) {
          correctAnsNum = a + b;
          qText = 'Hasil pengurangan $a - (-$b) adalah .....';
          explanationText = 'Aturan tanda: dikurangi negatif menjadi ditambah ($a + $b = $correctAnsNum).';
        } else if (versionType == 4) {
          levelTag = 'Dasar';
          final depth = random.nextInt(30) + 20;
          qText = 'Sebuah kapal selam berada pada kedalaman $depth meter di bawah permukaan laut. Posisi kedalaman kapal selam tersebut ditulis .....';
          explanationText = 'Kedalaman di bawah permukaan laut dinyatakan dengan tanda negatif (-$depth meter).';
          final opts = ['-$depth meter', '+$depth meter', '$depth meter', '0 meter']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('-$depth meter');
        } else if (versionType == 5) {
          levelTag = 'HOTS';
          final initialTemp = random.nextInt(5) + 3;
          final riseTemp = random.nextInt(8) + 6;
          correctAnsNum = (-initialTemp) + riseTemp;
          qText = 'Suhu awal daging di dalam kulkas adalah -$initialTemp°C. Setelah dikeluarkan dari kulkas, suhu daging naik sebesar $riseTemp°C. Berapakah suhu daging sekarang?';
          explanationText = 'Suhu akhir = (-$initialTemp) + $riseTemp = $correctAnsNum°C.';
        } else if (versionType == 6) {
          levelTag = 'Sedang';
          final startFloor = 2;
          final upFloors = 5;
          correctAnsNum = (-startFloor) + upFloors;
          qText = '$nameA naik lift dari ruang parkir bawah tanah (lantai -$startFloor) menuju ke atas sebanyak $upFloors lantai. Di lantai berapakah $nameA sekarang?';
          explanationText = 'Posisi lantai = (-$startFloor) + $upFloors = lantai $correctAnsNum.';
        } else if (versionType == 7) {
          levelTag = 'Dasar';
          final valN1 = -12;
          final valN2 = -5;
          qText = 'Manakah tanda perbandingan yang tepat untuk $valN1 ..... $valN2 ?';
          explanationText = '-12 terletak di sebelah kiri -5 pada garis bilangan, sehingga -12 < -5.';
          textOptions = ['< (Kurang dari)', '> (Lebih dari)', '= (Sama dengan)', '≥'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          levelTag = 'Sedang';
          correctAnsNum = -15;
          qText = 'Di antara bilangan berikut: -8, -15, 0, 5, manakah bilangan yang nilainya paling kecil?';
          explanationText = '-15 adalah bilangan bulat terkeluar di sebelah kiri garis bilangan.';
        } else {
          levelTag = 'HOTS';
          final multA = random.nextInt(6) + 2;
          final multB = random.nextInt(6) + 2;
          correctAnsNum = (-multA) * multB;
          qText = 'Berapakah hasil perkalian dari (-$multA) × $multB ?';
          explanationText = 'Negatif dikali positif menghasilkan negatif: (-$multA) × $multB = $correctAnsNum.';
        }
      }

      // -----------------------------------------------------------------------
      // 7. PENGENALAN BENTUK DAN SIFAT DASAR (GEOMETRI 2D & 3D)
      // -----------------------------------------------------------------------
      else if (tLower.contains('bentuk') || tLower.contains('sifat dasar') || (tLower.contains('geometri') && !tLower.contains('keliling') && !tLower.contains('luas'))) {
        levelTag = 'Dasar';
        if (versionType == 0) {
          visualType = 'shape_cube';
          visualData = const {'side': '6 cm'};
          visualLabel = 'Bangun Ruang Kubus';
          qText = 'Berapakah jumlah rusuk pada bangun ruang kubus dengan panjang rusuk 6 cm?';
          explanationText = 'Kubus memiliki 12 rusuk yang sama panjang.';
          correctAnsNum = 12;
        } else if (versionType == 1) {
          visualType = 'shape_circle';
          visualData = const {'radius': '7 cm'};
          visualLabel = 'Bangun Datar Lingkaran';
          qText = 'Bangun datar yang dibentuk oleh titik-titik berjarak sama (r = 7 cm) dari titik pusat adalah .....';
          explanationText = 'Bangun tersebut adalah Lingkaran.';
          textOptions = ['Lingkaran', 'Persegi', 'Segitiga', 'Trapesium'];
          textCorrectIndex = 0;
        } else if (versionType == 2) {
          visualType = 'shape_triangle';
          visualData = const {'base': '8 cm', 'height': '6 cm'};
          visualLabel = 'Segitiga Siku-siku';
          qText = 'Bangun datar yang memiliki 3 sisi dan 3 titik sudut seperti pada gambar adalah .....';
          explanationText = 'Bangun dengan 3 sisi dinamakan Segitiga.';
          textOptions = ['Segitiga', 'Persegi', 'Lingkaran', 'Jajaran Genjang'];
          textCorrectIndex = 0;
        } else if (versionType == 3) {
          visualType = 'shape_cylinder';
          visualData = const {'radius': '5 cm', 'height': '12 cm'};
          visualLabel = 'Bangun Ruang Tabung';
          qText = 'Berapakah jumlah sisi berbentuk lingkaran pada bangun ruang tabung di atas?';
          explanationText = 'Tabung memiliki 2 sisi berbentuk lingkaran (alas dan tutup).';
          correctAnsNum = 2;
        } else if (versionType == 4) {
          qText = 'Bangun datar yang memiliki 4 sisi sama panjang dan 4 sudut siku-siku adalah .....';
          explanationText = 'Bangun datar tersebut dinamakan Persegi.';
          textOptions = ['Persegi', 'Persegi Panjang', 'Segitiga', 'Trapesium'];
          textCorrectIndex = 0;
        } else if (versionType == 5) {
          qText = 'Berapakah jumlah titik sudut pada bangun ruang balok?';
          explanationText = 'Balok memiliki 8 titik sudut.';
          correctAnsNum = 8;
        } else if (versionType == 6) {
          qText = 'Bangun datar yang memiliki tepat 1 pasang sisi sejajar adalah .....';
          explanationText = 'Trapesium adalah bangun datar segiempat yang memiliki 1 pasang sisi sejajar.';
          textOptions = ['Trapesium', 'Persegi', 'Jajaran Genjang', 'Layang-layang'];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          qText = '$nameA melihat atap rumahnya berbentuk segitiga. Jumlah seluruh sudut di dalam segitiga tersebut adalah .....';
          explanationText = 'Jumlah sudut dalam segitiga selalu 180°.';
          correctAnsNum = 180;
        } else if (versionType == 8) {
          qText = 'Bangun ruang yang tidak memiliki titik sudut sama sekali adalah .....';
          explanationText = 'Bola tidak memiliki titik sudut maupun rusuk.';
          textOptions = ['Bola', 'Kubus', 'Balok', 'Prisma Segitiga'];
          textCorrectIndex = 0;
        } else {
          qText = 'Jumlah sisi pada piramida (Limas Segiempat) adalah .....';
          explanationText = 'Limas segiempat memiliki 1 alas segiempat dan 4 sisi tegak segitiga (total 5 sisi).';
          correctAnsNum = 5;
        }
      }

      // -----------------------------------------------------------------------
      // 8. PENGUKURAN SUDUT DAN SIMETRI
      // -----------------------------------------------------------------------
      else if (tLower.contains('sudut') || tLower.contains('simetri')) {
        levelTag = 'Dasar';
        if (versionType <= 1) {
          final clockQuiz = [
            {'h': 3, 'type': 'Siku-siku (90°)', 'exp': 'Pukul 03:00 jarum jam tegak lurus membentuk sudut 90°.'},
            {'h': 6, 'type': 'Lurus (180°)', 'exp': 'Pukul 06:00 jarum jam membentuk garis lurus 180°.'},
            {'h': 1, 'type': 'Lancip (<90°)', 'exp': 'Pukul 01:00 membentuk sudut lancip kurang dari 90°.'},
            {'h': 4, 'type': 'Tumpul (>90°)', 'exp': 'Pukul 04:00 membentuk sudut tumpul lebih dari 90°.'},
          ];
          final cItem = clockQuiz[random.nextInt(clockQuiz.length)];
          visualType = 'analog_clock';
          visualData = {'hour': cItem['h'], 'minute': 0};
          visualLabel = 'Jam ${cItem['h'].toString().padLeft(2, '0')}:00';
          qText = 'Sudut yang dibentuk oleh jarum jam pada pukul ${cItem['h'].toString().padLeft(2, '0')}:00 adalah sudut .....';
          explanationText = cItem['exp'] as String;
          final opts = ['Siku-siku (90°)', 'Lancip (<90°)', 'Tumpul (>90°)', 'Lurus (180°)'];
          textOptions = opts;
          textCorrectIndex = opts.indexOf(cItem['type'] as String);
        } else if (versionType == 2) {
          final deg = 90;
          visualType = 'shape_angle';
          visualData = {'degrees': deg, 'label': 'Sudut Siku-siku'};
          visualLabel = 'Model Sudut Siku-siku';
          qText = 'Berapakah besar sudut siku-siku seperti yang ditunjukkan pada gambar?';
          explanationText = 'Sudut siku-siku selalu berukuran tepat 90°.';
          correctAnsNum = 90;
        } else if (versionType == 3) {
          qText = 'Sudut yang besarnya kurang dari 90° dinamakan sudut .....';
          explanationText = 'Sudut lancip adalah sudut dengan besar 0° hingga <90°.';
          textOptions = ['Lancip', 'Siku-siku', 'Tumpul', 'Lurus'];
          textCorrectIndex = 0;
        } else if (versionType == 4) {
          qText = 'Sudut yang besarnya antara 90° dan 180° dinamakan sudut .....';
          explanationText = 'Sudut tumpul adalah sudut yang lebih dari 90° dan kurang dari 180°.';
          textOptions = ['Tumpul', 'Lancip', 'Siku-siku', 'Refleks'];
          textCorrectIndex = 0;
        } else if (versionType == 5) {
          qText = 'Berapakah jumlah simetri lipat yang dimiliki oleh bangun datar persegi?';
          explanationText = 'Persegi memiliki 4 simetri lipat.';
          correctAnsNum = 4;
        } else if (versionType == 6) {
          qText = 'Berapakah jumlah simetri lipat pada segitiga sama sisi?';
          explanationText = 'Segitiga sama sisi memiliki 3 simetri lipat.';
          correctAnsNum = 3;
        } else if (versionType == 7) {
          qText = 'Alat baku yang digunakan untuk mengukur besarnya sudut adalah .....';
          explanationText = 'Besar sudut diukur secara presisi menggunakan Busur Derajat.';
          textOptions = ['Busur Derajat', 'Penggaris Panjang', 'Jangka', 'Termometer'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          qText = 'Pukul 09.00 jarum pendek dan jarum panjang membentuk sudut siku-siku berukuran .....';
          explanationText = 'Sudut siku-siku = 90°.';
          correctAnsNum = 90;
        } else {
          qText = 'Bangun datar lingkaran memiliki simetri lipat sebanyak .....';
          explanationText = 'Lingkaran memiliki simetri lipat tak terhingga (tak terbatas).';
          textOptions = ['Tak terhingga', '4', '2', '1'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 9. KELILING DAN LUAS BANGUN DATAR
      // -----------------------------------------------------------------------
      else if (tLower.contains('keliling') || tLower.contains('luas bangun datar') || (tLower.contains('luas') && !tLower.contains('bangun ruang'))) {
        levelTag = 'Sedang';
        if (versionType == 0) {
          final s = random.nextInt(10) + 4;
          correctAnsNum = s * s;
          visualType = 'shape_rectangle';
          visualData = {'length': '$s cm', 'width': '$s cm'};
          visualLabel = 'Persegi (s = $s cm)';
          qText = 'Perhatikan gambar persegi di atas dengan s = $s cm. Luas persegi tersebut adalah .....';
          explanationText = 'Luas persegi = s × s = $s × $s = $correctAnsNum cm².';
        } else if (versionType == 1) {
          final p = random.nextInt(10) + 5;
          final l = random.nextInt(6) + 3;
          correctAnsNum = 2 * (p + l);
          visualType = 'shape_rectangle';
          visualData = {'length': '$p cm', 'width': '$l cm'};
          visualLabel = 'Persegi Panjang';
          qText = 'Berapakah keliling persegi panjang dengan p = $p cm dan l = $l cm pada gambar?';
          explanationText = 'Keliling = 2 × (p + l) = 2 × ($p + $l) = $correctAnsNum cm.';
        } else if (versionType == 2) {
          final alas = (random.nextInt(6) + 2) * 2;
          final tinggi = random.nextInt(8) + 3;
          correctAnsNum = (alas * tinggi) ~/ 2;
          visualType = 'shape_triangle';
          visualData = {'base': '$alas cm', 'height': '$tinggi cm'};
          visualLabel = 'Segitiga';
          qText = 'Hitunglah luas segitiga pada gambar dengan alas $alas cm dan tinggi $tinggi cm!';
          explanationText = 'Luas segitiga = 1/2 × alas × tinggi = 1/2 × $alas × $tinggi = $correctAnsNum cm².';
        } else if (versionType == 3) {
          final r = 7;
          correctAnsNum = 154; // (22/7) * 7 * 7
          visualType = 'shape_circle';
          visualData = {'radius': '$r cm'};
          visualLabel = 'Lingkaran (r = $r cm)';
          qText = 'Hitunglah luas lingkaran pada gambar jika jari-jarinya r = $r cm (π = 22/7)!';
          explanationText = 'Luas lingkaran = π × r² = (22/7) × 7 × 7 = 154 cm².';
        } else if (versionType == 4) {
          levelTag = 'Sedang';
          final pM = random.nextInt(15) + 10;
          final lM = random.nextInt(10) + 5;
          correctAnsNum = 2 * (pM + lM);
          qText = 'Lapangan sekolah berbentuk persegi panjang dengan panjang $pM meter dan lebar $lM meter. Berapakah keliling lapangan tersebut?';
          explanationText = 'Keliling lapangan = 2 × ($pM + $lM) = $correctAnsNum meter.';
        } else if (versionType == 5) {
          levelTag = 'HOTS';
          final sM = random.nextInt(6) + 4;
          correctAnsNum = sM * sM;
          qText = 'Kamar tidur $nameA berbentuk persegi dengan panjang sisi $sM meter. Berapakah luas lantai kamar tidur $nameA?';
          explanationText = 'Luas lantai = $sM × $sM = $correctAnsNum m².';
        } else if (versionType == 6) {
          levelTag = 'Sedang';
          final triSide = random.nextInt(12) + 6;
          correctAnsNum = triSide * 3;
          qText = 'Sebuah taman berbentuk segitiga sama sisi dengan panjang sisi $triSide cm. Berapakah keliling taman tersebut?';
          explanationText = 'Keliling segitiga sama sisi = 3 × $triSide = $correctAnsNum cm.';
        } else if (versionType == 7) {
          levelTag = 'HOTS';
          final lengthP = random.nextInt(12) + 8;
          final widthP = random.nextInt(6) + 4;
          final fenceLen = 2 * (lengthP + widthP);
          correctAnsNum = fenceLen;
          qText = 'Pak Budi ingin memasang pagar bambu mengelilingi kebunnya yang berbentuk persegi panjang (p = $lengthP m, l = $widthP m). Berapa meter panjang pagar yang dibutuhkan?';
          explanationText = 'Panjang pagar = Keliling = 2 × ($lengthP + $widthP) = $correctAnsNum meter.';
        } else if (versionType == 8) {
          final rad = 14;
          correctAnsNum = 88; // 2 * (22/7) * 14
          qText = 'Berapakah keliling lingkaran yang memiliki jari-jari r = $rad cm (π = 22/7)?';
          explanationText = 'Keliling lingkaran = 2 × π × r = 2 × (22/7) × 14 = 88 cm.';
        } else {
          levelTag = 'Dasar';
          final sideP = random.nextInt(8) + 4;
          correctAnsNum = sideP * 4;
          qText = 'Berapakah keliling persegi yang memiliki panjang sisi $sideP cm?';
          explanationText = 'Keliling persegi = 4 × s = 4 × $sideP = $correctAnsNum cm.';
        }
      }

      // -----------------------------------------------------------------------
      // 10. BANGUN RUANG LANJUTAN
      // -----------------------------------------------------------------------
      else if (tLower.contains('bangun ruang') || tLower.contains('volume')) {
        levelTag = 'HOTS';
        if (versionType == 0) {
          final p = random.nextInt(6) + 4;
          final l = random.nextInt(4) + 2;
          final t = random.nextInt(4) + 2;
          correctAnsNum = p * l * t;
          visualType = 'shape_cylinder';
          visualData = const {'radius': '7 cm', 'height': '10 cm'};
          visualLabel = 'Balok p=$p cm, l=$l cm, t=$t cm';
          qText = 'Sebuah balok berukuran p = $p cm, l = $l cm, t = $t cm. Volume balok tersebut adalah .....';
          explanationText = 'Volume Balok = p × l × t = $p × $l × $t = $correctAnsNum cm³.';
        } else if (versionType == 1) {
          final s = random.nextInt(5) + 3;
          correctAnsNum = s * s * s;
          visualType = 'shape_cube';
          visualData = {'side': '$s cm'};
          visualLabel = 'Kubus (s = $s cm)';
          qText = 'Sebuah kubus pada gambar memiliki panjang rusuk $s cm. Volume kubus tersebut adalah .....';
          explanationText = 'Volume Kubus = s × s × s = $s × $s × $s = $correctAnsNum cm³.';
        } else if (versionType == 2) {
          final r = 7;
          final t = random.nextInt(5) + 5;
          visualType = 'shape_cylinder';
          visualData = {'radius': '$r cm', 'height': '$t cm'};
          visualLabel = 'Tabung (r = $r cm, t = $t cm)';
          qText = 'Bangun ruang tabung pada gambar dengan r = $r cm dan tinggi t = $t cm memiliki alas berbentuk .....';
          explanationText = 'Alas tabung berbentuk Lingkaran.';
          textOptions = ['Lingkaran', 'Persegi', 'Segitiga', 'Oval'];
          textCorrectIndex = 0;
        } else if (versionType == 3) {
          levelTag = 'HOTS';
          final pBak = random.nextInt(4) + 6; // 6..9 dm
          final lBak = random.nextInt(3) + 4; // 4..6 dm
          final tBak = random.nextInt(3) + 5; // 5..7 dm
          correctAnsNum = pBak * lBak * tBak;
          qText = 'Bak mandi di rumah $nameA berbentuk balok dengan panjang $pBak dm, lebar $lBak dm, dan tinggi $tBak dm. Jika diisi penuh, berapa liter volume air bak tersebut? (1 dm³ = 1 Liter)';
          explanationText = 'Volume = p × l × t = $pBak × $lBak × $tBak = $correctAnsNum Liter.';
        } else if (versionType == 4) {
          levelTag = 'Sedang';
          final edge = random.nextInt(4) + 4;
          correctAnsNum = 6 * edge * edge;
          qText = 'Berapakah luas permukaan kubus yang memiliki panjang rusuk $edge cm?';
          explanationText = 'Luas Permukaan Kubus = 6 × s² = 6 × ($edge × $edge) = $correctAnsNum cm².';
        } else if (versionType == 5) {
          levelTag = 'Sedang';
          qText = 'Bangun ruang yang terdiri dari 6 sisi berbentuk persegi yang kongruen adalah .....';
          explanationText = 'Bangun ruang tersebut adalah Kubus.';
          textOptions = ['Kubus', 'Balok', 'Prisma', 'Limas'];
          textCorrectIndex = 0;
        } else if (versionType == 6) {
          levelTag = 'HOTS';
          final rT = 7;
          final tT = 10;
          correctAnsNum = 1540; // (22/7) * 7 * 7 * 10
          qText = 'Kaleng biskuit berbentuk tabung memiliki jari-jari r = $rT cm dan tinggi t = $tT cm. Berapakah volume kaleng tersebut (π = 22/7)?';
          explanationText = 'Volume Tabung = π × r² × t = (22/7) × 7 × 7 × 10 = 1.540 cm³.';
        } else if (versionType == 7) {
          qText = 'Jaring-jaring yang terdiri dari 2 lingkaran dan 1 selimut persegi panjang merupakan jaring-jaring .....';
          explanationText = 'Model jaring-jaring tersebut membentuk bangun Tabung.';
          textOptions = ['Tabung', 'Kerucut', 'Bola', 'Prisma'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          qText = 'Berapakah jumlah sisi pada bangun ruang prisma segitiga?';
          explanationText = 'Prisma segitiga memiliki 2 alas/tutup berbentuk segitiga + 3 sisi tegak = 5 sisi.';
          correctAnsNum = 5;
        } else {
          final sC = random.nextInt(4) + 5;
          correctAnsNum = sC * sC * sC;
          qText = 'Akuarium $nameB berbentuk kubus dengan rusuk $sC dm. Berapa liter air untuk mengisi akuarium sampai penuh?';
          explanationText = 'Volume = s³ = $sC × $sC × $sC = $correctAnsNum dm³ (Liter).';
        }
      }

      // -----------------------------------------------------------------------
      // 11. PENGUKURAN DASAR DAN SATUAN
      // -----------------------------------------------------------------------
      else if (tLower.contains('pengukuran dasar') || (tLower.contains('pengukuran') && tLower.contains('satuan'))) {
        levelTag = 'Dasar';
        if (versionType == 0) {
          qText = '1 jam sama dengan berapa menit?';
          explanationText = '1 jam = 60 menit.';
          correctAnsNum = 60;
        } else if (versionType == 1) {
          final jam = random.nextInt(4) + 2;
          correctAnsNum = jam * 60;
          qText = '$jam jam setara dengan berapa menit?';
          explanationText = '$jam jam × 60 = $correctAnsNum menit.';
        } else if (versionType == 2) {
          qText = 'Alat yang digunakan untuk mengukur berat benda adalah .....';
          explanationText = 'Berat diukur menggunakan Timbangan.';
          textOptions = ['Timbangan', 'Penggaris', 'Termometer', 'Jam dinding'];
          textCorrectIndex = 0;
        } else if (versionType == 3) {
          final kg = random.nextInt(5) + 2;
          correctAnsNum = kg * 1000;
          qText = '$kg kilogram (kg) setara dengan berapa gram (g)?';
          explanationText = '1 kg = 1.000 g, jadi $kg kg = $correctAnsNum g.';
        } else if (versionType == 4) {
          levelTag = 'Sedang';
          final startH = 8;
          final endH = 11;
          correctAnsNum = (endH - startH) * 60;
          qText = '$nameA belajar kelompok mulai pukul 0$startH.00 WIB sampai pukul $endH.00 WIB. Berapa menit $nameA belajar kelompok?';
          explanationText = 'Lama belajar = ${endH - startH} jam × 60 menit = $correctAnsNum menit.';
        } else if (versionType == 5) {
          levelTag = 'Dasar';
          qText = 'Alat baku yang paling tepat untuk mengukur panjang meja belajar adalah .....';
          explanationText = 'Panjang meja belajar diukur dengan Penggaris / Meteran.';
          textOptions = ['Penggaris / Meteran', 'Timbangan', 'Stopwatch', 'Gelas ukur'];
          textCorrectIndex = 0;
        } else if (versionType == 6) {
          final kgFruit = random.nextInt(4) + 3;
          correctAnsNum = kgFruit * 1000;
          qText = 'Ibu membeli $kgFruit kg buah apel di ${_storeNames[random.nextInt(_storeNames.length)]}. Berat apel tersebut setara dengan ..... gram.';
          explanationText = '$kgFruit kg × 1.000 = $correctAnsNum gram.';
        } else if (versionType == 7) {
          qText = '1 hari 1 malam sama dengan berapa jam?';
          explanationText = '1 hari = 24 jam.';
          correctAnsNum = 24;
        } else if (versionType == 8) {
          final mVal = random.nextInt(5) + 2;
          correctAnsNum = mVal * 100;
          qText = 'Panjang tali $nameB adalah $mVal meter. Panjang tali tersebut dalam satuan sentimeter (cm) adalah .....';
          explanationText = '$mVal m × 100 = $correctAnsNum cm.';
        } else {
          qText = 'Satuan internasional (SI) yang digunakan untuk mengukur besarnya waktu adalah .....';
          explanationText = 'Satuan baku waktu adalah Detik (sekon).';
          textOptions = ['Detik (Sekon)', 'Meter', 'Kilogram', 'Liter'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 12. HUBUNGAN ANTARSATUAN / KONVERSI
      // -----------------------------------------------------------------------
      else if (tLower.contains('konversi') || tLower.contains('hubungan antarsatuan')) {
        levelTag = 'Sedang';
        if (versionType == 0) {
          final km = random.nextInt(8) + 2;
          correctAnsNum = km * 1000;
          qText = '$km kilometer (km) sama dengan berapa meter (m)?';
          explanationText = '1 km = 1.000 m. Jadi $km km × 1.000 = $correctAnsNum m.';
        } else if (versionType == 1) {
          final m = random.nextInt(8) + 2;
          correctAnsNum = m * 100;
          qText = '$m meter (m) sama dengan berapa sentimeter (cm)?';
          explanationText = '1 m = 100 cm. Jadi $m m × 100 = $correctAnsNum cm.';
        } else if (versionType == 2) {
          final ton = random.nextInt(4) + 1;
          correctAnsNum = ton * 1000;
          qText = '$ton Ton setara dengan berapa kilogram (kg)?';
          explanationText = '1 Ton = 1.000 kg. Jadi $ton Ton = $correctAnsNum kg.';
        } else if (versionType == 3) {
          final km = random.nextInt(4) + 1;
          final m = random.nextInt(500) + 100;
          correctAnsNum = (km * 1000) + m;
          qText = 'Hasil dari $km km + $m m adalah ..... meter.';
          explanationText = '$km km = ${km * 1000} m. Lalu ${km * 1000} + $m = $correctAnsNum m.';
        } else if (versionType == 4) {
          levelTag = 'Sedang';
          final distKm = random.nextInt(3) + 2;
          final distM = random.nextInt(400) + 100;
          correctAnsNum = (distKm * 1000) + distM;
          qText = 'Jarak rumah $nameA ke sekolah adalah $distKm km lebih $distM meter. Berapa total jarak tersebut jika dinyatakan dalam meter?';
          explanationText = '$distKm km = ${distKm * 1000} m. Total = ${distKm * 1000} + $distM = $correctAnsNum meter.';
        } else if (versionType == 5) {
          levelTag = 'HOTS';
          final tonVal = 2;
          final kgVal = 400;
          correctAnsNum = (tonVal * 1000) + kgVal;
          qText = 'Toko beras menerima pasokan $tonVal Ton beras dan $kgVal kg beras. Berapa total kilogram beras di toko tersebut?';
          explanationText = '2 Ton = 2.000 kg. Total = 2.000 + 400 = $correctAnsNum kg.';
        } else if (versionType == 6) {
          final liter = random.nextInt(5) + 2;
          correctAnsNum = liter * 1000;
          qText = '$liter liter (L) setara dengan berapa mililiter (mL)?';
          explanationText = '1 L = 1.000 mL. Jadi $liter L = $correctAnsNum mL.';
        } else if (versionType == 7) {
          levelTag = 'Sedang';
          final mLen = 3;
          final cutCm = 80;
          correctAnsNum = (mLen * 100) - cutCm;
          qText = '$nameB membeli pita sepanjang $mLen meter. Ia memotongnya $cutCm cm untuk menghias kado. Berapa cm sisa pita $nameB?';
          explanationText = '$mLen m = 300 cm. Sisa = 300 - 80 = $correctAnsNum cm.';
        } else if (versionType == 8) {
          final kuintal = random.nextInt(4) + 2;
          correctAnsNum = kuintal * 100;
          qText = '$kuintal Kuintal setara dengan berapa kilogram (kg)?';
          explanationText = '1 Kuintal = 100 kg. Jadi $kuintal Kuintal = $correctAnsNum kg.';
        } else {
          final hVal = 1;
          final minVal = 45;
          correctAnsNum = (hVal * 60) + minVal;
          qText = '$hVal jam $minVal menit setara dengan berapa menit?';
          explanationText = '1 jam = 60 menit. 60 + 45 = $correctAnsNum menit.';
        }
      }

      // -----------------------------------------------------------------------
      // 13. PENGUKURAN GABUNGAN (KECEPATAN & DEBIT)
      // -----------------------------------------------------------------------
      else if (tLower.contains('pengukuran gabungan') || tLower.contains('kecepatan') || tLower.contains('debit')) {
        levelTag = 'HOTS';
        if (versionType <= 1) {
          final speeds = [40, 50, 60, 70, 80];
          final k = speeds[random.nextInt(speeds.length)];
          final w = random.nextInt(3) + 2;
          correctAnsNum = k * w;
          qText = 'Sebuah mobil melaju dengan kecepatan $k km/jam selama $w jam. Berapakah jarak tempuhnya?';
          explanationText = 'Jarak = Kecepatan × Waktu = $k km/jam × $w jam = $correctAnsNum km.';
        } else if (versionType == 2) {
          final v = (random.nextInt(4) + 2) * 60;
          final w = 2;
          correctAnsNum = v ~/ w;
          qText = 'Sebuah kran mengalirkan air $v liter dalam waktu $w menit. Berapakah debit air per menit?';
          explanationText = 'Debit = Volume / Waktu = $v liter / $w menit = $correctAnsNum liter/menit.';
        } else if (versionType == 3) {
          final sVel = random.nextInt(4) + 12;
          final sTime = 3;
          correctAnsNum = sVel * sTime;
          qText = '$nameA mengendarai sepeda dengan kecepatan $sVel km/jam selama $sTime jam. Berapakah jarak yang sudah ditempuh $nameA?';
          explanationText = 'Jarak = Kecepatan × Waktu = $sVel × $sTime = $correctAnsNum km.';
        } else if (versionType == 4) {
          final poolVol = 1200;
          final deb = 60;
          correctAnsNum = poolVol ~/ deb;
          qText = 'Sebuah bak kolam berkapasitas $poolVol liter diisi air dari keran dengan debit $deb liter/menit. Berapa menit waktu yang diperlukan hingga penuh?';
          explanationText = 'Waktu = Volume / Debit = 1.200 / 60 = $correctAnsNum menit.';
        } else if (versionType == 5) {
          qText = 'Rumus untuk menghitung Kecepatan (K) jika diketahui Jarak (J) dan Waktu (W) adalah .....';
          explanationText = 'Kecepatan = Jarak / Waktu (K = J / W).';
          textOptions = ['Jarak / Waktu', 'Jarak × Waktu', 'Waktu / Jarak', 'Jarak + Waktu'];
          textCorrectIndex = 0;
        } else if (versionType == 6) {
          final d = 180;
          final t = 3;
          correctAnsNum = d ~/ t;
          qText = 'Ayah menempuh jarak $d km dengan mobil dalam waktu $t jam. Berapa kecepatan rata-rata mobil Ayah?';
          explanationText = 'Kecepatan = Jarak / Waktu = $d / $t = $correctAnsNum km/jam.';
        } else if (versionType == 7) {
          qText = 'Rumus untuk menghitung Debit air (D) adalah .....';
          explanationText = 'Debit = Volume / Waktu.';
          textOptions = ['Volume / Waktu', 'Volume × Waktu', 'Waktu / Volume', 'Luas / Waktu'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          final debSec = 5;
          final timeSec = 40;
          correctAnsNum = debSec * timeSec;
          qText = 'Sebuah pompa air menyemprotkan air dengan debit $debSec liter/detik. Berapa liter volume air yang dipompa selama $timeSec detik?';
          explanationText = 'Volume = Debit × Waktu = $debSec × $timeSec = $correctAnsNum liter.';
        } else {
          qText = 'Satuan baku yang digunakan untuk menyatakan Kecepatan kendaraan adalah .....';
          explanationText = 'Kecepatan diukur dalam km/jam (atau m/s).';
          textOptions = ['km/jam', 'km/liter', 'liter/menit', 'meter/kg'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 14. PENGUMPULAN DAN PENGELOMPOKAN DASAR
      // -----------------------------------------------------------------------
      else if (tLower.contains('pengumpulan') || tLower.contains('pengelompokan')) {
        levelTag = 'Dasar';
        if (versionType == 0) {
          qText = 'Sistem turus (tally) "|||| |" mewakili bilangan berapakah?';
          explanationText = 'Satu ikat turus "||||" bernilai 5, ditambah 1 garis "|" menjadi 6.';
          correctAnsNum = 6;
        } else if (versionType == 1) {
          final countA = random.nextInt(5) + 3;
          final countB = random.nextInt(5) + 3;
          correctAnsNum = countA + countB;
          qText = 'Di dalam keranjang terdapat $countA apel merah dan $countB apel hijau. Jumlah seluruh apel adalah .....';
          explanationText = 'Pengelompokan total = $countA + $countB = $correctAnsNum.';
        } else if (versionType == 2) {
          qText = 'Metode pengumpulan data dengan cara memberikan daftar pertanyaan tertulis dinamakan .....';
          explanationText = 'Daftar pertanyaan tertulis disebut Angket / Kuesioner.';
          textOptions = ['Angket / Kuesioner', 'Wawancara', 'Pengamatan langsung', 'Dokumentasi'];
          textCorrectIndex = 0;
        } else if (versionType == 3) {
          final redM = random.nextInt(4) + 3;
          final blueM = random.nextInt(4) + 4;
          final yelM = random.nextInt(4) + 2;
          correctAnsNum = redM + blueM + yelM;
          qText = '$nameA mengelompokkan mainan kelereng berdasarkan warna: $redM merah, $blueM biru, dan $yelM kuning. Berapa total kelereng $nameA?';
          explanationText = 'Total = $redM + $blueM + $yelM = $correctAnsNum kelereng.';
        } else if (versionType == 4) {
          qText = 'Pengumpulan data dengan cara tanya jawab secara langsung dengan narasumber dinamakan .....';
          explanationText = 'Tanya jawab langsung dinamakan Wawancara.';
          textOptions = ['Wawancara', 'Kuesioner', 'Observasi', 'Dokumentasi'];
          textCorrectIndex = 0;
        } else if (versionType == 5) {
          qText = 'Sistem turus (tally) "|||| |||| ||" mewakili bilangan berapakah?';
          explanationText = 'Dua ikat turus (5 + 5) + 2 garis = 12.';
          correctAnsNum = 12;
        } else if (versionType == 6) {
          qText = '$nameB mencatat makanan favorit 20 temannya secara langsung di kelas. Kegiatan tersebut merupakan contoh .....';
          explanationText = 'Kegiatan mencatat data disebut Pengumpulan Data.';
          textOptions = ['Pengumpulan Data', 'Pengolahan Nilai', 'Penyajian Grafik', 'Analisa Peluang'];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          qText = 'Pengamatan langsung terhadap suatu kejadian dinamakan .....';
          explanationText = 'Pengamatan langsung dinamakan Observasi.';
          textOptions = ['Observasi', 'Wawancara', 'Angket', 'Uji Coba'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          qText = 'Data yang dikumpulkan secara langsung oleh peneliti dinamakan data .....';
          explanationText = 'Data langsung dinamakan Data Primer.';
          textOptions = ['Primer', 'Sekunder', 'Tersier', 'Kuantitatif'];
          textCorrectIndex = 0;
        } else {
          qText = 'Mengurutkan nilai dari yang terkecil hingga terbesar bertujuan untuk .....';
          explanationText = 'Mengurutkan data mempermudah dalam mencari nilai terkecil, terbesar, dan nilai tengah.';
          textOptions = ['Mempermudah analisa data', 'Menghapus data', 'Menambah data', 'Mengubah data'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 15. PENYAJIAN DATA VISUAL DASAR (DIAGRAM BATANG & PIKTOGRAM)
      // -----------------------------------------------------------------------
      else if (tLower.contains('penyajian data') || tLower.contains(' visual') || tLower.contains('piktogram') || tLower.contains('diagram batang') || tLower.contains('analisa data')) {
        levelTag = 'Sedang';
        if (versionType == 0) {
          final valApel = (random.nextInt(4) + 2) * 10;
          final valJeruk = (random.nextInt(3) + 1) * 10;
          final selisih = (valApel - valJeruk).abs();
          visualType = 'bar_chart';
          visualData = {
            'categories': ['Apel', 'Jeruk', 'Mangga', 'Pisang'],
            'values': [valApel, valJeruk, 25, 30],
          };
          visualLabel = 'Diagram Batang Panen Buah (kg)';
          qText = 'Perhatikan diagram batang di atas! Berapakah selisih hasil panen Apel ($valApel kg) dan Jeruk ($valJeruk kg)?';
          explanationText = 'Selisih panen = $valApel kg - $valJeruk kg = $selisih kg.';
          correctAnsNum = selisih;
        } else if (versionType == 1) {
          final symbolVal = 5;
          final numSymbols = random.nextInt(4) + 3;
          correctAnsNum = symbolVal * numSymbols;
          visualType = 'pictogram';
          visualData = {
            'category': 'Data Penjualan Apel',
            'count': correctAnsNum,
            'scale': symbolVal,
            'symbol': '🍎',
          };
          visualLabel = 'Piktogram Penjualan Apel';
          qText = 'Pada diagram piktogram di atas (1 🍎 = $symbolVal unit), jika terdapat $numSymbols buah 🍎, berapakah total apel yang terjual?';
          explanationText = '$numSymbols × $symbolVal = $correctAnsNum unit apel.';
        } else if (versionType == 2) {
          final a = random.nextInt(20) + 10;
          final b = random.nextInt(20) + 10;
          final c = random.nextInt(20) + 10;
          correctAnsNum = a + b + c;
          visualType = 'bar_chart';
          visualData = {
            'categories': ['Senin', 'Selasa', 'Rabu'],
            'values': [a, b, c],
          };
          visualLabel = 'Diagram Penjualan Buku Harian';
          qText = 'Berdasarkan diagram batang di atas: Senin = $a, Selasa = $b, Rabu = $c. Berapakah total buku yang terjual selama 3 hari?';
          explanationText = 'Total = $a + $b + $c = $correctAnsNum buku.';
        } else if (versionType == 3) {
          final scaleBook = 10;
          final countSym = random.nextInt(4) + 4;
          correctAnsNum = scaleBook * countSym;
          visualType = 'pictogram';
          visualData = {
            'category': 'Buku di Perpustakaan',
            'count': correctAnsNum,
            'scale': scaleBook,
            'symbol': '📚',
          };
          visualLabel = 'Piktogram Koleksi Buku';
          qText = 'Di piktogram perpustakaan (1 📚 = $scaleBook buku), jika ada $countSym buah 📚, berapa jumlah buku di perpustakaan?';
          explanationText = '$countSym × $scaleBook = $correctAnsNum buku.';
        } else if (versionType == 4) {
          qText = 'Penyajian data dalam bentuk gambar atau simbol-simbol dinamakan .....';
          explanationText = 'Penyajian data berbentuk gambar dinamakan Piktogram.';
          textOptions = ['Piktogram', 'Diagram Batang', 'Diagram Garis', 'Tabel Nilai'];
          textCorrectIndex = 0;
        } else if (versionType == 5) {
          qText = 'Diagram yang menyajikan data menggunakan persegi panjang tegak atau mendatar dinamakan .....';
          explanationText = 'Diagram tersebut adalah Diagram Batang.';
          textOptions = ['Diagram Batang', 'Diagram Lingkaran', 'Piktogram', 'Diagram Garis'];
          textCorrectIndex = 0;
        } else if (versionType == 6) {
          final valA = 40;
          final valB = 60;
          final valC = 30;
          correctAnsNum = valB;
          visualType = 'bar_chart';
          visualData = {
            'categories': ['Kelas 1', 'Kelas 2', 'Kelas 3'],
            'values': [valA, valB, valC],
          };
          visualLabel = 'Jumlah Siswa Per Kelas';
          qText = 'Berdasarkan diagram batang jumlah siswa (Kelas 1=$valA, Kelas 2=$valB, Kelas 3=$valC), kelas manakah yang memiliki siswa terbanyak?';
          explanationText = 'Kelas 2 memiliki siswa terbanyak yaitu $valB siswa.';
          textOptions = ['Kelas 2 ($valB)', 'Kelas 1 ($valA)', 'Kelas 3 ($valC)', 'Semua sama'];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          qText = 'Diagram yang paling cocok untuk menampilkan perubahan data dari waktu ke waktu secara berkesinambungan adalah .....';
          explanationText = 'Data perkembangan berkala disajikan paling baik dengan Diagram Garis.';
          textOptions = ['Diagram Garis', 'Diagram Batang', 'Piktogram', 'Tabel Turus'];
          textCorrectIndex = 0;
        } else if (versionType == 8) {
          final totalStudents = 30;
          final n80 = 12;
          final n90 = 10;
          correctAnsNum = totalStudents - (n80 + n90);
          qText = 'Dari $totalStudents siswa, 12 siswa mendapat nilai 80 dan 10 siswa mendapat nilai 90. Sisanya mendapat nilai 100. Berapa siswa yang mendapat nilai 100?';
          explanationText = '$totalStudents - (12 + 10) = 30 - 22 = $correctAnsNum siswa.';
        } else {
          qText = 'Bagian-bagian pada diagram lingkaran biasanya dinyatakan dalam bentuk .....';
          explanationText = 'Diagram lingkaran menyajikan data dalam bentuk Persen (%) atau Derajat (°).';
          textOptions = ['Persen (%) atau Derajat (°)', 'Meter', 'Gram', 'Turus'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 16. PENGOLAHAN DATA LANJUTAN & STATISTIKA DASAR
      // -----------------------------------------------------------------------
      else if (tLower.contains('pengolahan data') || tLower.contains('statistika') || tLower.contains('mean') || tLower.contains('median') || tLower.contains('modus')) {
        levelTag = 'HOTS';
        if (versionType == 0) {
          final baseVal = random.nextInt(4) + 6;
          final dataArr = [baseVal, baseVal + 1, baseVal, baseVal + 2, baseVal];
          correctAnsNum = baseVal;
          visualType = 'bar_chart';
          visualData = {
            'categories': ['Val 1', 'Val 2', 'Val 3', 'Val 4', 'Val 5'],
            'values': dataArr,
          };
          visualLabel = 'Frekuensi Data Ulangan';
          qText = 'Diberikan data nilai ulangan pada diagram: ${dataArr.join(", ")}. Berapakah nilai Modus (nilai tersering muncul)?';
          explanationText = 'Modus adalah nilai dengan frekuensi terbanyak. Angka $baseVal muncul paling sering (3 kali).';
        } else if (versionType == 1) {
          final v1 = 70;
          final v2 = 80;
          final v3 = 90;
          correctAnsNum = (v1 + v2 + v3) ~/ 3;
          qText = 'Hitunglah nilai rata-rata (Mean) dari data berikut: $v1, $v2, $v3 !';
          explanationText = 'Rata-rata = ($v1 + $v2 + $v3) / 3 = 240 / 3 = $correctAnsNum.';
        } else if (versionType == 2) {
          final sortedData = [6, 7, 8, 9, 10];
          correctAnsNum = sortedData[2];
          qText = 'Berapakah nilai Tengah (Median) dari data terurut: ${sortedData.join(", ")} ?';
          explanationText = 'Median adalah data yang berada tepat di tengah (posisi ke-3), yaitu ${sortedData[2]}.';
        } else if (versionType == 3) {
          final scores = [80, 90, 70, 80, 80];
          correctAnsNum = 80;
          qText = 'Nilai matematika $nameA adalah ${scores.join(", ")}. Berapakah Modus nilai ulangan $nameA?';
          explanationText = 'Modus = 80 (muncul 3 kali).';
        } else if (versionType == 4) {
          final heights = [130, 135, 140, 135];
          correctAnsNum = (130 + 135 + 140 + 135) ~/ 4;
          qText = 'Tinggi 4 siswa adalah ${heights.join(" cm, ")} cm. Berapakah rata-rata (Mean) tinggi badan mereka?';
          explanationText = 'Rata-rata = 540 / 4 = $correctAnsNum cm.';
        } else if (versionType == 5) {
          qText = 'Nilai data yang berada tepat di tengah setelah data diurutkan dari terkecil ke terbesar dinamakan .....';
          explanationText = 'Nilai tengah dinamakan Median.';
          textOptions = ['Median', 'Mean', 'Modus', 'Jangkauan'];
          textCorrectIndex = 0;
        } else if (versionType == 6) {
          qText = 'Jumlah seluruh data dibagi dengan banyaknya data dinamakan .....';
          explanationText = 'Pengertian tersebut adalah Rata-rata (Mean).';
          textOptions = ['Mean (Rata-rata)', 'Median', 'Modus', 'Diagram'];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          final sc = [7, 8, 9, 8, 8];
          correctAnsNum = 8;
          qText = '$nameB memperoleh nilai ulangan: ${sc.join(", ")}. Berapakah nilai rata-rata $nameB?';
          explanationText = 'Total = 40. Rata-rata = 40 / 5 = 8.';
        } else if (versionType == 8) {
          final maxV = 95;
          final minV = 60;
          correctAnsNum = maxV - minV;
          qText = 'Nilai tertinggi ulangan adalah $maxV dan nilai terendah adalah $minV. Berapakah selisih (jangkauan) nilai tersebut?';
          explanationText = 'Jangkauan = Nilai Tertinggi - Nilai Terendah = $maxV - $minV = $correctAnsNum.';
        } else {
          qText = 'Nilai yang paling sering muncul dalam suatu kelompok data dinamakan .....';
          explanationText = 'Nilai dengan frekuensi terbanyak disebut Modus.';
          textOptions = ['Modus', 'Mean', 'Median', 'Rata-rata'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 17. PENGENALAN POLA GAMBAR DAN BENTUK (ALJABAR & POLA VISUAL)
      // -----------------------------------------------------------------------
      else if (tLower.contains('pola gambar') || (tLower.contains('pola') && tLower.contains('bentuk'))) {
        levelTag = 'Dasar';
        if (versionType == 0) {
          visualType = 'pattern_boxes';
          visualData = const {
            'sequence': ['2', '4', '6', '?'],
          };
          visualLabel = 'Pola Gambar Berurutan (+2)';
          qText = 'Perhatikan pola gambar urutan angka pada kotak di atas: 2, 4, 6, [ ? ]. Angka untuk mengisi tanda tanya adalah .....';
          explanationText = 'Pola bertambah 2 (+2): 6 + 2 = 8.';
          correctAnsNum = 8;
        } else if (versionType == 1) {
          visualType = 'pattern_boxes';
          visualData = const {
            'sequence': ['1', '3', '5', '?'],
          };
          visualLabel = 'Pola Gambar Bilangan Ganjil';
          qText = 'Perhatikan susunan pola kotak di atas: 1, 3, 5, [ ? ]. Angka berikutnya yang tepat adalah .....';
          explanationText = 'Pola bertambah 2 (+2): 5 + 2 = 7.';
          correctAnsNum = 7;
        } else if (versionType == 2) {
          qText = 'Susunan pola korek api: Gambar 1 (3 batang), Gambar 2 (5 batang), Gambar 3 (7 batang). Berapa batang pada Gambar 4?';
          explanationText = 'Pola bertambah 2 (+2): 3, 5, 7, 9 batang.';
          correctAnsNum = 9;
        } else if (versionType == 3) {
          final mStart = 2;
          final mStep = 4;
          correctAnsNum = mStart + (mStep * 3);
          qText = '$nameA merangkai manik-manik dengan pola bertambah: 2, 6, 10, [ ? ]. Berapa jumlah manik-manik pada urutan ke-4?';
          explanationText = 'Pola bertambah 4 (+4): 10 + 4 = 14.';
        } else if (versionType == 4) {
          final p4 = 12;
          correctAnsNum = p4;
          qText = 'Pola susunan segitiga bertambah 3 (+3): 3, 6, 9, [ ? ]. Angka berikutnya adalah .....';
          explanationText = '9 + 3 = 12.';
        } else if (versionType == 5) {
          visualType = 'pattern_boxes';
          visualData = const {
            'sequence': ['25', '20', '15', '?'],
          };
          visualLabel = 'Pola Berkurang (-5)';
          qText = 'Perhatikan pola berkurang pada kotak di atas: 25, 20, 15, [ ? ]. Angka selanjutnya adalah .....';
          explanationText = 'Pola berkurang 5 (-5): 15 - 5 = 10.';
          correctAnsNum = 10;
        } else if (versionType == 6) {
          qText = 'Pola lantai susunan ubin: Gambar 1 (1 ubin), Gambar 2 (4 ubin), Gambar 3 (9 ubin). Pola ini merupakan contoh pola bilangan .....';
          explanationText = '1, 4, 9, 16 adalah pola bilangan kuadrat (persegi).';
          textOptions = ['Kuadrat / Persegi', 'Segitiga', 'Ganjil', 'Kelipatan 5'];
          textCorrectIndex = 0;
        } else if (versionType == 7) {
          correctAnsNum = 32;
          qText = 'Pola perkalian 2 (×2): 2, 4, 8, 16, [ ? ]. Angka berikutnya adalah .....';
          explanationText = '16 × 2 = 32.';
        } else if (versionType == 8) {
          correctAnsNum = 21;
          qText = 'Pola bertambah 4 (+4): 5, 9, 13, 17, [ ? ]. Angka berikutnya adalah .....';
          explanationText = '17 + 4 = 21.';
        } else {
          qText = 'Pola warna pita $nameB: Merah, Biru, Merah, Biru, ..... Pita pada urutan ke-5 berwarna .....';
          explanationText = 'Urutan ganjil (1, 3, 5) berwarna Merah.';
          textOptions = ['Merah', 'Biru', 'Kuning', 'Hijau'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 18. POLA BILANGAN & ALJABAR DASAR
      // -----------------------------------------------------------------------
      else if (tLower.contains('pola bilangan') || tLower.contains('aljabar') || (tLower.contains('pola') && !tLower.contains('gambar'))) {
        levelTag = 'Sedang';
        final step = random.nextInt(4) + 2;
        final start = random.nextInt(5) + 2;

        if (versionType == 0) {
          final n1 = start;
          final n2 = start + step;
          final n3 = start + (step * 2);
          correctAnsNum = start + (step * 3);
          visualType = 'pattern_boxes';
          visualData = {
            'sequence': ['$n1', '$n2', '$n3', '?'],
          };
          visualLabel = 'Pola Bilangan Loncat (+$step)';
          qText = 'Perhatikan pola bilangan loncat pada kotak di atas: $n1, $n2, $n3, [ ? ]. Angka berikutnya adalah .....';
          explanationText = 'Pola bertambah $step (+$step): $n3 + $step = $correctAnsNum.';
        } else if (versionType == 1) {
          final xVal = random.nextInt(5) + 2;
          final constVal = random.nextInt(4) + 1;
          final totalVal = xVal + constVal;
          correctAnsNum = xVal;
          visualType = 'algebra_balance';
          visualData = {
            'leftText': 'x + $constVal',
            'rightText': '$totalVal',
          };
          visualLabel = 'Timbangan Aljabar (Seimbang)';
          qText = 'Perhatikan timbangan seimbang di atas! Jika x + $constVal = $totalVal, berapakah nilai x?';
          explanationText = 'Timbangan seimbang: x + $constVal = $totalVal ➔ x = $totalVal - $constVal = $correctAnsNum.';
        } else if (versionType == 2) {
          final n1 = start * 10;
          final n2 = (start - 1) * 10;
          final n3 = (start - 2) * 10;
          correctAnsNum = (start - 3) * 10;
          visualType = 'pattern_boxes';
          visualData = {
            'sequence': ['$n1', '$n2', '$n3', '?'],
          };
          visualLabel = 'Pola Berkurang (-10)';
          qText = 'Perhatikan pola berkurang pada kotak di atas: $n1, $n2, $n3, [ ? ]. Angka berikutnya adalah .....';
          explanationText = 'Pola berkurang 10 (-10): $n3 - 10 = $correctAnsNum.';
        } else if (versionType == 3) {
          levelTag = 'Sedang';
          final weekAdd = 5000;
          final week4 = weekAdd * 4;
          correctAnsNum = week4;
          qText = 'Setiap minggu tabungan $nameA bertambah Rp $weekAdd. Minggu ke-1 = Rp 5.000, Minggu ke-2 = Rp 10.000, Minggu ke-3 = Rp 15.000. Berapa total tabungan $nameA pada Minggu ke-4?';
          explanationText = 'Pola bertambah 5.000: Minggu ke-4 = Rp $correctAnsNum.';
        } else if (versionType == 4) {
          final yVal = random.nextInt(6) + 3;
          final totalY = 2 * yVal;
          correctAnsNum = yVal;
          qText = 'Jika 2y = $totalY, berapakah nilai y?';
          explanationText = 'y = $totalY / 2 = $correctAnsNum.';
        } else if (versionType == 5) {
          levelTag = 'HOTS';
          final outsideCandies = 5;
          final totalAll = 18;
          correctAnsNum = totalAll - outsideCandies;
          qText = 'Ada x permen di dalam toples dan $outsideCandies permen di luar toples. Jika jumlah seluruh permen adalah $totalAll, berapa jumlah permen di dalam toples (x)?';
          explanationText = 'x + $outsideCandies = $totalAll ➔ x = $totalAll - $outsideCandies = $correctAnsNum.';
        } else if (versionType == 6) {
          correctAnsNum = 81;
          qText = 'Pola perkalian 3 (×3): 3, 9, 27, [ ? ]. Angka berikutnya adalah .....';
          explanationText = '27 × 3 = 81.';
        } else if (versionType == 7) {
          final nVal = 15;
          final minusV = 6;
          correctAnsNum = nVal;
          qText = 'Tentukan nilai n pada persamaan: n - $minusV = ${nVal - minusV} !';
          explanationText = 'n = ${nVal - minusV} + $minusV = $correctAnsNum.';
        } else if (versionType == 8) {
          correctAnsNum = 16;
          qText = 'Pola bertingkat: 1, 2, 4, 7, 11, [ ? ]. (+1, +2, +3, +4, +5). Angka berikutnya adalah .....';
          explanationText = '11 + 5 = 16.';
        } else {
          qText = 'Pada bentuk aljabar 4a + 5b, huruf a dan b dinamakan .....';
          explanationText = 'Huruf penyimbol nilai dalam aljabar dinamakan Variabel.';
          textOptions = ['Variabel', 'Koefisien', 'Konstanta', 'Suku'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // 19. RASIO, SKALA, DAN KOORDINAT DASAR
      // -----------------------------------------------------------------------
      else if (tLower.contains('rasio') || tLower.contains('skala') || tLower.contains('koordinat')) {
        levelTag = 'HOTS';
        if (versionType == 0) {
          final distMap = random.nextInt(4) + 2;
          final scale = 100000;
          correctAnsNum = (distMap * scale) ~/ 100000;
          qText = 'Sebuah peta memiliki skala 1 : 100.000. Jika jarak pada peta $distMap cm, berapakah jarak sebenarnya dalam km?';
          explanationText = 'Jarak sebenarnya = $distMap cm × 100.000 = ${distMap * 100000} cm = $correctAnsNum km.';
        } else if (versionType == 1) {
          final a = 2;
          final b = 3;
          final mul = random.nextInt(4) + 2;
          final realA = a * mul;
          correctAnsNum = b * mul;
          qText = 'Rasio kelereng $nameA : $nameB adalah 2 : 3. Jika $nameA memiliki $realA kelereng, berapa jumlah kelereng $nameB?';
          explanationText = 'Perbandingan 2 : 3. Kelereng $nameB = (3/2) × $realA = $correctAnsNum kelereng.';
        } else if (versionType == 2) {
          qText = 'Pada bidang koordinat Kartesius, titik P ditulis (4, 7). Angka 4 menunjukkan posisi pada sumbu .....';
          explanationText = 'Pada koordinat (x, y), angka pertama menunjukkan sumbu X (mendatar).';
          textOptions = ['Sumbu X (Mendatar)', 'Sumbu Y (Tegak)', 'Titik Pusat O', 'Sumbu Z'];
          textCorrectIndex = 0;
        } else if (versionType == 3) {
          final waterRatio = 4;
          final syrupRatio = 1;
          final waterMl = 800;
          correctAnsNum = waterMl ~/ waterRatio;
          qText = 'Untuk membuat jus buah, rasio air : sirup adalah $waterRatio : $syrupRatio. Jika $nameA menggunakan $waterMl mL air, berapa mL sirup yang dibutuhkan?';
          explanationText = 'Sirup = (1/4) × 800 = $correctAnsNum mL.';
        } else if (versionType == 4) {
          final scaleM = 200;
          final mapCm = 15;
          correctAnsNum = (mapCm * scaleM) ~/ 100;
          qText = 'Tinggi miniatur gedung sekolah pada maket ber skala 1 : 200 adalah $mapCm cm. Berapa tinggi gedung sebenarnya dalam meter?';
          explanationText = 'Tinggi sebenarnya = 15 cm × 200 = 3.000 cm = 30 meter.';
        } else if (versionType == 5) {
          qText = 'Titik pertemuan sumbu X dan sumbu Y pada koordinat Kartesius yaitu (0,0) dinamakan .....';
          explanationText = 'Titik (0,0) dinamakan Titik Pusat (Origin).';
          textOptions = ['Titik Pusat (Origin)', 'Titik Potong', 'Puncak', 'Kuadran'];
          textCorrectIndex = 0;
        } else if (versionType == 6) {
          final ratioB = 3;
          final ratioG = 4;
          final numBoys = 15;
          final totalKids = (numBoys ~/ ratioB) * (ratioB + ratioG);
          correctAnsNum = totalKids;
          qText = 'Perbandingan siswa laki-laki dan perempuan di kelas 5 adalah 3 : 4. Jika jumlah siswa laki-laki 15 orang, berapa jumlah seluruh siswa di kelas?';
          explanationText = 'Siswa laki-laki 3 bagian = 15 (1 bagian = 5). Total 7 bagian = 7 × 5 = $correctAnsNum orang.';
        } else if (versionType == 7) {
          final cmOnMap = 5;
          final realKm = 2.5;
          qText = 'Jarak dua kota pada peta ber skala 1 : 50.000 adalah $cmOnMap cm. Jarak sebenarnya dua kota tersebut adalah ..... km.';
          explanationText = 'Jarak sebenarnya = 5 cm × 50.000 = 250.000 cm = 2,5 km.';
          final opts = ['$realKm km', '5 km', '25 km', '0,25 km']..shuffle();
          textOptions = opts;
          textCorrectIndex = opts.indexOf('$realKm km');
        } else if (versionType == 8) {
          qText = 'Bentuk paling sederhana dari rasio 15 : 25 adalah .....';
          explanationText = '15 dan 25 dibagi 5 menjadi 3 : 5.';
          textOptions = ['3 : 5', '1 : 2', '2 : 3', '3 : 4'];
          textCorrectIndex = 0;
        } else {
          qText = 'Pada koordinat (3, -5), angka -5 menunjukkan kedudukan titik pada sumbu .....';
          explanationText = 'Angka kedua (-5) menunjukkan sumbu Y (tegak).';
          textOptions = ['Sumbu Y (Tegak)', 'Sumbu X (Mendatar)', 'Pusat O', 'Skala'];
          textCorrectIndex = 0;
        }
      }

      // -----------------------------------------------------------------------
      // DEFAULT / GENERAL MATH FALLBACK (Topic-aware safe handling)
      // -----------------------------------------------------------------------
      else {
        levelTag = 'Dasar';
        final a = random.nextInt(50) + 10;
        final b = random.nextInt(40) + 5;
        correctAnsNum = a + b;
        qText = 'Soal Latihan Matematika ($topic): Berapakah hasil dari $a + $b ?';
        explanationText = 'Penjumlahan: $a + $b = $correctAnsNum.';
      }

      // Deduplication check
      if (seenQuestionTexts.contains(qText)) {
        continue;
      }
      seenQuestionTexts.add(qText);

      // Handle text-based option questions
      if (textOptions != null && textCorrectIndex != null) {
        questions.add(
          Question(
            id: 'gen_math_${DateTime.now().millisecondsSinceEpoch}_${questions.length}',
            gradeLevel: gradeLevel,
            classNum: classNum,
            subject: 'Matematika',
            topic: topic,
            level: levelTag,
            questionText: qText,
            visualType: visualType,
            visualData: visualData,
            visualLabel: visualLabel,
            options: textOptions,
            correctAnswerIndex: textCorrectIndex,
            explanation: explanationText,
            isCustom: true,
          ),
        );
        continue;
      }

      // Handle numeric options
      if (correctAnsNum != null) {
        final optionsSet = <int>{correctAnsNum};
        int optAttempts = 0;
        while (optionsSet.length < 4 && optAttempts < 50) {
          optAttempts++;
          final offset = (random.nextInt(6) + 1) * (random.nextBool() ? 1 : -1);
          final distractor = correctAnsNum + offset;
          // Only enforce non-negative if correct answer is non-negative
          if (correctAnsNum >= 0 && distractor < 0) continue;
          if (distractor != correctAnsNum) {
            optionsSet.add(distractor);
          }
        }

        // Guaranteed deterministic safety fill if 4 unique options not yet reached
        int fallbackStep = 1;
        while (optionsSet.length < 4) {
          final d1 = correctAnsNum + fallbackStep;
          final d2 = correctAnsNum - fallbackStep;
          if (!optionsSet.contains(d1)) {
            optionsSet.add(d1);
          }
          if (optionsSet.length < 4 && !optionsSet.contains(d2) && (correctAnsNum < 0 || d2 >= 0)) {
            optionsSet.add(d2);
          }
          fallbackStep++;
        }

        final numOptions = optionsSet.toList()..shuffle();
        final correctIndex = numOptions.indexOf(correctAnsNum);

        questions.add(
          Question(
            id: 'gen_math_${DateTime.now().millisecondsSinceEpoch}_${questions.length}',
            gradeLevel: gradeLevel,
            classNum: classNum,
            subject: 'Matematika',
            topic: topic,
            level: levelTag,
            questionText: qText,
            visualType: visualType,
            visualData: visualData,
            visualLabel: visualLabel,
            options: numOptions.map((e) => e.toString()).toList(),
            correctAnswerIndex: correctIndex,
            explanation: explanationText,
            isCustom: true,
          ),
        );
      }
    }

    // -------------------------------------------------------------------------
    // TOPIC-AWARE DYNAMIC FALLBACK PADDING LOOP (Replaces geometry side loop)
    // -------------------------------------------------------------------------
    int fillIndex = 0;
    while (questions.length < count && fillIndex < 100) {
      fillIndex++;
      final fillName = _studentNames[fillIndex % _studentNames.length];
      final fillNumA = (fillIndex * 7) + random.nextInt(15) + 10;
      final fillNumB = (fillIndex * 5) + random.nextInt(10) + 5;
      final sumVal = fillNumA + fillNumB;

      String fillQ = '';
      String fillExp = '';
      List<String> fillOptions = [];
      int fillCorrectIdx = 0;

      if (tLower.contains('pecahan') || tLower.contains('desimal') || tLower.contains('persen')) {
        final den = (fillIndex % 5) + 2;
        fillQ = 'Soal Cerita $topic (#$fillIndex): $fillName memotong kue menjadi $den bagian sama besar. 1 bagian kue bernilai pecahan .....';
        fillExp = '1 bagian dari $den potong kue = 1/$den.';
        fillOptions = ['1/$den', '2/$den', '1/${den + 1}', '$den/1']..shuffle();
        fillCorrectIdx = fillOptions.indexOf('1/$den');
      } else if (tLower.contains('perkalian') || tLower.contains('pembagian') || tLower.contains('kabataku')) {
        final mulA = (fillIndex % 6) + 2;
        final mulB = random.nextInt(5) + 3;
        final prod = mulA * mulB;
        fillQ = 'Soal Cerita $topic (#$fillIndex): $fillName membeli $mulA kotak pensil di ${_storeNames[fillIndex % _storeNames.length]}. Jika tiap kotak berisi $mulB pensil, berapa total pensil?';
        fillExp = '$mulA × $mulB = $prod pensil.';
        fillOptions = [prod.toString(), (prod + 2).toString(), (prod - 1).toString(), (prod + 5).toString()]..shuffle();
        fillCorrectIdx = fillOptions.indexOf(prod.toString());
      } else if (tLower.contains('geometri') || tLower.contains('bentuk') || tLower.contains('sudut') || tLower.contains('bangun')) {
        final sideC = (fillIndex % 4) + 3;
        final sName = sideC == 3 ? 'Segitiga' : (sideC == 4 ? 'Persegi' : (sideC == 5 ? 'Pentagon' : 'Heksagon'));
        fillQ = 'Soal Latihan $topic (#$fillIndex): $fillName menggambar bangun datar $sName. Berapakah jumlah sisi pada bangun $sName tersebut?';
        fillExp = 'Bangun $sName memiliki $sideC sisi.';
        fillOptions = [sideC.toString(), (sideC + 1).toString(), (sideC + 2).toString(), (sideC - 1).toString()]..shuffle();
        fillCorrectIdx = fillOptions.indexOf(sideC.toString());
      } else if (tLower.contains('pengukuran') || tLower.contains('konversi') || tLower.contains('kecepatan')) {
        final kmVal = fillIndex + 1;
        final mAns = kmVal * 1000;
        fillQ = 'Soal Cerita $topic (#$fillIndex): $fillName bersepeda sejauh $kmVal kilometer (km). Jarak tersebut setara dengan ..... meter.';
        fillExp = '$kmVal km × 1.000 = $mAns meter.';
        fillOptions = [mAns.toString(), (mAns + 100).toString(), (mAns - 500).toString(), (mAns ~/ 10).toString()]..shuffle();
        fillCorrectIdx = fillOptions.indexOf(mAns.toString());
      } else {
        fillQ = 'Soal Cerita $topic (#$fillIndex): $fillName memiliki $fillNumA kelereng merah dan $fillNumB kelereng biru. Berapa jumlah seluruh kelereng $fillName?';
        fillExp = 'Total kelereng = $fillNumA + $fillNumB = $sumVal.';
        fillOptions = [sumVal.toString(), (sumVal + 2).toString(), (sumVal - 3).toString(), (sumVal + 10).toString()]..shuffle();
        fillCorrectIdx = fillOptions.indexOf(sumVal.toString());
      }

      if (!seenQuestionTexts.contains(fillQ)) {
        seenQuestionTexts.add(fillQ);
        questions.add(
          Question(
            id: 'gen_math_fill_${DateTime.now().millisecondsSinceEpoch}_$fillIndex',
            gradeLevel: gradeLevel,
            classNum: classNum,
            subject: 'Matematika',
            topic: topic,
            level: 'Sedang',
            questionText: fillQ,
            options: fillOptions,
            correctAnswerIndex: fillCorrectIdx,
            explanation: fillExp,
            isCustom: true,
          ),
        );
      }
    }

    return questions;
  }
}
