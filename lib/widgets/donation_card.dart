// ==================== DONATION CARD WIDGET ====================
// Widget card untuk menampilkan item riwayat donor.
// Dengan badge status berwarna dan info lengkap donor.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/donation_history.dart';

class DonationCard extends StatelessWidget {
  // Data riwayat donor yang akan ditampilkan.
  final DonationHistory donation;

  const DonationCard({
    Key? key,
    required this.donation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: nama PMI dan badge status.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nama PMI (expandable untuk text panjang).
                Expanded(
                  child: Text(
                    donation.bloodBankName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Badge status dengan warna dinamis.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    // Warna sesuai status (dari model).
                    color: donation.getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    // Text status dalam Bahasa Indonesia.
                    donation.getStatusText(),
                    style: TextStyle(
                      color: donation.getStatusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info donor: tanggal, golongan darah, volume.
            Row(
              children: [
                // Tanggal donor.
                _buildInfoItem(
                  Icons.calendar_today,
                  DateFormat('dd MMM yyyy').format(donation.donationDate),
                ),
                const SizedBox(width: 16),
                // Golongan darah.
                _buildInfoItem(
                  Icons.water_drop,
                  donation.bloodType,
                ),
                const SizedBox(width: 16),
                // Volume darah dalam ml.
                _buildInfoItem(
                  Icons.local_drink,
                  '${donation.quantity} ml',
                ),
              ],
            ),
            // Catatan tambahan (jika ada).
            if (donation.notes != null && donation.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              // Container untuk notes dengan background abu.
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        donation.notes!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat item info dengan icon dan text.
  // Dipakai untuk tanggal, golongan darah, dan volume.
  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}