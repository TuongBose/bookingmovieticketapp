import 'package:flutter/material.dart';
import 'screens/account_screen.dart';     
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Đặt Vé DNNT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const AccountScreen(), 
      
      routes: {
        '/dangky': (context) => const DangKyScreen(),
        '/dangnhap': (context) => const DangNhapScreen(),
      },
    );
  }
}
