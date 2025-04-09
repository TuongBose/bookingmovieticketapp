import 'package:flutter/material.dart';

class CinemaScreen extends StatelessWidget {
  final List<Map<String, String>> cinemas = [
    {
      'name': 'Galaxy Sala',
      'address': 'Tầng 3, Thiso Mall Sala, 10 Mai Chí Thọ, P...',
      'phone': '1900 2224',
      'image': 'assets/images/movies/botubaothu_poster.jpg',
    },
    {
      'name': 'Galaxy Tân Bình',
      'address': '246 Nguyễn Hồng Đào, Q.TB, Tp.HCM',
      'phone': '1900 2224',
      'image': 'assets/images/movies/mai_poster.webp',
    },
    {
      'name': 'Galaxy Kinh Dương Vương',
      'address': '718bis Kinh Dương Vương, Q6, TpHCM',
      'phone': '1900 2224',
      'image': 'assets/images/movies/botubaothu_poster.jpg',
    },
    // Thêm các rạp khác ở đây...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rạp Phim'),
      ),
      body: ListView.builder(
        itemCount: cinemas.length,
        itemBuilder: (context, index) {
          final cinema = cinemas[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                cinema['image']!,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              cinema['name']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cinema['address']!,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("Phone: ${cinema['phone']}"),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Rạp Phim
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.theaters), label: 'Rạp Phim'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Điện Ảnh'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài Khoản'),
        ],
      ),
    );
  }
}
