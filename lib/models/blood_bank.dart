class BloodBank {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String operatingHours;
  final double? distance;
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

  factory BloodBank.fromJson(Map<String, dynamic> json) {
    return BloodBank(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      // Perbaikan: Handle berbagai tipe data untuk koordinat
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      operatingHours: json['operating_hours'] ?? '',
      distance: json['distance'] != null ? _parseDouble(json['distance']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Helper method untuk parsing double dari berbagai tipe
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

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