import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'transaction_detail_screen.dart';

// Halaman Riwayat Transaksi (desain dari tugas Modul 5), data dari SQLite
class RiwayatScreen extends StatefulWidget {
  final AppUser user;
  const RiwayatScreen({super.key, required this.user});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<TransactionItem> _transaksi = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final items = await DatabaseHelper.instance.getTransactions(widget.user.id);
    if (!mounted) return;
    setState(() => _transaksi = items);
  }

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
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.of(context).padding.top + 32, 24, 24),
            child: const Text('Riwayat Transaksi',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Expanded(
            child: _transaksi.isEmpty
                ? const Center(
                    child: Text('Belum ada transaksi',
                        style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: _transaksi.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = _transaksi[index];
                      final bool income = item.isIncome;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: income
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFFEF9C3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(transactionIcon(item),
                              size: 20,
                              color: income
                                  ? Colors.green
                                  : const Color(0xFFD97706)),
                        ),
                        title: Text(item.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(formatTanggal(item.date)),
                        trailing: Text(item.amountText,
                            style: TextStyle(
                                color: income ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          // Buka detail transaksi (passing data)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailScreen(
                                title: item.title,
                                amount: item.amountText,
                                category: item.category,
                                date: formatTanggal(item.date),
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
