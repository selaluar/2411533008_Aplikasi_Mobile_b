import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

// Form Catat Transaksi: desain Modul 5 (Judul, Nominal) + Jenis & Kategori
// (dropdown Praktikum 3) + Tanggal (tugas Praktikum 3/4). Data disimpan ke SQLite.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  int? _userId;
  String _type = 'pengeluaran';
  String _selectedCategory = expenseCategories.first;
  bool _argsLoaded = false;
  bool _isSaving = false;

  List<String> get _categories =>
      _type == 'pemasukan' ? incomeCategories : expenseCategories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Membaca arguments dari Navigator.pushNamed (userId dan jenis transaksi)
    if (_argsLoaded) return;
    _argsLoaded = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _userId = args['userId'] as int?;
      if (args['type'] == 'pemasukan') {
        _type = 'pemasukan';
        _selectedCategory = incomeCategories.first;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Ubah DateTime menjadi teks DD/MM/YYYY
  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  // Ubah teks DD/MM/YYYY menjadi DateTime; null jika format/tanggal tidak valid
  DateTime? _parseDate(String text) {
    final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(text.trim());
    if (match == null) return null;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  // Menampilkan date picker lalu mengisi field tanggal dengan format DD/MM/YYYY
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(_dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final db = DatabaseHelper.instance;
    // Jika userId tidak dikirim lewat arguments, ambil dari sesi login
    final userId = _userId ?? (await db.getSessionUser())?.id;
    if (userId == null) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    await db.insertTransaction(TransactionItem(
      userId: userId,
      title: _titleController.text.trim(),
      amount: int.parse(_amountController.text),
      type: _type,
      category: _selectedCategory,
      date: _parseDate(_dateController.text)!,
    ));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Transaksi Berhasil Disimpan!'),
          backgroundColor: Colors.green),
    );
    // NAVIGASI POP: Kembali ke Dashboard dan beri tanda data tersimpan
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Catat Transaksi"),
        backgroundColor: const Color(0xFFF59E0B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: "Judul", border: OutlineInputBorder()),
                validator: (value) =>
                    value!.trim().isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Nominal", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Tidak boleh kosong";
                  final amount = int.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return "Harus berupa angka bulat lebih dari 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Jenis transaksi: menentukan saldo bertambah atau berkurang
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                    labelText: "Jenis", border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(
                      value: 'pengeluaran', child: Text('Pengeluaran')),
                  DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue!;
                    _selectedCategory = _categories.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Kategori (key berubah mengikuti jenis agar pilihan ikut diperbarui)
              DropdownButtonFormField<String>(
                key: ValueKey(_type),
                value: _selectedCategory,
                decoration: const InputDecoration(
                    labelText: "Kategori", border: OutlineInputBorder()),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Tanggal Transaksi",
                  hintText: "DD/MM/YYYY",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate, // membuka showDatePicker
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Tanggal wajib diisi";
                  }
                  if (_parseDate(value) == null) {
                    return "Format harus DD/MM/YYYY";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isSaving ? null : _save,
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
