import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile_model.dart';
import '../providers/stats_provider.dart';
import '../utils/app_colors.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatsProvider>(context);
    final profiles = statsProvider.profiles;
    final activeProfile = statsProvider.activeProfile;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Profil & Akun Belajar 👦👧'),
        backgroundColor: AppColors.primaryCyan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Profil Anak Belajar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Setiap anak memiliki progres belajar, Bintang ⭐, dan XP masing-masing.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),

              // Profiles List Grid
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: profiles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = profiles[index];
                  final isActive = p.id == activeProfile.id;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? AppColors.primaryCyan : Colors.grey.shade300,
                        width: isActive ? 2.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: _getAvatarBg(p.avatar),
                        child: Text(
                          _getAvatarEmoji(p.avatar),
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryCyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Aktif',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryCyan,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      subtitle: Text(
                        'Kelas ${p.classNum} ${p.gradeLevel}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryCyan),
                            onPressed: () => _showEditProfileDialog(context, statsProvider, p),
                          ),
                          if (profiles.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.secondaryCoral),
                              onPressed: () => _confirmDeleteProfile(context, statsProvider, p),
                            ),
                        ],
                      ),
                      onTap: () async {
                        await statsProvider.switchProfile(p.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Beralih ke Profil ${p.name}! 👋')),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Add New Profile Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddProfileDialog(context, statsProvider),
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  label: const Text(
                    'Tambah Profil Anak Baru ➕',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryCoral,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  static Color _getAvatarBg(String avatar) {
    switch (avatar) {
      case 'cat':
        return Colors.orange.shade100;
      case 'astronaut':
        return Colors.purple.shade100;
      case 'hero':
        return Colors.blue.shade100;
      case 'bear':
        return Colors.amber.shade100;
      case 'star':
        return Colors.yellow.shade100;
      case 'robot':
      default:
        return Colors.cyan.shade100;
    }
  }

  void _showAddProfileDialog(BuildContext context, StatsProvider statsProvider) {
    final nameController = TextEditingController();
    String selectedGrade = 'SD';
    int selectedClass = 4;
    String selectedAvatar = 'robot';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Tambah Profil Anak 👦'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Anak',
                      hintText: 'Misal: Budi / Ani',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedGrade,
                          decoration: InputDecoration(
                            labelText: 'Jenjang',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: ['SD', 'SMP'].map((g) {
                            return DropdownMenuItem(value: g, child: Text(g));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedGrade = val;
                                selectedClass = val == 'SD' ? 4 : 7;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: selectedClass,
                          decoration: InputDecoration(
                            labelText: 'Kelas',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: (selectedGrade == 'SD' ? [1, 2, 3, 4, 5, 6] : [7, 8, 9]).map((c) {
                            return DropdownMenuItem(value: c, child: Text('Kelas $c'));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedClass = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Pilih Avatar:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ['robot', 'cat', 'astronaut', 'hero', 'bear', 'star'].map((av) {
                      final isSel = selectedAvatar == av;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedAvatar = av),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getAvatarBg(av),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? AppColors.primaryCyan : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Text(_getAvatarEmoji(av), style: const TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
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
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;

                  final newProfile = UserProfile(
                    id: 'child_${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    gradeLevel: selectedGrade,
                    classNum: selectedClass,
                    avatar: selectedAvatar,
                  );

                  await statsProvider.addProfile(newProfile);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                child: const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, StatsProvider statsProvider, UserProfile p) {
    final nameController = TextEditingController(text: p.name);
    String selectedGrade = p.gradeLevel;
    int selectedClass = p.classNum;
    String selectedAvatar = p.avatar;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Profil Anak ✏️'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Anak',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedGrade == 'SD' ? 'SD' : 'SD',
                          decoration: InputDecoration(
                            labelText: 'Jenjang',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: ['SD'].map((g) {
                            return DropdownMenuItem(value: g, child: Text('SD (Kelas 1-6)'));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedGrade = val;
                                selectedClass = 1;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: selectedClass > 6 ? 1 : selectedClass,
                          decoration: InputDecoration(
                            labelText: 'Kelas',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: [1, 2, 3, 4, 5, 6].map((c) {
                            return DropdownMenuItem(value: c, child: Text('Kelas $c'));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedClass = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Pilih Avatar:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ['robot', 'cat', 'astronaut', 'hero', 'bear', 'star'].map((av) {
                      final isSel = selectedAvatar == av;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedAvatar = av),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getAvatarBg(av),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? AppColors.primaryCyan : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Text(_getAvatarEmoji(av), style: const TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
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
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;

                  final updated = p.copyWith(
                    name: name,
                    gradeLevel: selectedGrade,
                    classNum: selectedClass,
                    avatar: selectedAvatar,
                  );

                  await statsProvider.updateProfile(updated);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteProfile(BuildContext context, StatsProvider statsProvider, UserProfile p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Profil?'),
        content: Text('Apakah Anda yakin ingin menghapus profil "${p.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              await statsProvider.deleteProfile(p.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryCoral),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
