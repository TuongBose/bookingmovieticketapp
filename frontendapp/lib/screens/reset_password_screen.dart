import 'package:flutter/material.dart';

class QuenMatKhauScreen extends StatefulWidget {
  const QuenMatKhauScreen({super.key});

  @override
  State<QuenMatKhauScreen> createState() => _QuenMatKhauScreenState();
}

class _QuenMatKhauScreenState extends State<QuenMatKhauScreen> {
  final TextEditingController usernameController = TextEditingController();
  final List<String> domains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'icloud.com',
    'hotmail.com'
  ];

  String selectedDomain = 'gmail.com';
  String? emailError;
  bool isEmailValid = false;

  void validateEmail() {
    final username = usernameController.text.trim();
    final fullEmail = '$username@$selectedDomain';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      isEmailValid = emailRegex.hasMatch(fullEmail);
      emailError = isEmailValid
          ? null
          : 'Email không hợp lệ, vui lòng kiểm tra tên email.';
    });
  }

  @override
  void initState() {
    super.initState();
    usernameController.addListener(validateEmail);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullEmail = '${usernameController.text.trim()}@$selectedDomain';

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.blue),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              "Quên mật khẩu?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Text(
              "Vui lòng nhập tên email và chọn domain. Chúng tôi sẽ gửi liên kết đặt lại mật khẩu.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Tên email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedDomain,
                    items: domains
                        .map((domain) => DropdownMenuItem(
                              value: domain,
                              child: Text('@$domain'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDomain = value!;
                        validateEmail();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  emailError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const Spacer(),

            ElevatedButton(
              onPressed: isEmailValid
                  ? () {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Đã gửi link đặt lại mật khẩu đến $fullEmail"),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: isEmailValid ? Colors.blue : Colors.grey[300],
              ),
              child: const Text("Yêu Cầu Mật Khẩu Mới"),
            ),
          ],
        ),
      ),
    );
  }
}
