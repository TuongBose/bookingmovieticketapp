import 'package:flutter/material.dart';
import 'register_screen.dart';  
import 'login_screen.dart';     

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/bear.jpg',
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Đăng Ký Thành Viên Star\nNhận Ngay Ưu Đãi!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Column(
                  children: [
                    Icon(Icons.stars, color: Colors.orange),
                    SizedBox(height: 4),
                    Text('Stars'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.orange),
                    SizedBox(height: 4),
                    Text('Quà tặng'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.orange),
                    SizedBox(height: 4),
                    Text('Ưu đãi đặc biệt'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  onPressed: () {
                    // 👉 Chuyển sang trang đăng ký
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DangKyScreen()),
                    );
                  },
                  child: const Text('Đăng ký'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    side: const BorderSide(color: Colors.orange),
                  ),
                  onPressed: () {
                    // 👉 Chuyển sang trang đăng nhập
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DangNhapScreen()),
                    );
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Column(
              children: [
                infoRow("Gọi ĐƯỜNG DÂY NÓNG:", "19001122", isLink: true),
                infoRow("Email:", "hotro@dnntstudio.vn", isLink: true),
                infoRow("Thông Tin Công Ty", ""),
                infoRow("Điều Khoản Sử Dụng", ""),
                infoRow("Chính Sách Thanh Toán", ""),
                infoRow("Chính Sách Bảo Mật", ""),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters_outlined),
            label: 'Rạp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_outlined),
            label: 'Phim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget infoRow(String title, String value, {bool isLink = false}) {
    return ListTile(
      title: Text(title),
      subtitle: value.isNotEmpty
          ? Text(value, style: TextStyle(color: isLink ? Colors.blue : null))
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: xử lý khi bấm vào
      },
    );
  }
}
