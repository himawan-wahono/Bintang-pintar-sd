import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/question_model.dart';
import '../providers/parent_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/question_visual_widget.dart';
import 'quiz_screen.dart';

class ParentCustomQuestionsScreen extends StatefulWidget {
  const ParentCustomQuestionsScreen({super.key});

  @override
  State<ParentCustomQuestionsScreen> createState() => _ParentCustomQuestionsScreenState();
}

class _ParentCustomQuestionsScreenState extends State<ParentCustomQuestionsScreen> {
  String _selectedSubjectFilter = 'Semua';

  void _confirmDeleteQuestion(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Hapus Soal?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus soal "${question.questionText}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Provider.of<ParentProvider>(context, listen: false).deleteCustomQuestion(question.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Soal berhasil dihapus!'), backgroundColor: Colors.redAccent),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddEditQuestionDialog(BuildContext context, {Question? existingQuestion}) {
    final parentProvider = Provider.of<ParentProvider>(context, listen: false);

    final formKey = GlobalKey<FormState>();
    String subject = existingQuestion?.subject ?? 'Matematika';
    String gradeLevel = existingQuestion?.gradeLevel ?? 'SD';
    int classNum = existingQuestion?.classNum ?? 4;
    String topic = existingQuestion?.topic ?? 'Umum';
    String level = existingQuestion?.level ?? 'Sedang';
    String questionText = existingQuestion?.questionText ?? '';
    List<String> options = existingQuestion != null ? List.from(existingQuestion.options) : ['', '', '', ''];
    int correctAnswerIndex = existingQuestion?.correctAnswerIndex ?? 0;
    String explanation = existingQuestion?.explanation ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        existingQuestion == null ? '➕ Tambah Soal Baru Orang Tua' : '✏️ Edit Soal Orang Tua',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 16),

                      // Subject & Class Selector
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: subject,
                              decoration: InputDecoration(
                                labelText: 'Mata Pelajaran',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: ['Matematika', 'Bahasa Inggris']
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => subject = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: classNum,
                              decoration: InputDecoration(
                                labelText: 'Kelas SD',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: [1, 2, 3, 4, 5, 6]
                                  .map((c) => DropdownMenuItem(value: c, child: Text('Kelas $c SD')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => classNum = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Topic Input
                      TextFormField(
                        initialValue: topic,
                        decoration: InputDecoration(
                          labelText: 'Topik Pembelajaran',
                          hintText: 'Misal: Pecahan, Phonics, KABATAKU',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onSaved: (val) => topic = val?.trim() ?? 'Umum',
                      ),
                      const SizedBox(height: 12),

                      // Question Text Input
                      TextFormField(
                        initialValue: questionText,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Teks Pertanyaan Soal',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Teks soal wajib diisi' : null,
                        onSaved: (val) => questionText = val!.trim(),
                      ),
                      const SizedBox(height: 12),

                      const Text('Pilihan Jawaban (Klik lingkaran hijau untuk menandai jawaban benar):',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),

                      // Options A, B, C, D
                      ...List.generate(4, (index) {
                        final isCorrect = correctAnswerIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setModalState(() => correctAnswerIndex = index),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isCorrect ? Colors.green : Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isCorrect ? Icons.check : Icons.circle_outlined,
                                      size: 18,
                                      color: isCorrect ? Colors.white : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: options[index],
                                  decoration: InputDecoration(
                                    labelText: 'Pilihan ${String.fromCharCode(65 + index)}',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Pilihan diisi' : null,
                                  onSaved: (val) => options[index] = val!.trim(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),

                      // Explanation Input
                      TextFormField(
                        initialValue: explanation,
                        decoration: InputDecoration(
                          labelText: 'Pembahasan / Penjelasan Jawaban',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onSaved: (val) => explanation = val?.trim() ?? '',
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryCyan,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              final q = Question(
                                id: existingQuestion?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                gradeLevel: gradeLevel,
                                classNum: classNum,
                                subject: subject,
                                topic: topic,
                                level: level,
                                questionText: questionText,
                                options: options,
                                correctAnswerIndex: correctAnswerIndex,
                                explanation: explanation.isNotEmpty ? explanation : 'Jawaban benar adalah ${options[correctAnswerIndex]}.',
                                isCustom: true,
                              );

                              if (existingQuestion == null) {
                                parentProvider.addCustomQuestion(q);
                              } else {
                                parentProvider.updateCustomQuestion(q);
                              }

                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(existingQuestion == null ? '✨ Soal baru berhasil disimpan!' : '✏️ Soal berhasil diperbarui!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: Text(
                            existingQuestion == null ? 'Simpan Soal Baru 💾' : 'Simpan Perubahan ✏️',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _startParentQuestionsQuiz(BuildContext context, List<Question> customQuestions) {
    if (customQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Belum ada soal buatan orang tua. Tekan tombol "+" untuk membuat soal!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final parentProvider = Provider.of<ParentProvider>(context, listen: false);

    quizProvider.startQuiz(
      customQuestions,
      timerSeconds: parentProvider.questionTimerSeconds,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(
          subjectName: 'Kuis Soal Orang Tua 👨‍👩‍👧‍👦',
          gradeLevel: 'SD',
          classNum: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context);
    final allCustomQuestions = parentProvider.customQuestions;

    final filteredQuestions = allCustomQuestions.where((q) {
      if (_selectedSubjectFilter == 'Semua') return true;
      return q.subject == _selectedSubjectFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('👨‍👩‍👧‍👦 ', style: TextStyle(fontSize: 20)),
            Text(
              'Soal Buatan Orang Tua',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryCyan, size: 26),
            tooltip: 'Tambah Soal Baru',
            onPressed: () => _showAddEditQuestionDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Banner & Summary Stats
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FACFE).withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Total ${allCustomQuestions.length} Soal Tersimpan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Koleksi Soal Spesial Ayah & Bunda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Soal yang Anda buat di sini akan otomatis muncul di sesi kuis anak!',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryCyan,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('Mainkan Kuis 🎯', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () => _startParentQuestionsQuiz(context, filteredQuestions),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.05, end: 0),

            // Subject Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['Semua', 'Matematika', 'Bahasa Inggris'].map((subj) {
                  final isSelected = _selectedSubjectFilter == subj;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(subj),
                      selected: isSelected,
                      selectedColor: AppColors.primaryCyan,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedSubjectFilter = subj;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Question List
            Expanded(
              child: filteredQuestions.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: filteredQuestions.length,
                      itemBuilder: (context, index) {
                        final q = filteredQuestions[index];
                        return _buildQuestionCard(context, q, index);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryCyan,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Buat Soal Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAddEditQuestionDialog(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📝', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Soal Orang Tua',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          Text(
            'Tekan tombol "+ Buat Soal Baru" di bawah untuk menambah soal latihan sendiri!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('Tambah Soal Pertama ➕', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () => _showAddEditQuestionDialog(context),
          ),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildQuestionCard(BuildContext context, Question q, int index) {
    final isMath = q.subject == 'Matematika';
    final themeColor = isMath ? const Color(0xFF3A86FF) : const Color(0xFF4361EE);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: themeColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${isMath ? "📐" : "🔤"} ${q.subject}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: themeColor),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Kelas ${q.classNum} SD • ${q.topic}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple.shade700),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                  onPressed: () => _showAddEditQuestionDialog(context, existingQuestion: q),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                  onPressed: () => _confirmDeleteQuestion(context, q),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Question Text
            Text(
              q.questionText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            // Visual Widget Preview if any
            if (q.visualType != null) ...[
              Center(
                child: SizedBox(
                  height: 120,
                  child: QuestionVisualWidget(question: q),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Options list
            Column(
              children: List.generate(q.options.length, (optIdx) {
                final isCorrect = optIdx == q.correctAnswerIndex;
                final optLetter = String.fromCharCode(65 + optIdx);
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.shade50 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCorrect ? Colors.green.shade400 : Colors.grey.shade200,
                      width: isCorrect ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$optLetter. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green.shade800 : Colors.grey.shade700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          q.options[optIdx],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                            color: isCorrect ? Colors.green.shade900 : AppColors.textDark,
                          ),
                        ),
                      ),
                      if (isCorrect) const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Explanation
            if (q.explanation.isNotEmpty)
              Text(
                '💡 Pembahasan: ${q.explanation}',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideY(begin: 0.05, end: 0);
  }
}
