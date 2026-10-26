import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'dashboard_screen.dart';
import 'riwayat_screen.dart';
import 'profile_screen.dart';

// Penampung tab (BottomNavigationBar dari Modul 5).
// Data pengguna yang login diambil dari sesi di SQLite.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Tab pertama aktif secara default (Beranda)
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await DatabaseHelper.instance.getSessionUser();
    if (!mounted) return;
    if (user == null) {
      // Tidak ada sesi: kembali ke halaman login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    setState(() => _user = user);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    // Hapus sesi; akun dan transaksi tetap tersimpan di SQLite
    await DatabaseHelper.instance.clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // List kumpulan halaman
    final List<Widget> pages = [
      DashboardScreen(user: user),
      RiwayatScreen(user: user),
      ProfileScreen(name: user.name, email: user.email, onLogout: _logout),
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
