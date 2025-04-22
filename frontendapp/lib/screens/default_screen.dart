import 'package:frontendapp/screens/login_screen.dart';
import 'package:frontendapp/screens/user_screen.dart';

import '../config.dart';
import '../screens/cinema_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'movie_news_screen.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyDefaultScreen();
  }
}

class MyDefaultScreen extends StatefulWidget {
  const MyDefaultScreen({super.key});

  @override
  State<MyDefaultScreen> createState() => MyDefaultScreenState();
}

class MyDefaultScreenState extends State<MyDefaultScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeScreen(),
      CinemaScreen(),
      MovieNewsScreen(),
      Config.isLogin ? UserScreen() : AccountScreen(),
    ];
    return Scaffold(
      // Sử dụng IndexedStack để giữ trạng thái của các màn hình trong tab
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions, // Sử dụng danh sách đã cập nhật
      ),
      bottomNavigationBar: BottomNavigationBar(
        // QUAN TRỌNG: Đặt type thành fixed để các mục luôn hiển thị label
        // và màu nền hoạt động đúng (nếu cần set màu nền)
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
            // backgroundColor: Colors.white, // Không cần khi type=fixed trừ khi muốn màu khác
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_sharp),
            label: 'Rạp phim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Điện ảnh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent, // Màu khi mục được chọn
        unselectedItemColor: Colors.grey, // Màu khi mục không được chọn
        onTap: _onItemTapped,
        // backgroundColor: Colors.white, // Có thể đặt màu nền chung ở đây
        showUnselectedLabels: true, // Đảm bảo label luôn hiển thị
      ),
    );
  }
}