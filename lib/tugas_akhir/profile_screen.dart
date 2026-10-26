import 'package:flutter/material.dart';

// Halaman Profil (desain dari tugas Modul 5): avatar, nama, email, dan tombol logout.
// Nama dan email diambil dari akun yang login di SQLite.
class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  // Dipanggil saat tombol logout ditekan (diisi dari main_screen.dart)
  final VoidCallback? onLogout;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header oranye dengan avatar, nama, dan email
          Container(
            width: double.infinity,
            color: const Color(0xFFF59E0B),
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 32, 24, 32),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline, color: Color(0xFFD97706)),
                  title: const Text('Nama'),
                  subtitle: Text(name),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined, color: Color(0xFFD97706)),
                  title: const Text('Email'),
                  subtitle: Text(email),
                ),
                const SizedBox(height: 24),
                // Tombol Logout
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout', style: TextStyle(fontSize: 16)),
                    onPressed: onLogout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
