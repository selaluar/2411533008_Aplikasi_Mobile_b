import 'package:flutter/material.dart';
import 'transaction_detail_screen.dart';

// TUGAS: Halaman Riwayat Transaksi
class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  // Data contoh riwayat transaksi
  static const List<Map<String, dynamic>> _transaksi = [
    {'title': 'Makan Siang', 'amount': '- Rp 50.000', 'category': 'Makanan', 'date': '13 September 2026', 'icon': Icons.restaurant},
    {'title': 'Bensin Motor', 'amount': '- Rp 30.000', 'category': 'Transportasi', 'date': '12 September 2026', 'icon': Icons.local_gas_station},
    {'title': 'Beli Buku', 'amount': '- Rp 120.000', 'category': 'Pendidikan', 'date': '10 September 2026', 'icon': Icons.menu_book},
    {'title': 'Pulsa & Kuota', 'amount': '- Rp 75.000', 'category': 'Tagihan', 'date': '5 September 2026', 'icon': Icons.phone_android},
    {'title': 'Gaji Bulanan', 'amount': '+ Rp 5.000.000', 'category': 'Pemasukan', 'date': '1 September 2026', 'icon': Icons.attach_money},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header oranye, sama dengan Beranda
          Container(
            width: double.infinity,
            color: const Color(0xFFF59E0B),
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 32, 24, 24),
            child: const Text('Riwayat Transaksi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _transaksi.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = _transaksi[index];
                final bool income = (item['amount'] as String).startsWith('+');
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: income ? const Color(0xFFDCFCE7) : const Color(0xFFFEF9C3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'] as IconData,
                        size: 20, color: income ? Colors.green : const Color(0xFFD97706)),
                  ),
                  title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(item['date'] as String),
                  trailing: Text(item['amount'] as String,
                      style: TextStyle(
                          color: income ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Buka detail transaksi (passing data)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailScreen(
                          title: item['title'] as String,
                          amount: item['amount'] as String,
                          category: item['category'] as String,
                          date: item['date'] as String,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
