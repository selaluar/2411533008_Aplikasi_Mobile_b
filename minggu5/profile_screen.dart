import 'package:flutter/material.dart';

// TUGAS: Halaman Profil berisi avatar, nama, email, dan tombol logout.
class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  // Dipanggil saat tombol logout ditekan (diisi dari main_tugas_screen.dart)
  final VoidCallback? onLogout;

  const ProfileScreen({
    super.key,
    this.name = 'Budi',
    this.email = 'budi@email.com',
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            // Nama
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Email
            Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
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
                onPressed: () {
                  if (onLogout != null) {
                    onLogout!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jalankan main_tugas.dart untuk mencoba login/logout')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
