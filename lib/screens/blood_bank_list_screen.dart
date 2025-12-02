import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/blood_bank_controller.dart';
import '../widgets/blood_bank_card.dart';

class BloodBankListScreen extends StatelessWidget {
  const BloodBankListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BloodBankController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar PMI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Get.snackbar('Info', 'Fitur filter segera hadir');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bloodBanks.isEmpty) {
          return const Center(child: Text('Tidak ada data PMI'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshBloodBanks(),
          child: ListView.builder(
            itemCount: controller.bloodBanks.length,
            itemBuilder: (context, index) {
              final bloodBank = controller.bloodBanks[index];
              return BloodBankCard(
                bloodBank: bloodBank,
                onTap: () {
                  Get.toNamed('/blood-bank-detail', arguments: bloodBank);
                },
              );
            },
          ),
        );
      }),
    );
  }
}