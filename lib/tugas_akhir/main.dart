import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_helper.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'add_transaction_screen.dart';

// TUGAS AKHIR: gabungan Praktikum 1 - 5 + SQLite + Login & Register
Future<void> main() async {
  // Wajib dipanggil sebelum mengakses SQLite di dalam main()
  WidgetsFlutterBinding.ensureInitialized();

  // Di Windows/Linux/macOS, SQLite dijalankan lewat sqflite_common_ffi.
  // Di Android (APK) tetap memakai sqflite biasa.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Cek sesi login yang tersimpan: kalau ada, langsung masuk ke halaman utama
  final user = await DatabaseHelper.instance.getSessionUser();
  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker Final',
      theme: ThemeData(primarySwatch: Colors.amber),
      // MENGGUNAKAN NAMED ROUTES
      initialRoute: isLoggedIn ? '/' : '/login',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
      // Hanya memuat satu halaman awal (tanpa menumpuk '/' di bawah '/login')
      onGenerateInitialRoutes: (String initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: initialRoute),
            builder: (context) => initialRoute == '/login'
                ? const LoginScreen()
                : const MainScreen(),
          ),
        ];
      },
    );
  }
}
