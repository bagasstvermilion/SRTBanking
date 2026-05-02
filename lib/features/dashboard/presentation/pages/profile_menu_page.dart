import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srtbanking/features/auth/presentation/state/auth_provider.dart';

class ProfileMenuPage extends ConsumerWidget {
  final String name;
  const ProfileMenuPage({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'Akun Saya',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar & nama ──
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // ── Menu items ──
            _MenuSection(
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  label: 'Profil Saya',
                  onTap: () {}, // hardcode dulu
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Pengaturan',
                  onTap: () {}, // hardcode dulu
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MenuSection(
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  label: 'FAQ',
                  onTap: () {}, // hardcode dulu
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: 'Tentang Aplikasi',
                  onTap: () {}, // hardcode dulu
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Logout ──
            _MenuSection(
              items: [
                _MenuItem(
                  icon: Icons.logout,
                  label: 'Keluar',
                  isDestructive: true,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Konfirmasi Logout'),
                        content: const Text('Yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Menu Section ─────────────────────────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  item.icon,
                  color: item.isDestructive
                      ? Colors.red
                      : const Color(0xFF1565C0),
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: item.isDestructive ? Colors.red : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: item.isDestructive
                    ? null
                    : const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: item.onTap,
              ),
              if (index < items.length - 1)
                const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Menu Item Model ──────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
}
