// ==================== BLOOD BANK CARD WIDGET ====================
// Widget card untuk menampilkan informasi PMI.
// Dengan tombol telepon dan detail, plus badge jarak.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/blood_bank.dart';

class BloodBankCard extends StatelessWidget {
  // Data PMI yang akan ditampilkan.
  final BloodBank bloodBank;

  // Callback saat card atau tombol detail di-tap.
  final VoidCallback? onTap;

  const BloodBankCard({
    Key? key,
    required this.bloodBank,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: icon + nama + jarak.
              Row(
                children: [
                  // Icon rumah sakit dengan background merah muda.
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Color(0xFFE53935),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nama PMI dan jarak.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bloodBank.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Tampilkan jarak jika ada (GPS aktif).
                        if (bloodBank.distance != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${bloodBank.distance!.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Alamat lengkap.
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bloodBank.address,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Jam operasional.
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bloodBank.operatingHours,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tombol aksi: Telepon dan Detail.
              Row(
                children: [
                  // Tombol telepon (outlined).
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _makePhoneCall(bloodBank.phone),
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text('Telepon'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                        side: const BorderSide(color: Color(0xFFE53935)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tombol detail (filled).
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Detail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk launch phone dialer.
  // Pakai url_launcher untuk buka aplikasi telepon.
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}