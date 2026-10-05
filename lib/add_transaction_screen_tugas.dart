// TUGAS 1.5 - Input Tanggal Transaksi
// Versi add_transaction_screen.dart yang sudah ditambah input tanggal
// (showDatePicker + validasi wajib diisi).
//
// Cara pakai: simpan di folder lib, lalu di dashboard_screen.dart ganti
//   import 'add_transaction_screen.dart';
// menjadi
//   import 'add_transaction_screen_tugas.dart';

import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(); // TUGAS: controller tanggal

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // TUGAS: membuka kalender, lalu menulis hasilnya ke field (DD/MM/YYYY)
  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final dd = picked.day.toString().padLeft(2, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final yyyy = picked.year.toString();
      setState(() {
        _dateController.text = '$dd/$mm/$yyyy';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catat Transaksi"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Judul", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // ===== TUGAS: INPUT TANGGAL TRANSAKSI (sebelum tombol Simpan) =====
              TextFormField(
                controller: _dateController,
                readOnly: true, // tidak diketik manual, diisi lewat kalender
                onTap: _pilihTanggal,
                decoration: const InputDecoration(
                  labelText: "Tanggal Transaksi",
                  hintText: "DD/MM/YYYY",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                // Validasi wajib diisi
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Tanggal wajib diisi" : null,
              ),
              // ==================================================================

              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Transaksi Berhasil Disimpan! (${_dateController.text})'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // NAVIGASI POP: Kembali ke halaman sebelumnya (Dashboard)
                    Navigator.pop(context);
                  }
                },
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}