class Cinema {
  final int? id;
  final String name;
  final String location;
  final String phoneNumber;

  Cinema({
    this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() => {
    'ID': id,
    'NAME': name,
    'LOCATION': location,
    'PHONENUMBER': phoneNumber,
  };

  factory Cinema.fromMap(Map<String, dynamic> map) => Cinema(
    id: map['ID'],
    name: map['NAME'],
    location: map['LOCATION'],
    phoneNumber: map['PHONENUMBER'],
  );
}
