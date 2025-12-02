import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/donation_controller.dart';
import '../widgets/donation_card.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DonationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Donor'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.donations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada riwayat donor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshDonations(),
          child: Column(
            children: [
              _buildStatsCard(controller),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.donations.length,
                  itemBuilder: (context, index) {
                    return DonationCard(donation: controller.donations[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsCard(DonationController controller) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total Donor',
                controller.totalDonations.value.toString(),
                Icons.volunteer_activism,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            Expanded(
              child: _buildStatItem(
                'Total Darah',
                '${controller.totalBloodDonated.value} ml',
                Icons.water_drop,
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE53935)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}