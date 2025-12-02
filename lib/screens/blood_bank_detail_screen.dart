import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/blood_bank.dart';
import '../controllers/auth_controller.dart';
import '../controllers/donation_controller.dart';
import '../widgets/custom_button.dart';

class BloodBankDetailScreen extends StatelessWidget {
  const BloodBankDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloodBank = Get.arguments as BloodBank;
    final authController = Get.find<AuthController>();
    final isLoading = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail PMI'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(bloodBank),
            const SizedBox(height: 16),
            _buildInfoSection(bloodBank),
            const SizedBox(height: 16),
            _buildContactSection(bloodBank),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Obx(() => CustomButton(
          text: 'Daftar Donor',
          onPressed: () => _createDonationRequest(bloodBank, authController),
          isLoading: isLoading.value,
          icon: Icons.volunteer_activism,
        )),
      ),
    );
  }

  void _createDonationRequest(BloodBank bloodBank, AuthController authController) {
    final user = authController.currentUser.value;
    if (user == null) return;

    Get.defaultDialog(
      title: 'Konfirmasi Donor',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Anda akan membuat permintaan donor di ${bloodBank.name}'),
          const SizedBox(height: 16),
          Text('Golongan Darah: ${user.bloodType}'),
          const SizedBox(height: 8),
          const Text('Jumlah: 350 ml'),
        ],
      ),
      textCancel: 'Batal',
      textConfirm: 'Konfirmasi',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        final donationController = Get.put(DonationController());
        donationController.createDonation({
          'user_id': user.id,
          'blood_bank_id': bloodBank.id,
          'donation_date': DateTime.now().toIso8601String(),
          'blood_type': user.bloodType,
          'quantity': 350,
          'status': 'pending',
        });
      },
    );
  }

  Widget _buildHeader(BloodBank bloodBank) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFE53935),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_hospital,
              size: 40,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bloodBank.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (bloodBank.distance != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        '${bloodBank.distance!.toStringAsFixed(1)} km dari lokasi Anda',
                        style: const TextStyle(
                          color: Colors.white70,
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
    );
  }

  Widget _buildInfoSection(BloodBank bloodBank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(Icons.location_on_outlined, 'Alamat', bloodBank.address),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.access_time, 'Jam Operasional', bloodBank.operatingHours),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFE53935)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BloodBank bloodBank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kontak',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final Uri launchUri = Uri(scheme: 'tel', path: bloodBank.phone);
                    await launchUrl(launchUri);
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Telepon'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFE53935)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final url = 'https://www.google.com/maps/search/?api=1&query=${bloodBank.latitude},${bloodBank.longitude}';
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Petunjuk'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFE53935)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}