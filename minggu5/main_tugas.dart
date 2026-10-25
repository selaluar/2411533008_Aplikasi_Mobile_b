import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main_tugas_screen.dart';
import 'add_transaction_screen.dart';

// TUGAS: aplikasi dimulai dari halaman Login
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker Final - Tugas',
      theme: ThemeData(primarySwatch: Colors.amber),
      // MENGGUNAKAN NAMED ROUTES
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => const MainTugasScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
      // Hanya memuat halaman Login di awal (tanpa menumpuk '/' di bawahnya)
      onGenerateInitialRoutes: (String initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: initialRoute),
            builder: (context) => const LoginScreen(),
          ),
        ];
      },
    );
  }
}
