// ==================== DONOR STATS MODEL ====================
// Model untuk statistik donor user.
// Menyimpan total donor, volume darah, dan donor terakhir.

class DonorStats {
  // Total jumlah donor yang pernah dilakukan.
  final int totalDonations;

  // Total volume darah yang didonorkan dalam ml.
  final int totalBloodDonated;

  // Tanggal donor terakhir (optional).
  final DateTime? lastDonation;

  // Golongan darah user.
  final String bloodType;

  DonorStats({
    required this.totalDonations,
    required this.totalBloodDonated,
    this.lastDonation,
    required this.bloodType,
  });

  // Parse JSON dari API menjadi object DonorStats.
  // Set default 0 untuk field yang mungkin null.
  factory DonorStats.fromJson(Map<String, dynamic> json) {
    return DonorStats(
      totalDonations: json['total_donations'] ?? 0,
      totalBloodDonated: json['total_blood_donated'] ?? 0,
      lastDonation: json['last_donation'] != null
          ? DateTime.parse(json['last_donation'])
          : null,
      bloodType: json['blood_type'] ?? '',
    );
  }

  // Convert object menjadi JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() {
    return {
      'total_donations': totalDonations,
      'total_blood_donated': totalBloodDonated,
      'last_donation': lastDonation?.toIso8601String(),
      'blood_type': bloodType,
    };
  }
}