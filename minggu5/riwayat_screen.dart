import 'package:flutter/material.dart';
import 'transaction_detail_screen.dart';

// TUGAS: Halaman Riwayat Transaksi
class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  // Data contoh riwayat transaksi
  static const List<Map<String, dynamic>> _transaksi = [
    {'title': 'Makan Siang', 'amount': '- Rp 50.000', 'category': 'Makanan', 'date': '13 September 2026', 'income': false, 'icon': Icons.fastfood},
    {'title': 'Bensin Motor', 'amount': '- Rp 30.000', 'category': 'Transportasi', 'date': '12 September 2026', 'income': false, 'icon': Icons.local_gas_station},
    {'title': 'Beli Buku', 'amount': '- Rp 120.000', 'category': 'Pendidikan', 'date': '10 September 2026', 'income': false, 'icon': Icons.menu_book},
    {'title': 'Pulsa & Kuota', 'amount': '- Rp 75.000', 'category': 'Tagihan', 'date': '5 September 2026', 'income': false, 'icon': Icons.phone_android},
    {'title': 'Gaji Bulanan', 'amount': '+ Rp 5.000.000', 'category': 'Pemasukan', 'date': '1 September 2026', 'income': true, 'icon': Icons.attach_money},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _transaksi.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _transaksi[index];
          final bool income = item['income'] as bool;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: income ? Colors.green : Colors.orange,
              child: Icon(item['icon'] as IconData, color: Colors.white),
            ),
            title: Text(item['title'] as String),
            subtitle: Text('${item['category']} • ${item['date']}'),
            trailing: Text(
              item['amount'] as String,
              style: TextStyle(color: income ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
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
    );
  }
}
