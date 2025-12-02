import 'package:flutter/material.dart';

class DonationHistory {
  final int? id;
  final int userId;
  final int bloodBankId;
  final String bloodBankName;
  final DateTime donationDate;
  final String bloodType;
  final int quantity; // dalam ml
  final String status; // pending, approved, rejected, completed
  final String? notes;
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