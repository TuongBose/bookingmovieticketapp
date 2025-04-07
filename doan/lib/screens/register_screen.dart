import 'package:flutter/material.dart';

class DangKyScreen extends StatelessWidget {
  const DangKyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.close, color: Colors.blue),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/images/logo-bear.png', height: 100), 
            const SizedBox(height: 12),
            const Text(
              'Đăng Ký Thành Viên Star',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                IconWithText(icon: Icons.card_giftcard, label: 'Stars'),
                IconWithText(icon: Icons.card_membership, label: 'Quà tặng'),
                IconWithText(icon: Icons.emoji_events, label: 'Ưu đãi đặc biệt'),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(icon: Icons.person, hint: 'Họ và tên'),
            CustomTextField(icon: Icons.email, hint: 'Email'),
            CustomTextField(icon: Icons.phone, hint: 'Số điện thoại'),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Giới tính (Tuỳ chọn)'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                GenderRadio(label: 'Nam'),
                GenderRadio(label: 'Nữ'),
                GenderRadio(label: 'Chưa Xác Định'),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              icon: Icons.calendar_today,
              hint: 'Ngày sinh (Tuỳ chọn)',
              isDate: true,
            ),
            CustomTextField(icon: Icons.lock, hint: 'Mật khẩu', isPassword: true),
            CustomTextField(icon: Icons.lock, hint: 'Xác nhận mật khẩu', isPassword: true),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(value: false, onChanged: (val) {}),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Bằng việc đăng ký tài khoản, tôi đồng ý với ',
                      children: [
                        TextSpan(
                          text: 'điều khoản dịch vụ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(text: ' và '),
                        TextSpan(
                          text: 'chính sách bảo mật',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(text: ' của Galaxy Cinema.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.grey,
              ),
              child: const Text('Hoàn tất'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tài khoản đã được đăng ký!'),
                TextButton(
                  onPressed: () {},
                  child: const Text('Đăng nhập'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String label;
  const IconWithText({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class GenderRadio extends StatelessWidget {
  final String label;
  const GenderRadio({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(value: false, groupValue: false, onChanged: (val) {}),
        Text(label),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool isPassword;
  final bool isDate;
  const CustomTextField({
    required this.icon,
    required this.hint,
    this.isPassword = false,
    this.isDate = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      readOnly: isDate,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onTap: isDate
          ? () {
              // xu ly chon ngay
            }
          : null,
    );
  }
}
