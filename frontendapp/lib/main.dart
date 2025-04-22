import 'package:flutter/material.dart';
import 'package:frontendapp/screens/default_screen.dart';
import 'package:frontendapp/screens/home_screen.dart';
import 'package:frontendapp/screens/login_screen.dart';
import 'package:frontendapp/screens/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Đặt Vé Galaxy Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: '/default',
      routes: {
        '/default': (context) => const DefaultScreen(),
        '/home': (context) => const HomeScreen(),
        '/dangnhap': (context) => const DangNhapScreen(),
        '/user': (context) => const UserScreen(),
      },
    );
  }
}


