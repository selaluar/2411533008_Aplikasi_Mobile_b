import 'package:flutter/material.dart';
import 'transaction_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String name;
  final String? email; // diisi dari halaman login (versi tugas)

  const DashboardScreen({super.key, this.name = 'Budi', this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {
          // Memanggil Rute yang sudah didaftarkan di main.dart
          Navigator.pushNamed(context, '/add');
        },
      ),
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const Text('Transaksi Terakhir',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTransactionItem(context),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header oranye: sapaan, saldo, dan ikon profil
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF59E0B),
      padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 32, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, $name!', style: const TextStyle(fontSize: 14, color: Colors.white)),
                if (email != null)
                  Text(email!, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 4),
                const Text('Rp 5.000.000',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Tiga tombol aksi: pemasukan, pengeluaran, transfer
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(Icons.arrow_downward, const Color(0xFFFEF3C7), const Color(0xFFD97706)),
        _actionButton(Icons.arrow_upward, const Color(0xFFFEE2E2), Colors.red),
        _actionButton(Icons.swap_horiz, const Color(0xFFDBEAFE), Colors.blue),
      ],
    );
  }

  Widget _actionButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor),
    );
  }

  // Item transaksi terakhir (bisa ditekan untuk melihat detail)
  Widget _buildTransactionItem(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Color(0xFFFEF9C3), shape: BoxShape.circle),
        child: const Icon(Icons.restaurant, color: Color(0xFFD97706), size: 20),
      ),
      title: const Text('Makan Siang', style: TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Text('- Rp 50.000',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransactionDetailScreen(
              title: 'Makan Siang',
              amount: '- Rp 50.000',
              category: 'Makanan',
              date: '13 September 2026',
            ),
          ),
        );
      },
    );
  }
}
