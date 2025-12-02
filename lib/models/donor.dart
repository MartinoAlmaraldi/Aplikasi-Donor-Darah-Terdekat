class DonorStats {
  final int totalDonations;
  final int totalBloodDonated; // dalam ml
  final DateTime? lastDonation;
  final String bloodType;

  DonorStats({
    required this.totalDonations,
    required this.totalBloodDonated,
    this.lastDonation,
    required this.bloodType,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'total_donations': totalDonations,
      'total_blood_donated': totalBloodDonated,
      'last_donation': lastDonation?.toIso8601String(),
      'blood_type': bloodType,
    };
  }
}