class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final DateTime createdAt;
  final bool isActive;
  final bool roleName;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.createdAt,
    required this.isActive,
    required this.roleName,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['ID'],
    name: map['NAME'],
    email: map['EMAIL'],
    password: map['PASSWORD'],
    phoneNumber: map['PHONENUMBER'],
    address: map['ADDRESS'],
    dateOfBirth: DateTime.parse(map['DATEOFBIRTH']),
    createdAt: DateTime.parse(map['CREATEDAT']),
    isActive: map['ISACTIVE'] == 1,
    roleName: map['ROLENAME'] == 1,
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'NAME': name,
    'EMAIL': email,
    'PASSWORD': password,
    'PHONENUMBER': phoneNumber,
    'ADDRESS': address,
    'DATEOFBIRTH': dateOfBirth,
    'CREATEDAT': createdAt,
    'ISACTIVE': isActive ? 1 : 0,
    'ROLENAME': roleName ? 1 : 0,
  };
}
