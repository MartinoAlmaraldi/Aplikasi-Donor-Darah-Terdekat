class BloodBank {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String operatingHours;
  final double? distance; // jarak dari lokasi user (km)
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
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      operatingHours: json['operating_hours'] ?? '',
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
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