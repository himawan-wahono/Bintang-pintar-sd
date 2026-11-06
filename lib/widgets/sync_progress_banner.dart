import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/cloud_sync_service.dart';
import '../services/connectivity_service.dart';
import 'donation_dialog.dart';

class SyncProgressBanner extends StatelessWidget {
  const SyncProgressBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = ConnectivityService();

    return ValueListenableBuilder<SyncProgressInfo>(
      valueListenable: CloudSyncService.syncProgress,
      builder: (context, info, child) {
        // 1. STATE SYNCING (Animasi Progress Pengunduhan Soal)
        if (info.state == SyncProgressState.syncing) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF818CF8), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withAlpha(25),
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
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4361EE)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Mengunduh Soal dari Database...',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                    ),
                    if (info.progress != null)
                      Text(
                        '${(info.progress! * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4361EE),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  info.message.isNotEmpty
                      ? info.message
                      : 'Menyimpan soal ke memori HP...',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: info.progress,
                    minHeight: 6,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4361EE)),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 250.ms);
        }

        // 2. STATE SUCCESS (Sinkronisasi Selesai)
        if (info.state == SyncProgressState.success) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF6EE7B7)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pembaruan Selesai!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                        ),
                      ),
                      Text(
                        info.message,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF047857)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF065F46)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    CloudSyncService.syncProgress.value =
                        const SyncProgressInfo(state: SyncProgressState.idle);
                  },
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms);
        }

        // 3. STATE ERROR
        if (info.state == SyncProgressState.error) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Unduh Soal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info.message,
                        style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () {
                          DonationDialog.show(context);
                          CloudSyncService.syncBulkQuestionsFromCloud(targetCount: 10000);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh_rounded, size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Coba Lagi',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF92400E)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    CloudSyncService.syncProgress.value =
                        const SyncProgressInfo(state: SyncProgressState.idle);
                  },
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms);
        }

        // 4. STATE IDLE: KARTU TERPADU PROFESSIONAL (All-in-One Status Bar)
        return ListenableBuilder(
          listenable: connectivity,
          builder: (context, _) {
            final formattedCount = connectivity.totalQuestionsFormattedText;
            final serverCountFormatted = connectivity.newQuestionsFormattedText;
            final syncText = connectivity.lastSyncFormattedText;
            final hasNew = connectivity.hasNewQuestions;
            final newCountStr = connectivity.newQuestionsFormattedText;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: hasNew ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (hasNew ? Colors.green : Colors.blueGrey).withAlpha(12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon Lingkaran Edukatif
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: hasNew ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        hasNew ? Icons.cloud_download_rounded : Icons.cloud_done_rounded,
                        color: hasNew ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Informasi Bank Soal di HP & Server Cloud Aktual
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank Soal: $formattedCount di HP • $serverCountFormatted di Server',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: hasNew
                                    ? const Color(0xFF16A34A)
                                    : (connectivity.isOnline ? const Color(0xFF3B82F6) : Colors.grey),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                hasNew
                                    ? 'Tersedia $newCountStr soal baru di server 🚀'
                                    : '${connectivity.isOnline ? "Online" : "Offline"} • Diperbarui $syncText',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: hasNew ? FontWeight.bold : FontWeight.w500,
                                  color: hasNew ? const Color(0xFF15803D) : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Tombol Unduh Soal Seperti Semula
                  InkWell(
                    onTap: () async {
                      // Tampilkan modal card donasi saat pengguna mengunduh soal dari server
                      DonationDialog.show(context);
                      await CloudSyncService.syncBulkQuestionsFromCloud(targetCount: 10000);
                      await connectivity.refreshQuestionCount();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: hasNew ? const Color(0xFF16A34A) : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasNew ? const Color(0xFF16A34A) : const Color(0xFF818CF8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 14,
                            color: hasNew ? Colors.white : const Color(0xFF4361EE),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Unduh Soal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: hasNew ? Colors.white : const Color(0xFF4361EE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
