import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'transaction_detail_screen.dart';

// Desain sama dengan Dashboard Modul 5 (header oranye, tombol aksi, daftar transaksi).
// Saldo dan transaksi sekarang dibaca dari SQLite.
class DashboardScreen extends StatefulWidget {
  final AppUser user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _balance = 0;
  List<TransactionItem> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final balance = await db.getBalance(widget.user.id);
    final recent = await db.getTransactions(widget.user.id, limit: 5);
    if (!mounted) return;
    setState(() {
      _balance = balance;
      _recent = recent;
    });
  }

  // Buka form lewat named route, lalu muat ulang data jika ada yang tersimpan
  Future<void> _openAddForm(String type) async {
    final saved = await Navigator.pushNamed(
      context,
      '/add',
      arguments: {'userId': widget.user.id, 'type': type},
    );
    if (saved == true) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {
          // Memanggil Rute yang sudah didaftarkan di main.dart
          _openAddForm('pengeluaran');
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
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (_recent.isEmpty)
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Belum ada transaksi',
                        style: TextStyle(color: Colors.grey)),
                  ),
                for (final item in _recent) ...[
                  _buildTransactionItem(context, item),
                  const Divider(),
                ],
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
      padding: EdgeInsets.fromLTRB(
          24, MediaQuery.of(context).padding.top + 32, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, ${widget.user.name}!',
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
                Text(widget.user.email,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 4),
                Text(formatRupiah(_balance),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
        _actionButton(Icons.arrow_downward, const Color(0xFFFEF3C7),
            const Color(0xFFD97706), () => _openAddForm('pemasukan')),
        _actionButton(Icons.arrow_upward, const Color(0xFFFEE2E2), Colors.red,
            () => _openAddForm('pengeluaran')),
        _actionButton(
            Icons.swap_horiz, const Color(0xFFDBEAFE), Colors.blue, null),
      ],
    );
  }

  Widget _actionButton(
      IconData icon, Color bgColor, Color iconColor, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  // Item transaksi terakhir (bisa ditekan untuk melihat detail)
  Widget _buildTransactionItem(BuildContext context, TransactionItem item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: item.isIncome
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFFEF9C3),
            shape: BoxShape.circle),
        child: Icon(transactionIcon(item),
            color: item.isIncome ? Colors.green : const Color(0xFFD97706),
            size: 20),
      ),
      title: Text(item.title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text(item.amountText,
          style: TextStyle(
              color: item.isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold)),
      onTap: () {
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
  }
}
