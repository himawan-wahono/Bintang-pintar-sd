import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/stats_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/app_onboarding_dialog.dart';
import '../widgets/sync_progress_banner.dart';
import '../services/connectivity_service.dart';
import '../utils/storage_service.dart';
import 'welcome_auth_screen.dart';
import 'badges_screen.dart';
import 'parent_pin_screen.dart';
import 'profile_selection_screen.dart';
import 'math_saga_map_screen.dart';
import 'english_world_map_screen.dart';
import 'math_learning_themes_screen.dart';
import 'english_learning_themes_screen.dart';
import 'parent_custom_questions_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static String _getAvatarEmoji(String avatar) {
    switch (avatar) {
      case 'cat':
        return '🐱';
      case 'astronaut':
        return '👩‍🚀';
      case 'hero':
        return '🦸‍♂️';
      case 'bear':
        return '🐻';
      case 'star':
        return '🌟';
      case 'robot':
      default:
        return '🤖';
    }
  }

  @override
  void initState() {
    super.initState();
    // Check authentication: users must be logged in to access HomeScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statsProvider = Provider.of<StatsProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userProvider.account == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        return;
      }

      // Periksa jumlah bank soal di server tanpa mengunduh otomatis (pengguna unduh manual)
      ConnectivityService().refreshQuestionCount();

      // Tampilkan onboarding informasi aplikasi HANYA 1x saat pertama kali aplikasi di-install
      StorageService.hasSeenFirstInstallOnboarding().then((hasSeen) {
        if (!hasSeen && !statsProvider.stats.hasSeenOnboarding) {
          if (mounted) {
            AppOnboardingDialog.show(
              context,
              onComplete: () {
                StorageService.markFirstInstallOnboardingSeen();
                statsProvider.markOnboardingSeen();
              },
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatsProvider>(context);
    final stats = statsProvider.stats;
    final activeProfile = statsProvider.activeProfile;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 12,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.calculate, color: AppColors.primaryCyan, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'BINTANG PINTAR ⭐🚀',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Account / Profile Status Pill Badge
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final isGuest = userProvider.isGuest;
              final accountName = userProvider.account?.displayName;

              return InkWell(
                onTap: () => _showAccountProfileBottomSheet(context),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: isGuest ? Colors.grey.shade200 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isGuest ? Colors.grey.shade400 : Colors.blue.shade300,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isGuest
                            ? '👤 Tamu'
                            : (accountName != null && accountName.isNotEmpty ? '⭐ $accountName' : '⭐ Akun'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isGuest ? Colors.grey.shade800 : Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Onboarding Feature Showcase Info Button
          IconButton(
            tooltip: 'Informasi Fitur & Kurikulum SD',
            icon: const Icon(Icons.info_outline, color: AppColors.primaryCyan, size: 22),
            onPressed: () {
              AppOnboardingDialog.show(
                context,
                onComplete: () => statsProvider.markOnboardingSeen(),
              );
            },
          ),

          // Profile Switcher Button
          IconButton(
            tooltip: 'Ganti Profil Anak',
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getAvatarEmoji(activeProfile.avatar),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    activeProfile.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileSelectionScreen()),
              );
            },
          ),

          // Parent Portal PIN Button
          IconButton(
            tooltip: 'Portal Orang Tua',
            icon: const Icon(Icons.security_outlined, color: AppColors.secondaryCoral),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentPinScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Card with Registered User Name Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryCyan, AppColors.bInggrisColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final account = userProvider.account;
                      final displayName = (account != null && !account.isGuest && account.displayName.isNotEmpty)
                          ? account.displayName
                          : activeProfile.name;
                      final userSubtitle = (account != null && !account.isGuest)
                          ? '📧 Akun: ${account.email} • Akses Penuh Gratis 🌟'
                          : '👤 Mode Tamu • Siap menjelajah matematika & bahasa hari ini?';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Halo, $displayName! 👋',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Kelas ${activeProfile.classNum} SD',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userSubtitle,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Progress Stats Summary (XP, Stars, Streak)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStatItem('⚡ XP Total', '${stats.totalXp} XP', Colors.amberAccent),
                        _buildHeaderStatItem('⭐ Bintang', '${stats.totalStars} ⭐', Colors.yellowAccent),
                        _buildHeaderStatItem('🔥 Streak', '${stats.streakDays} Hari', Colors.orangeAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

            // Live Question Download Progress Banner & Database Soal Indicator (Hanya tampil untuk akun login, disembunyikan untuk Tamu)
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                if (userProvider.isGuest) {
                  return const SizedBox(height: 10);
                }
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    SyncProgressBanner(),
                    SizedBox(height: 6),
                  ],
                );
              },
            ),

            // SECTION 1: MODE PETUALANGAN GAME 🚀
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🚀 Mode Petualangan Game',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.military_tech_outlined, size: 18, color: AppColors.primaryCyan),
                  label: const Text('Lencana Saya', style: TextStyle(color: AppColors.primaryCyan, fontSize: 13)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BadgesScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Subject Adventure Cards List
            Column(
              children: [
                // Active Category: Matematika (Planet Saga 🪐)
                _buildSubjectCategoryCard(
                  context,
                  title: '🚀 Matematika (Planet Saga)',
                  subtitle: '19 Planet Astronomi & Operasi Hitung SD (Kelas 1-6)',
                  badgeText: 'Peta Planet 🪐',
                  color: AppColors.primaryCyan,
                  icon: Icons.rocket_launch,
                  isAvailable: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MathSagaMapScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Active Category: Bahasa Inggris (World Tour Passport Adventure ✈️🌏)
                _buildSubjectCategoryCard(
                  context,
                  title: '✈️ Bahasa Inggris (World Tour)',
                  subtitle: 'Paspor 7 Negara, Phonics, Grammar & Daily Conversation',
                  badgeText: 'Peta World Tour ✈️',
                  color: AppColors.bInggrisColor,
                  icon: Icons.language,
                  isAvailable: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EnglishWorldMapScreen(),
                      ),
                    );
                  },
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 28),

            // SECTION 2: MODUL BELAJAR & SOAL ORTU 🎓
            const Text(
              '🎓 Modul Belajar & Soal Ortu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            // Learning & Custom Questions Cards List
            Column(
              children: [
                // Active Category: Pintar Matematika (Modul Materi & Topik 🧠)
                _buildSubjectCategoryCard(
                  context,
                  title: '🧠 Pintar Matematika (Topik & Materi)',
                  subtitle: '5 Tema, 19 Topik Pembelajaran, Ringkasan Materi & Latihan Soal',
                  badgeText: 'Modul Belajar 📚',
                  color: const Color(0xFF8338EC),
                  icon: Icons.psychology_rounded,
                  isAvailable: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MathLearningThemesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Active Category: Pintar Bahasa Inggris (Modul Materi & Topik 🔤)
                _buildSubjectCategoryCard(
                  context,
                  title: '🔤 Pintar Bahasa Inggris (Topik & Materi)',
                  subtitle: '5 Tema, 18 Topik English, Phonics, Grammar & Conversation',
                  badgeText: 'Modul English 🇬🇧',
                  color: const Color(0xFF4361EE),
                  icon: Icons.translate_rounded,
                  isAvailable: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EnglishLearningThemesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Active Category: Soal Buatan Orang Tua (Koleksi & Latihan 👨‍👩‍👧‍👦)
                _buildSubjectCategoryCard(
                  context,
                  title: '👨‍👩‍👧‍👦 Soal Buatan Orang Tua',
                  subtitle: 'Koleksi Soal Spesial Ayah & Bunda, Edit, Tambah & Latihan',
                  badgeText: 'Modul Orang Tua 👨‍👩‍👧‍👦',
                  color: const Color(0xFF00F2FE),
                  icon: Icons.assignment_ind_rounded,
                  isAvailable: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentCustomQuestionsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  static Widget _buildHeaderStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  static Widget _buildSubjectCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badgeText,
    required Color color,
    required IconData icon,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAccountProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: const Color(0xFF0F172A),
      builder: (context) {
        return Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final account = userProvider.account;
            final isGuest = userProvider.isGuest;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // User Account Profile Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isGuest ? Colors.blueGrey.shade700 : const Color(0xFF38BDF8)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isGuest ? Colors.blueGrey.shade800 : Colors.blue.shade100,
                          child: Text(
                            isGuest ? '👤' : '🌟',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (account?.displayName.isNotEmpty == true)
                                    ? account!.displayName
                                    : (isGuest ? 'Pengguna Tamu' : 'Akun Terdaftar'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isGuest ? 'Mode Latihan Tanpa Akun' : (account?.email ?? ''),
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isGuest ? Colors.grey.shade700 : const Color(0xFF0284C7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isGuest ? '👤 Mode Tamu' : '🌟 Akses Penuh (100% Gratis)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (isGuest) ...[
                    // Options for Guest users
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                            MaterialPageRoute(builder: (context) => const WelcomeAuthScreen()),
                          );
                        },
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Daftar / Masuk Akun 📝', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Keluar dari Mode Tamu?'),
                              content: const Text('Apakah Anda yakin ingin keluar dari Mode Tamu dan kembali ke layar login?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Keluar (Logout)', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && context.mounted) {
                            await userProvider.logout();
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Anda telah keluar dari Mode Tamu. Silakan masuk kembali.'),
                                backgroundColor: Colors.orangeAccent,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Keluar dari Mode Tamu (Logout) 🚪', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ] else ...[
                    // Options for Registered users
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Keluar dari Akun?'),
                              content: const Text('Apakah Anda yakin ingin keluar dari akun Bintang Pintar ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Keluar (Logout)', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && context.mounted) {
                            await userProvider.logout();
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Anda telah keluar dari akun. Silakan masuk kembali.'),
                                backgroundColor: Colors.orangeAccent,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Keluar dari Akun (Logout) 🚪', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
