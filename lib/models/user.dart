class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String bloodType;
  final String address;
  final String? token;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodType,
    required this.address,
    this.token,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bloodType: json['blood_type'] ?? '',
      address: json['address'] ?? '',
      token: json['token'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'blood_type': bloodType,
      'address': address,
      'token': token,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}