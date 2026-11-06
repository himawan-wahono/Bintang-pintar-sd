import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../providers/parent_provider.dart';
import '../utils/app_colors.dart';
import '../utils/csv_parser_service.dart';
import '../utils/word_parser_service.dart';

class ParentAddQuestionScreen extends StatefulWidget {
  final Question? existingQuestion;

  const ParentAddQuestionScreen({super.key, this.existingQuestion});

  @override
  State<ParentAddQuestionScreen> createState() => _ParentAddQuestionScreenState();
}

class _ParentAddQuestionScreenState extends State<ParentAddQuestionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Single Question Form State
  String _gradeLevel = 'SD';
  int _classNum = 1;
  String _subject = 'Matematika';
  String _topic = 'Pengenalan Bilangan dan Nilai Tempat';
  String _level = 'Dasar';
  final _questionController = TextEditingController();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _optionCController = TextEditingController();
  final _optionDController = TextEditingController();
  int _correctIndex = 0;
  final _explanationController = TextEditingController();

  final List<String> _mathTopics = [
    'Pengenalan Bilangan dan Nilai Tempat',
    'Penjumlahan & Pengurangan Dasar',
    'Perkalian & Pembagian',
    'Pecahan, Desimal, dan Persen',
    'Kelipatan dan Faktor (KPK & FPB)',
    'Bilangan Bulat Negatif',
    'Pengenalan Bentuk dan Sifat Dasar',
    'Pengukuran Sudut dan Simetri',
    'Keliling dan Luas Bangun Datar',
    'Bangun Ruang Lanjutan',
    'Pengukuran Dasar dan Satuan',
    'Hubungan Antarsatuan / Konversi',
    'Pengukuran Gabungan',
    'Pengumpulan dan Pengelompokan Dasar',
    'Penyajian Data Visual Dasar',
    'Pengolahan Data Lanjutan & Statistika Dasar',
    'Pengenalan Pola Gambar dan Bentuk',
    'Pola Bilangan',
    'Rasio, Skala, dan Koordinat Dasar',
  ];

  final List<String> _englishTopics = [
    'Phonics, Alphabet & Basic Vocabulary',
    'Greetings, Pronouns & Simple Sentences',
    'Simple Present Tense & Daily Routines',
    'Descriptive Text, Adjectives & Prepositions',
    'Simple Past Tense & Storytelling',
    'Future Tense, Modals & Expressing Intentions',
    'Degrees of Comparison & Procedure Text',
    'Present Perfect, Passive Voice & Analytical Text',
  ];

  // Bulk CSV Form State
  final _bulkTextController = TextEditingController();
  String _bulkStatusText = '';

  // Word Document Form State
  String _wordGradeLevel = 'SD';
  int _wordClassNum = 1;
  String _wordSubject = 'Matematika';
  final _wordTextController = TextEditingController();
  String _wordStatusText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.existingQuestion != null) {
      final q = widget.existingQuestion!;
      _gradeLevel = q.gradeLevel;
      _classNum = q.classNum;
      _subject = q.subject;
      _topic = _mathTopics.contains(q.topic) ? q.topic : _mathTopics.first;
      _level = q.level;
      _questionController.text = q.questionText;
      if (q.options.isNotEmpty) _optionAController.text = q.options[0];
      if (q.options.length > 1) _optionBController.text = q.options[1];
      if (q.options.length > 2) _optionCController.text = q.options[2];
      if (q.options.length > 3) _optionDController.text = q.options[3];
      _correctIndex = q.correctAnswerIndex;
      _explanationController.text = q.explanation;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.parentBg,
      appBar: AppBar(
        title: const Text('Tambah Soal PR Kustom ✍️'),
        backgroundColor: AppColors.parentNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.parentAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade400,
          tabs: const [
            Tab(icon: Icon(Icons.edit_note), text: 'Formulir 1 Soal'),
            Tab(icon: Icon(Icons.description), text: 'Impor Teks Word/PDF'),
            Tab(icon: Icon(Icons.table_chart), text: 'Impor Excel/CSV'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Single Question Input Form
          _buildSingleForm(parentProvider),

          // Tab 2: Word / PDF Smart Importer
          _buildWordImporter(parentProvider),

          // Tab 3: Bulk CSV/Excel Importer
          _buildBulkImporter(parentProvider),
        ],
      ),
    );
  }

  Widget _buildSingleForm(ParentProvider parentProvider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulir Tambah Soal Mandiri',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.parentText,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Soal yang Anda masukkan akan langsung muncul pada kuis anak di jenjang & kelas yang dipilih.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Row: Grade Level & Class Number Selection
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _gradeLevel,
                      decoration: _inputDecoration('Jenjang'),
                      items: ['SD'].map((g) {
                        return DropdownMenuItem(value: g, child: Text('SD (Kelas 1-6)'));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _gradeLevel = val;
                            _classNum = 1;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _classNum > 6 ? 1 : _classNum,
                      decoration: _inputDecoration('Kelas'),
                      items: [1, 2, 3, 4, 5, 6].map((c) {
                        return DropdownMenuItem(value: c, child: Text('Kelas $c'));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _classNum = val);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Subject Selection Dropdown
              DropdownButtonFormField<String>(
                initialValue: _subject,
                decoration: _inputDecoration('Mata Pelajaran'),
                items: ['Matematika', 'Bahasa Inggris'].map((s) {
                  return DropdownMenuItem(value: s, child: Text(s));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _subject = val;
                      _topic = val == 'Bahasa Inggris' ? _englishTopics.first : _mathTopics.first;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Sub-Topik Selection Dropdown
              DropdownButtonFormField<String>(
                initialValue: _topic,
                isExpanded: true,
                decoration: _inputDecoration('Sub-Topik Level Peta'),
                items: (_subject == 'Bahasa Inggris' ? _englishTopics : _mathTopics).map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _topic = val);
                },
              ),

              const SizedBox(height: 16),

              // Level Dropdown (Dasar, Sedang, HOTS)
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: _inputDecoration('Tingkat Kesulitan Level'),
                items: const [
                  DropdownMenuItem(value: 'Dasar', child: Text('🟢 Level: Dasar')),
                  DropdownMenuItem(value: 'Sedang', child: Text('🟡 Level: Sedang')),
                  DropdownMenuItem(value: 'HOTS', child: Text('🔴 Level: HOTS / Tantangan')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _level = val);
                },
              ),

              const SizedBox(height: 16),

              // Question Text Input
              TextFormField(
                controller: _questionController,
                maxLines: 3,
                decoration: _inputDecoration('Tulis Pertanyaan Soal...'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 20),
              const Text(
                'Opsi Pilihan Jawaban (A, B, C, D):',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.parentText),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _optionAController,
                decoration: _inputDecoration('Pilihan A'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _optionBController,
                decoration: _inputDecoration('Pilihan B'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _optionCController,
                decoration: _inputDecoration('Pilihan C'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _optionDController,
                decoration: _inputDecoration('Pilihan D'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 20),

              // Correct Answer Dropdown
              DropdownButtonFormField<int>(
                initialValue: _correctIndex,
                decoration: _inputDecoration('Kunci Jawaban Benar'),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Jawaban Benar: Pilihan A')),
                  DropdownMenuItem(value: 1, child: Text('Jawaban Benar: Pilihan B')),
                  DropdownMenuItem(value: 2, child: Text('Jawaban Benar: Pilihan C')),
                  DropdownMenuItem(value: 3, child: Text('Jawaban Benar: Pilihan D')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _correctIndex = val);
                },
              ),

              const SizedBox(height: 16),

              // Explanation Input
              TextFormField(
                controller: _explanationController,
                maxLines: 2,
                decoration: _inputDecoration('Pembahasan Singkat (Opsional)'),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.existingQuestion != null) {
                        final updatedQuestion = Question(
                          id: widget.existingQuestion!.id,
                          gradeLevel: _gradeLevel,
                          classNum: _classNum,
                          subject: _subject,
                          topic: _topic,
                          level: _level,
                          questionText: _questionController.text.trim(),
                          options: [
                            _optionAController.text.trim(),
                            _optionBController.text.trim(),
                            _optionCController.text.trim(),
                            _optionDController.text.trim(),
                          ],
                          correctAnswerIndex: _correctIndex,
                          explanation: _explanationController.text.trim(),
                          isCustom: true,
                        );

                        await parentProvider.updateCustomQuestion(updatedQuestion);

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Soal Kustom Berhasil Diperbarui! 🎉')),
                        );
                      } else {
                        final newQuestion = Question(
                          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                          gradeLevel: _gradeLevel,
                          classNum: _classNum,
                          subject: _subject,
                          topic: _topic,
                          level: _level,
                          questionText: _questionController.text.trim(),
                          options: [
                            _optionAController.text.trim(),
                            _optionBController.text.trim(),
                            _optionCController.text.trim(),
                            _optionDController.text.trim(),
                          ],
                          correctAnswerIndex: _correctIndex,
                          explanation: _explanationController.text.trim(),
                          isCustom: true,
                        );

                        await parentProvider.addCustomQuestion(newQuestion);

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Soal Kustom Berhasil Disimpan! 🎉')),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.parentAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    widget.existingQuestion != null ? 'Simpan Perubahan Soal 💾' : 'Simpan Soal Kustom 💾',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordImporter(ParentProvider parentProvider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impor Langsung dari Dokumen Word / PDF 📄',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.parentText,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Salin (Copy) teks dari file Microsoft Word / PDF dan tempelkan di bawah ini. Aplikasi akan mendeteksi soal & pilihan jawaban (a, b, c, d) secara otomatis!',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Select Target Grade, Class, and Subject for Word Import
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _wordGradeLevel,
                    decoration: _inputDecoration('Jenjang'),
                    items: ['SD'].map((g) {
                      return DropdownMenuItem(value: g, child: Text('SD (Kelas 1-6)'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _wordGradeLevel = val;
                          _wordClassNum = 1;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _wordClassNum > 6 ? 1 : _wordClassNum,
                    decoration: _inputDecoration('Kelas'),
                    items: [1, 2, 3, 4, 5, 6].map((c) {
                      return DropdownMenuItem(value: c, child: Text('Kelas $c'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _wordClassNum = val);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: _wordSubject,
              decoration: _inputDecoration('Mata Pelajaran Target'),
              items: ['Matematika', 'Bahasa Inggris'].map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _wordSubject = val);
              },
            ),

            const SizedBox(height: 18),

            // Word Sample Format Banner Button
            ElevatedButton.icon(
              onPressed: () {
                const sampleWord =
                    "1. Hasil dari 85 + 34 - 27 adalah .....\n"
                    "   • a. 82\n"
                    "   • b. 92\n"
                    "   • c. 119\n"
                    "   • d. 146\n\n"
                    "2. 425 - 210 + [ ? ] = 300. Berapakah nilai yang tepat untuk mengisi kotak tersebut .....\n"
                    "   • a. 75\n"
                    "   • b. 85\n"
                    "   • c. 95\n"
                    "   • d. 105\n\n"
                    "3. Sinta mempunyai 30 permen cokelat dan 15 permen stroberi. Jika 6 permen cokelat dan 9 permen stroberi dimakan adik, maka jumlah permen Sinta tersisa adalah ....\n"
                    "   • a. 45\n"
                    "   • b. 39\n"
                    "   • c. 30\n"
                    "   • d. 25";
                _wordTextController.text = sampleWord;
                final parsed = WordParserService.parseWordText(
                  sampleWord,
                  defaultGradeLevel: _wordGradeLevel,
                  defaultClassNum: _wordClassNum,
                  defaultSubject: _wordSubject,
                );
                setState(() {
                  _wordStatusText = 'Terdeteksi ${parsed.length} soal valid dari dokumen Word.';
                });
              },
              icon: const Icon(Icons.lightbulb_outline, size: 18, color: Colors.white),
              label: const Text('Coba Contoh Format Word Teks', style: TextStyle(color: Colors.white, fontSize: 13)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.parentAccent),
            ),

            const SizedBox(height: 12),

            // Word Paste Text Area
            TextField(
              controller: _wordTextController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Tempelkan (Paste) seluruh teks dari file Word / PDF di sini...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (val) {
                final parsed = WordParserService.parseWordText(
                  val,
                  defaultGradeLevel: _wordGradeLevel,
                  defaultClassNum: _wordClassNum,
                  defaultSubject: _wordSubject,
                );
                setState(() {
                  _wordStatusText = 'Terdeteksi ${parsed.length} soal valid siap diimpor dari Word!';
                });
              },
            ),

            if (_wordStatusText.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                _wordStatusText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successGreen,
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final text = _wordTextController.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Silakan tempelkan teks dari Word / PDF terlebih dahulu!')),
                    );
                    return;
                  }

                  final parsed = WordParserService.parseWordText(
                    text,
                    defaultGradeLevel: _wordGradeLevel,
                    defaultClassNum: _wordClassNum,
                    defaultSubject: _wordSubject,
                  );

                  if (parsed.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tidak ada soal bernomor (1., 2.) yang terdeteksi. Periksa format teks Word Anda.')),
                    );
                    return;
                  }

                  for (var q in parsed) {
                    await parentProvider.addCustomQuestion(q);
                  }

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Berhasil Mengimpor ${parsed.length} Soal dari Word/PDF! 🎉')),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text(
                  'Impor Semua Soal dari Word 🚀',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.parentAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkImporter(ParentProvider parentProvider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impor Soal Banyak dari Excel / CSV 📊',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.parentText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Salin (Copy) tabel dari Excel atau masukkan teks berformat CSV (pisahkan dengan koma atau TAB).',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Format Header Template Guide
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.parentAccent.withValues(alpha: 0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.table_chart_outlined, color: AppColors.parentAccent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Format Tabel Excel (11 Kolom):',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.parentText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ketik tabel di Excel / Google Sheets dengan urutan kolom sebagai berikut:\n'
                    '• A: Jenjang (SD / SMP)\n'
                    '• B: Kelas (1 - 9)\n'
                    '• C: Mata Pelajaran (Matematika, IPA, dll)\n'
                    '• D: Topik (misal: Pecahan / Aljabar)\n'
                    '• E: Pertanyaan Soal\n'
                    '• F: Pilihan A\n'
                    '• G: Pilihan B\n'
                    '• H: Pilihan C\n'
                    '• I: Pilihan D\n'
                    '• J: Kunci Jawaban (A, B, C, atau D)\n'
                    '• K: Pembahasan Singkat',
                    style: TextStyle(fontSize: 12, color: AppColors.parentText, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        const sampleExcelData =
                            "Jenjang\tKelas\tMata Pelajaran\tTopik\tPertanyaan\tPilihan A\tPilihan B\tPilihan C\tPilihan D\tKunci Jawaban\tPembahasan\n"
                            "SD\t4\tMatematika\tPecahan\tBerapakah 1/4 + 2/4?\t1/4\t2/4\t3/4\t4/4\tC\t1+2=3 jadi hasilnya 3/4.\n"
                            "SD\t4\tIPA\tTata Surya\tPlanet terbesar di tata surya adalah...\tMars\tBumi\tSaturnus\tJupiter\tD\tJupiter adalah planet terbesar.\n"
                            "SMP\t7\tMatematika\tAljabar\tNilai x jika 2x = 8 adalah...\tx=2\tx=4\tx=6\tx=8\tB\tx = 8/2 = 4.\n"
                            "SMP\t8\tBahasa Inggris\tGrammar\tChoose the correct form: She ___ to school.\tgo\tgoes\twent\tgone\tB\tSubject She + verb+s (goes).";
                        Clipboard.setData(const ClipboardData(text: sampleExcelData));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Template Format Excel Berhasil Disalin! Langsung Paste di Excel / Google Sheets 📋'),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, size: 18, color: Colors.white),
                      label: const Text(
                        '📥 Unduh / Salin Template Format Excel',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.parentAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Text Input for CSV Copy-Paste
            TextField(
              controller: _bulkTextController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Tempelkan (Paste) data dari Excel / CSV di sini...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (val) {
                final questions = CsvParserService.parseCsvText(val);
                setState(() {
                  _bulkStatusText = 'Terdeteksi ${questions.length} soal valid siap diimpor.';
                });
              },
            ),

            if (_bulkStatusText.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                _bulkStatusText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successGreen,
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final text = _bulkTextController.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Silakan tempelkan teks CSV / tabel Excel terlebih dahulu!')),
                    );
                    return;
                  }

                  final parsedQuestions = CsvParserService.parseCsvText(text);

                  if (parsedQuestions.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Format tidak dikenali. Pastikan kolom sesuai petunjuk!')),
                    );
                    return;
                  }

                  for (var q in parsedQuestions) {
                    await parentProvider.addCustomQuestion(q);
                  }

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Berhasil Mengimpor ${parsedQuestions.length} Soal Sekaligus! 🎉')),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text(
                  'Impor Semua Soal 🚀',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.parentAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
