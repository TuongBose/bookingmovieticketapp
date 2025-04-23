import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isQrRevealed = false;

  @override
  Widget build(BuildContext context) {
    const String memberCode = 'CXN2931D7L';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
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

            const Text(
              'MÃ THÀNH VIÊN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              'CXN2931D7L',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                setState(() {
                  _isQrRevealed = !_isQrRevealed;
                });
              },
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _isQrRevealed
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.qr_code,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Scan to reveal QR Code',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                secondChild: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QrImageView(
                        data: memberCode,
                        version: QrVersions.auto,
                        size: 200.0,
                        gapless: false,
                        errorStateBuilder: (cxt, err) {
                          return const Text('Lỗi khi tạo mã QR');
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'MÃ QR này',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                // TODO: Thêm logic quét QR code nếu cần
              },
              child: const Text(
                'QUÉT QRCODE TRÊN MÀN HÌNH',
                style: TextStyle(color: Colors.blue),
              ),
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
        if (title == "Gọi ĐƯỜNG DÂY NÓNG:" && value.isNotEmpty) {
          _makePhoneCall(value);
        } else if (title == "Email:" && value.isNotEmpty) {
          _launchEmail(value);
        }
        // Xử lý các trường hợp khác nếu cần
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Không thể thực hiện cuộc gọi $phoneNumber';
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Không thể mở ứng dụng email';
    }
  }
}