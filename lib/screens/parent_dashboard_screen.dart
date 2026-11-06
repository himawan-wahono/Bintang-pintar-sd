import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/parent_reward_model.dart';
import '../providers/parent_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/stat_card.dart';
import '../utils/app_colors.dart';
import '../services/connectivity_service.dart';
import '../services/pdf_report_service.dart';
import '../widgets/donation_dialog.dart';
import 'parent_custom_questions_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context);
    final statsProvider = Provider.of<StatsProvider>(context);
    final stats = statsProvider.stats;
    final accuracy = stats.accuracyRate;
    final recommendations = parentProvider.getWeaknessRecommendations(accuracy);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ConnectivityService().refreshQuestionCount();
    });

    return Scaffold(
      backgroundColor: AppColors.parentBg,
      appBar: AppBar(
        title: const Text(
          'Dashboard Orang Tua 📊',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.parentNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Dukung Aplikasi ☕',
            icon: const Icon(Icons.favorite_rounded, color: Colors.amberAccent),
            onPressed: () => DonationDialog.show(context),
          ),
          IconButton(
            tooltip: 'Ganti PIN Orang Tua',
            icon: const Icon(Icons.lock_reset),
            onPressed: () => _showChangePinDialog(context, parentProvider),
          ),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () {
              parentProvider.logoutParent();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.parentNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporan Perkembangan Belajar Anak 👨‍👩‍👧‍👦',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pantau akurasi, topik yang dikuasai, dan kelola reward untuk memotivasi anak.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // PDF Raport Export Card
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  PdfReportService.showDownloadOptionsModal(
                    context: context,
                    profile: statsProvider.activeProfile,
                    stats: stats,
                    recommendations: recommendations,
                    rewards: parentProvider.rewards,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.parentAccent.withAlpha(60),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.parentAccent.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '📄',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cetak Raport Belajar PDF',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.parentText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Unduh ringkasan hasil belajar anak dalam format PDF',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.parentAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.download, size: 16, color: Colors.white),
                        onPressed: () {
                          PdfReportService.showDownloadOptionsModal(
                            context: context,
                            profile: statsProvider.activeProfile,
                            stats: stats,
                            recommendations: recommendations,
                            rewards: parentProvider.rewards,
                          );
                        },
                        label: const Text(
                          'Unduh PDF',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Kartu Dukungan Donasi Sukarela (Saweria / QRIS)
              const DonationSupportCard(),

              const SizedBox(height: 24),

              // Metrics Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Akurasi Jawaban',
                      value: '${accuracy.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      color: AppColors.parentAccent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: StatCard(
                      title: 'Kuis Selesai',
                      value: '${stats.quizzesCompleted}',
                      icon: Icons.assignment_turned_in,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Bintang ⭐',
                      value: '${stats.totalStars}',
                      icon: Icons.star,
                      color: AppColors.accentYellow,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: StatCard(
                      title: 'Total XP Belajar',
                      value: '${stats.totalXp}',
                      icon: Icons.bolt,
                      color: AppColors.secondaryCoral,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bank Soal Progress & Completion Card for Parents
              ListenableBuilder(
                listenable: ConnectivityService(),
                builder: (context, _) {
                  final totalQuestions = ConnectivityService().totalQuestionsCount;
                  final totalQuestionsFormatted = ConnectivityService().totalQuestionsFormattedText;
                  final isDownloaded = totalQuestions > 0;
                  final remainingQuestions = isDownloaded
                      ? (totalQuestions - stats.totalQuestionsAnswered).clamp(0, 99999)
                      : 0;
                  final progressValue = isDownloaded
                      ? (stats.totalQuestionsAnswered / totalQuestions).clamp(0.0, 1.0)
                      : 0.0;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.parentAccent.withAlpha(40), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress Bank Soal Aplikasi 📚',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.parentText,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.parentAccent.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isDownloaded
                                    ? '$totalQuestionsFormatted di HP • ${ConnectivityService().newQuestionsFormattedText} di Server'
                                    : '0 di HP • ${ConnectivityService().newQuestionsFormattedText} di Server',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.parentAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.parentAccent),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 3 Metric Counters: Total di HP, Dikerjakan, Belum Dikerjakan
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '📚 Total di HP',
                                      style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      totalQuestionsFormatted,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '✅ Dikerjakan',
                                      style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${stats.totalQuestionsAnswered}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '⏳ Belum Dikerjakan',
                                      style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$remainingQuestions',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (!isDownloaded) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.amber.shade800),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Belum ada soal terunduh di memori HP. Buka beranda utama saat online untuk mengunduh soal otomatis.',
                                    style: TextStyle(fontSize: 11, color: Colors.amber.shade900),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // Weak-point & Recommendation Card
              const Text(
                'Analisis & Rekomendasi Belajar 🧠',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.parentText,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recommendations.map((rec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppColors.parentAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              rec,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.parentText,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // Timer Duration Per Question Setting Card
              const Text(
                'Pengaturan Durasi Timer Per Soal ⏱️',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.parentText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Atur batas waktu pengerjaan per soal untuk melatih kecepatan anak atau matikan timer agar anak belajar santai.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.parentAccent.withValues(alpha: 0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: AppColors.parentAccent, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Pilih Batas Waktu (${parentProvider.questionTimerSeconds == 0 ? 'Tanpa Timer' : '${parentProvider.questionTimerSeconds} Detik'}):',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.parentText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildTimerOptionChip(context, parentProvider, label: 'Tidak Pakai 🚫', seconds: 0),
                        const SizedBox(width: 6),
                        _buildTimerOptionChip(context, parentProvider, label: '30s ⚡', seconds: 30),
                        const SizedBox(width: 6),
                        _buildTimerOptionChip(context, parentProvider, label: '45s ⏳', seconds: 45),
                        const SizedBox(width: 6),
                        _buildTimerOptionChip(context, parentProvider, label: '60s 🕒', seconds: 60),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Quick Card Link to Parent Custom Questions Screen
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.parentAccent.withAlpha(50), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.parentAccent.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.parentAccent.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Soal Buatan Orang Tua',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.parentText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${parentProvider.customQuestions.length} Soal Tersimpan • Kelola & Mainkan',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.parentAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                      label: const Text('Buka', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ParentCustomQuestionsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Custom Parent Reward Manager Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(
                      'Sistem Hadiah Anak 🎁',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.parentText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showRewardDialog(context, parentProvider),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text('Tambah Hadiah', style: TextStyle(color: Colors.white, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.parentAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (parentProvider.rewards.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: const Text(
                    'Belum ada hadiah. Klik "+ Tambah Hadiah" untuk membuat kesepakatan hadiah dengan anak!',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: parentProvider.rewards.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final reward = parentProvider.rewards[index];
                    final isUnlocked = stats.totalStars >= reward.targetStars;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: reward.isClaimed ? AppColors.successGreen : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reward.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.parentText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Target: ${reward.targetStars} Bintang ⭐ (Saat ini: ${stats.totalStars})',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isUnlocked ? AppColors.parentAccent : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Edit Button
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.parentAccent, size: 20),
                                onPressed: () => _showRewardDialog(
                                  context,
                                  parentProvider,
                                  existingReward: reward,
                                ),
                              ),
                              // Delete Button
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.secondaryCoral, size: 20),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hapus Hadiah?'),
                                      content: Text('Apakah Anda yakin ingin menghapus "${reward.title}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.secondaryCoral,
                                          ),
                                          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await parentProvider.deleteReward(reward.id);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isUnlocked
                                  ? () => parentProvider.toggleRewardClaim(reward.id)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: reward.isClaimed ? AppColors.successGreen : AppColors.parentAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                reward.isClaimed ? 'Diklaim ✓ (Klik untuk Reset)' : (isUnlocked ? 'Klaim Hadiah ✨' : 'Belum Cukup Bintang'),
                                style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
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
      ),
    );
  }

  void _showRewardDialog(BuildContext context, ParentProvider parentProvider, {ParentReward? existingReward}) {
    final titleController = TextEditingController(text: existingReward?.title ?? '');
    final starsController = TextEditingController(text: existingReward != null ? '${existingReward.targetStars}' : '10');
    final isEditing = existingReward != null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Hadiah 🎁' : 'Tambah Hadiah Baru 🎁'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Nama / Bentuk Hadiah',
                  hintText: 'Misal: Main Game 30 Menit / Beli Es Krim',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: starsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Jumlah Bintang ⭐',
                  hintText: 'Misal: 15',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final stars = int.tryParse(starsController.text.trim()) ?? 10;
                if (title.isNotEmpty) {
                  if (isEditing) {
                    await parentProvider.updateReward(existingReward.id, title, stars);
                  } else {
                    await parentProvider.addReward(title, stars);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.parentAccent,
              ),
              child: Text(isEditing ? 'Simpan' : 'Tambah', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimerOptionChip(
    BuildContext context,
    ParentProvider parentProvider, {
    required String label,
    required int seconds,
  }) {
    final isSelected = parentProvider.questionTimerSeconds == seconds;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          parentProvider.updateTimerSeconds(seconds);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                seconds == 0
                    ? 'Timer dimatikan. Anak dapat mengerjakan kuis tanpa batas waktu!'
                    : 'Durasi timer diatur menjadi $seconds detik per soal.',
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.parentAccent,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.parentAccent : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.parentAccent : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.parentText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePinDialog(BuildContext context, ParentProvider parentProvider) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti PIN Orang Tua 🔒'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'PIN Lama (Default: 1234)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val != parentProvider.pin) {
                    return 'PIN Lama salah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'PIN Baru (4-Digit Angka)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.length != 4 || int.tryParse(val) == null) {
                    return 'Harus 4 digit angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi PIN Baru',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val != newPinController.text) {
                    return 'Konfirmasi PIN tidak cocok';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await parentProvider.updatePin(newPinController.text.trim());
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN Orang Tua Berhasil Diubah! 🔒')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.parentNavy),
            child: const Text('Simpan PIN Baru', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
