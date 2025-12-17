// ==================== USER MODEL ====================
// Model untuk data user aplikasi.
// Menyimpan informasi user dan token autentikasi.

class User {
  // ID unik dari database.
  final int? id;

  // Nama lengkap user.
  final String name;

  // Email untuk login.
  final String email;

  // Nomor telepon.
  final String phone;

  // Golongan darah (A+, A-, B+, B-, AB+, AB-, O+, O-).
  final String bloodType;

  // Alamat lengkap user.
  final String address;

  // Token autentikasi dari API (optional).
  final String? token;

  // Tanggal akun dibuat.
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

  // Parse JSON dari API menjadi object User.
  // Set default empty string untuk field yang mungkin null.
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

  // Convert object menjadi JSON untuk dikirim ke API atau local storage.
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