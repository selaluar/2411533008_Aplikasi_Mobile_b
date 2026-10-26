import 'package:flutter/material.dart';

// Model data pengguna (tabel users)
class AppUser {
  final int id;
  final String name;
  final String email;

  const AppUser({required this.id, required this.name, required this.email});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}

// Model data transaksi (tabel transactions)
class TransactionItem {
  final int? id;
  final int userId;
  final String title;
  final int amount;
  final String type; // 'pemasukan' atau 'pengeluaran'
  final String category;
  final DateTime date;

  const TransactionItem({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  bool get isIncome => type == 'pemasukan';

  // Teks nominal bertanda, contoh: "- Rp 50.000" atau "+ Rp 5.000.000"
  String get amountText => '${isIncome ? '+' : '-'} ${formatRupiah(amount)}';

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      // Disimpan dalam format yyyy-MM-dd agar mudah diurutkan
      'date': date.toIso8601String().substring(0, 10),
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      amount: map['amount'] as int,
      type: map['type'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}

// Kategori per jenis transaksi (dropdown dari Praktikum 3)
const List<String> expenseCategories = [
  'Makanan',
  'Transportasi',
  'Pendidikan',
  'Tagihan',
  'Hiburan',
  'Lainnya',
];
const List<String> incomeCategories = ['Gaji', 'Bonus', 'Lainnya'];

// Format angka menjadi Rupiah, contoh: 5000000 -> "Rp 5.000.000"
String formatRupiah(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${value < 0 ? '- ' : ''}Rp $buffer';
}

const List<String> _namaBulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

// Format tanggal, contoh: "13 September 2026"
String formatTanggal(DateTime d) =>
    '${d.day} ${_namaBulan[d.month - 1]} ${d.year}';

// Ikon transaksi mengikuti ikon yang dipakai di Modul 5
IconData transactionIcon(TransactionItem item) {
  if (item.isIncome) return Icons.attach_money;
  switch (item.category) {
    case 'Makanan':
      return Icons.restaurant;
    case 'Transportasi':
      return Icons.local_gas_station;
    case 'Pendidikan':
      return Icons.menu_book;
    case 'Tagihan':
      return Icons.phone_android;
    case 'Hiburan':
      return Icons.movie;
    default:
      return Icons.receipt_long;
  }
}
