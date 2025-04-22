import 'package:flutter/material.dart';
import 'package:frontendapp/screens/default_screen.dart';
import 'package:frontendapp/screens/login_screen.dart';
import 'package:frontendapp/screens/register_screen.dart';
import 'package:frontendapp/screens/reset_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/default',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/default':
            final int initialIndex = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
              builder: (context) => DefaultScreen(initialIndex: initialIndex),
            );
          case '/dangnhap':
            return MaterialPageRoute(builder: (context) => const DangNhapScreen());
          case '/dangky':
            return MaterialPageRoute(builder: (context) => const DangKyScreen());
          case '/quenmatkhau':
            return MaterialPageRoute(builder: (context) => const QuenMatKhauScreen());
          default:
            return MaterialPageRoute(builder: (context) => const DefaultScreen());
        }
      },
    );
  }
}