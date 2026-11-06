import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../services/cloud_sync_service.dart';
import 'donation_dialog.dart';

class ConnectivityStatusWidget extends StatelessWidget {
  final bool compact;
  const ConnectivityStatusWidget({super.key, this.compact = false});

  void _handleSync(BuildContext context, ConnectivityService connectivity) async {
    if (CloudSyncService.isSyncing) return;

    if (!connectivity.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Perangkat offline. Hubungkan ke internet untuk sync soal baru.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    DonationDialog.show(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Memeriksa & menyinkronkan database soal dari Cloud...'),
        duration: Duration(seconds: 2),
      ),
    );

    await CloudSyncService.syncBulkQuestionsFromCloud(targetCount: 10000);
    await connectivity.refreshQuestionCount();

    if (context.mounted) {
      if (connectivity.newQuestionsAvailable == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Bank soal up-to-date! (${connectivity.totalQuestionsFormattedText} soal di memori HP)',
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = ConnectivityService();

    return ValueListenableBuilder<SyncProgressInfo>(
      valueListenable: CloudSyncService.syncProgress,
      builder: (context, syncInfo, _) {
        return ListenableBuilder(
          listenable: connectivity,
          builder: (context, child) {
            final syncText = connectivity.lastSyncFormattedText;
            final isSyncing = syncInfo.state == SyncProgressState.syncing || CloudSyncService.isSyncing;
            final hasNew = connectivity.hasNewQuestions;
            final newCountStr = connectivity.newQuestionsFormattedText;

            if (compact) {
              return InkWell(
                onTap: isSyncing ? null : () => _handleSync(context, connectivity),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: hasNew ? const Color(0xFFF0FDF4) : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasNew ? const Color(0xFF86EFAC) : Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSyncing)
                        const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        )
                      else
                        Text(hasNew ? '✨ ' : '🔄 ', style: const TextStyle(fontSize: 10)),
                      Text(
                        isSyncing
                            ? 'Sync...'
                            : hasNew
                                ? '$newCountStr Soal baru'
                                : 'Database terupdate',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: hasNew ? Colors.green.shade900 : Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isSyncing ? null : () => _handleSync(context, connectivity),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: hasNew ? const Color(0xFFF0FDF4) : const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: hasNew ? const Color(0xFF86EFAC) : const Color(0xFFC7D7FE),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (hasNew ? Colors.green : Colors.blue).withAlpha(15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSyncing) ...[
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1E3A8A)),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Menyinkronkan database soal...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ] else if (hasNew) ...[
                        const Text('✨', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          'Database Soal: $syncText • $newCountStr Baru',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download_rounded, size: 12, color: Colors.white),
                              SizedBox(width: 3),
                              Text(
                                'Unduh',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Text('🔄', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          'Database Soal: $syncText • Terupdate',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sync, size: 11, color: Colors.blue.shade900),
                              const SizedBox(width: 2),
                              Text(
                                'Sync',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
