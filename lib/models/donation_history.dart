// ==================== DONATION HISTORY MODEL ====================
// Model untuk riwayat donor darah user.
// Menyimpan data donor beserta status dan warna badge.

import 'package:flutter/material.dart';

class DonationHistory {
  // ID unik dari database.
  final int? id;

  // ID user yang melakukan donor.
  final int userId;

  // ID PMI tempat donor.
  final int bloodBankId;

  // Nama PMI untuk ditampilkan.
  final String bloodBankName;

  // Tanggal jadwal donor.
  final DateTime donationDate;

  // Golongan darah yang didonorkan.
  final String bloodType;

  // Volume darah dalam ml (biasanya 350ml).
  final int quantity;

  // Status: pending, approved, rejected, completed.
  final String status;

  // Catatan tambahan (optional).
  final String? notes;

  // Tanggal data dibuat.
  final DateTime? createdAt;

  DonationHistory({
    this.id,
    required this.userId,
    required this.bloodBankId,
    required this.bloodBankName,
    required this.donationDate,
    required this.bloodType,
    required this.quantity,
    required this.status,
    this.notes,
    this.createdAt,
  });

  // Parse JSON dari API menjadi object DonationHistory.
  // Set default value untuk field yang mungkin null.
  factory DonationHistory.fromJson(Map<String, dynamic> json) {
    return DonationHistory(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      bloodBankId: json['blood_bank_id'] ?? 0,
      bloodBankName: json['blood_bank_name'] ?? '',
      donationDate: json['donation_date'] != null
          ? DateTime.parse(json['donation_date'])
          : DateTime.now(),
      bloodType: json['blood_type'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Convert object menjadi JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'blood_bank_id': bloodBankId,
      'blood_bank_name': bloodBankName,
      'donation_date': donationDate.toIso8601String(),
      'blood_type': bloodType,
      'quantity': quantity,
      'status': status,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Return warna badge sesuai status.
  // completed: hijau, approved: biru, pending: oranye, rejected: merah.
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'approved':
        return const Color(0xFF2196F3);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'rejected':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  // Return text status dalam Bahasa Indonesia.
  String getStatusText() {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Selesai';
      case 'approved':
        return 'Disetujui';
      case 'pending':
        return 'Menunggu';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }
}