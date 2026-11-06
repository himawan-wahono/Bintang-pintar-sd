import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/user_provider.dart';
import '../screens/register_screen.dart';
import '../screens/login_screen.dart';

class PremiumLockDialog extends StatelessWidget {
  final String title;
  final String description;

  const PremiumLockDialog({
    super.key,
    this.title = 'Fitur Khusus Premium 🔒',
    this.description = 'Topik kuis ini khusus untuk pengguna Bintang Pintar Premium 🌟. Dapatkan akses ke seluruh 19 Planet Matematika, 8 Negara Bahasa Inggris, Soal HOTS, dan Cetak Raport PDF!',
  });

  static void show(
    BuildContext context, {
    String? title,
    String? description,
  }) {
    showDialog(
      context: context,
      builder: (context) => PremiumLockDialog(
        title: title ?? 'Fitur Khusus Premium 🔒',
        description: description ?? 'Topik kuis ini khusus untuk pengguna Bintang Pintar Premium 🌟. Dapatkan akses ke seluruh 19 Planet Matematika, 8 Negara Bahasa Inggris, Soal HOTS, dan Cetak Raport PDF!',
      ),
    );
  }

  void _showPaymentModal(BuildContext context, UserProvider userProvider) {
    String selectedPlan = 'monthly';
    String selectedPaymentMethod = 'qris';

    final plans = [
      {
        'id': 'daily',
        'title': 'Paket Harian ☀️',
        'price': 'Rp 2.000',
        'subtitle': 'Akses 1 Hari Full',
        'durationDays': 1,
      },
      {
        'id': 'weekly',
        'title': 'Paket Mingguan 📅',
        'price': 'Rp 10.000',
        'subtitle': 'Akses 7 Hari Full',
        'durationDays': 7,
      },
      {
        'id': 'monthly',
        'title': 'Paket Bulanan 🌟',
        'price': 'Rp 30.000',
        'subtitle': 'Akses 30 Hari Full',
        'durationDays': 30,
      },
      {
        'id': 'annual',
        'title': 'Paket Tahunan 👑',
        'price': 'Rp 330.000',
        'subtitle': 'Sangat Hemat! Akses 1 Tahun',
        'durationDays': 365,
      },
    ];

    final paymentMethods = [
      {
        'id': 'qris',
        'title': 'QRIS All Payment',
        'subtitle': 'Scan QR via GoPay, ShopeePay, LinkAja, & m-Banking',
        'icon': '🔳',
      },
      {
        'id': 'dana',
        'title': 'DANA E-Wallet',
        'subtitle': 'Transfer DANA: 0812-3456-7890 a.n Bintang Pintar',
        'icon': '💙',
      },
      {
        'id': 'ovo',
        'title': 'OVO E-Wallet',
        'subtitle': 'Transfer OVO: 0812-3456-7890 a.n Bintang Pintar',
        'icon': '💜',
      },
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final currentPlanObj = plans.firstWhere((p) => p['id'] == selectedPlan);

          return AlertDialog(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Text('💳 ', style: TextStyle(fontSize: 22)),
                Text('Pilih Paket & Pembayaran', style: TextStyle(color: Colors.amber, fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Paket Langganan:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ...plans.map((p) {
                    final isSelected = p['id'] == selectedPlan;
                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          selectedPlan = p['id'] as String;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.amber.withValues(alpha: 0.15) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.amber : Colors.blueGrey.shade700,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold)),
                                Text(p['subtitle'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                            Text(p['price'] as String, style: TextStyle(color: isSelected ? Colors.amber : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),
                  const Text('Pilih Metode Pembayaran:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ...paymentMethods.map((pm) {
                    final isSelected = pm['id'] == selectedPaymentMethod;
                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          selectedPaymentMethod = pm['id'] as String;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0284C7).withValues(alpha: 0.2) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF38BDF8) : Colors.blueGrey.shade700,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(pm['icon'] as String, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pm['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  Text(pm['subtitle'] as String, style: const TextStyle(color: Colors.grey, fontSize: 9.5)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                onPressed: () async {
                  await userProvider.activatePremium(
                    planType: selectedPlan,
                    durationDays: currentPlanObj['durationDays'] as int,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context); // Close Payment Modal
                  Navigator.pop(context); // Close Lock Dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🎉 Pembayaran Berhasil! Akun ${userProvider.account?.displayName ?? ""} kini aktif sebagai Bintang Pintar Premium (${currentPlanObj['title']}) 👑!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                },
                child: Text('Bayar ${currentPlanObj['price']} 💳', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isGuest = userProvider.isGuest;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber.shade400, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium Crown / Lock Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade400.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Text('👑', style: TextStyle(fontSize: 48)),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFCBD5E1),
                height: 1.45,
              ),
            ),

            const SizedBox(height: 16),

            // Feature Highlights List
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blueGrey.shade700),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Text('🌟 ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          'Bebas Akses Semua Planet & Topik Latihan',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text('🌟 ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          'Buka Semua Soal HOTS & Diagram Vektor 3D',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text('🌟 ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          'Fitur Cetak & Download Raport PDF Hasil Belajar',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (isGuest) ...[
              // Notice for Guest users
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade900.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: const Row(
                  children: [
                    Text('⚠️ ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        'Anda masih dalam Mode Tamu. Daftarkan akun terlebih dahulu sebelum berlangganan!',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Daftar Akun Baru 📝', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.login, size: 16),
                  label: const Text('Sudah Punya Akun? Masuk 🔑', style: TextStyle(fontSize: 12)),
                ),
              ),
            ] else ...[
              // Registered user: Proceed to Payment Confirmation
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                  onPressed: () => _showPaymentModal(context, userProvider),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lanjut Pilih Paket Premium 💳',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Colors.grey, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
