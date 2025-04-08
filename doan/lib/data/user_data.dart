import 'package:doan/models/user.dart';

final List<User> sampleUsers = [
  User(
    id: 1,
    name: 'Nguyễn Văn A',
    email: 'a@example.com',
    password: '123456',
    phoneNumber: '0901234567',
    address: '123 Đường ABC, Quận 1',
    dateOfBirth: DateTime.parse('1990-01-01'),
    createdAt: DateTime.now(),
    isActive: true,
    roleName: false,
  ),
  User(
    id: 2,
    name: 'Trần Thị B',
    email: 'b@example.com',
    password: 'password',
    phoneNumber: '0912345678',
    address: '456 Đường XYZ, Quận 5',
    dateOfBirth: DateTime.parse('1995-05-10'),
    createdAt: DateTime.now(),
    isActive: true,
    roleName: true, // Admin chẳng hạn
  ),
  User(
    id: 3,
    name: 'Lê Văn C',
    email: 'c@example.com',
    password: 'abc123',
    phoneNumber: '0922334455',
    address: '789 Đường DEF, Quận 3',
    dateOfBirth: DateTime.parse('2000-08-20'),
    createdAt: DateTime.now(),
    isActive: false,
    roleName: false,
  ),
];
