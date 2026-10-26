import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'riwayat_screen.dart';
import 'profile_screen.dart';

// TUGAS: MainScreen versi tugas (tab Riwayat & Profil sudah terisi,
// dan menampilkan email yang diinputkan di halaman login)
class MainTugasScreen extends StatefulWidget {
  const MainTugasScreen({super.key});
  @override
  State<MainTugasScreen> createState() => _MainTugasScreenState();
}

class _MainTugasScreenState extends State<MainTugasScreen> {
  int _selectedIndex = 0; // Tab pertama aktif secara default (Beranda)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Ambil email yang dikirim dari halaman login
    final String email = (ModalRoute.of(context)?.settings.arguments as String?) ?? '-';
    final String name = email.contains('@') ? email.split('@').first : email;

    // List kumpulan halaman
    final List<Widget> pages = [
      DashboardScreen(name: name, email: email),
      const RiwayatScreen(),
      ProfileScreen(name: name, email: email, onLogout: _logout),
    ];

    return Scaffold(
      body: pages[_selectedIndex], // Ganti layar sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
