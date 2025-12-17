// ==================== BLOOD BANK MODEL ====================
// Model untuk data PMI dan lokasi donor darah.
// Menyimpan informasi PMI beserta jarak dari lokasi user.

class BloodBank {
  // ID unik dari database.
  final int? id;

  // Nama PMI atau rumah sakit.
  final String name;

  // Alamat lengkap lokasi donor.
  final String address;

  // Nomor telepon yang bisa dihubungi.
  final String phone;

  // Koordinat GPS latitude.
  final double latitude;

  // Koordinat GPS longitude.
  final double longitude;

  // Jam operasional (contoh: "Senin-Jumat: 08:00-16:00").
  final String operatingHours;

  // Jarak dari lokasi user dalam km (optional).
  final double? distance;

  // Tanggal data dibuat.
  final DateTime? createdAt;

  BloodBank({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.operatingHours,
    this.distance,
    this.createdAt,
  });

  // Parse JSON dari API menjadi object BloodBank.
  // Handle berbagai tipe data koordinat (string/int/double).
  factory BloodBank.fromJson(Map<String, dynamic> json) {
    return BloodBank(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      // Parse koordinat dari berbagai tipe data.
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      operatingHours: json['operating_hours'] ?? '',
      // Distance optional, bisa null jika GPS tidak aktif.
      distance: json['distance'] != null ? _parseDouble(json['distance']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Helper method untuk parsing double dari string/int/double.
  // Return 0.0 jika parsing gagal atau value null.
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Convert object menjadi JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'operating_hours': operatingHours,
      'distance': distance,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}