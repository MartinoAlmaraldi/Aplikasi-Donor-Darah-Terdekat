import 'package:get/get.dart';
import '../models/donation_history.dart';
import '../services/api_service.dart';

class DonationController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var donations = <DonationHistory>[].obs;
  var totalDonations = 0.obs;
  var totalBloodDonated = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDonationHistory();
  }

  Future<void> loadDonationHistory() async {
    try {
      isLoading.value = true;

      final data = await _apiService.getDonationHistory();

      donations.value = data;
      calculateStats();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat donor: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateStats() {
    totalDonations.value = donations.length;
    totalBloodDonated.value = donations
        .where((d) => d.status == 'completed')
        .fold<int>(0, (sum, d) => sum + d.quantity);
  }

  Future<void> createDonation(Map<String, dynamic> donationData) async {
    try {
      isLoading.value = true;

      final result = await _apiService.createDonation(donationData);

      if (result['success']) {
        await loadDonationHistory();
        Get.back();
        Get.snackbar(
          'Sukses',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDonations() async {
    await loadDonationHistory();
  }
}