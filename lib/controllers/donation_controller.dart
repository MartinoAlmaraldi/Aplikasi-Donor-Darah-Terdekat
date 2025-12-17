// ==================== DONATION CONTROLLER ====================
// Controller untuk mengelola riwayat donor dan statistik donor user.
// Handle create donation request dan calculate stats.

import 'package:get/get.dart';
import '../models/donation_history.dart';
import '../services/api_service.dart';

class DonationController extends GetxController {
  // Instance ApiService untuk komunikasi dengan backend.
  final ApiService _apiService = ApiService();

  // --- OBSERVABLE VARIABLES ---
  // Observable boolean untuk status loading saat fetch data.
  var isLoading = false.obs;

  // Observable list berisi semua riwayat donor user.
  // Diisi setelah fetch dari API, sorted by date descending.
  var donations = <DonationHistory>[].obs;

  // Observable integer berisi total jumlah donor yang pernah dilakukan.
  // Di-calculate dari length donations list.
  var totalDonations = 0.obs;

  // Observable integer berisi total volume darah yang didonorkan (ml).
  // Di-calculate dari sum quantity dengan status completed.
  var totalBloodDonated = 0.obs;

  // --- LIFECYCLE METHODS ---
  @override
  void onInit() {
    super.onInit(); // Initialize parent class.
    loadDonationHistory(); // Load riwayat donor saat controller dibuat.
  }

  // --- LOAD DONATION HISTORY ---
  // Method untuk load riwayat donor dari API.
  // Calculate statistics setelah data berhasil di-load.
  Future<void> loadDonationHistory() async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Fetch riwayat donor dari API.
      // API akan filter berdasarkan user_id yang sedang login.
      final data = await _apiService.getDonationHistory();

      // Set donations list dengan data dari API.
      donations.value = data;

      // Hitung statistik donor setelah data di-load.
      calculateStats();
    } catch (e) {
      // Catch exception dan tampilkan error snackbar.
      Get.snackbar('Error', 'Gagal memuat riwayat donor: $e');
    } finally {
      // Set loading state menjadi false setelah proses selesai.
      isLoading.value = false;
    }
  }

  // --- CALCULATE STATS ---
  // Method untuk hitung statistik donor user.
  // Menghitung total donor dan total volume darah.
  void calculateStats() {
    // Hitung total donor dari panjang list donations.
    totalDonations.value = donations.length;

    // Hitung total volume darah yang sudah completed.
    // Filter hanya status completed, lalu sum quantity-nya.
    totalBloodDonated.value = donations
        .where((d) => d.status == 'completed') // Filter completed saja.
        .fold<int>(0, (sum, d) => sum + d.quantity); // Sum quantity.
  }

  // --- CREATE DONATION ---
  // Method untuk membuat request donor baru.
  // Parameter donationData berisi: blood_bank_id, donation_date, blood_type, quantity, notes.
  Future<void> createDonation(Map<String, dynamic> donationData) async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Post data donation ke API.
      final result = await _apiService.createDonation(donationData);

      // Jika create donation berhasil.
      if (result['success']) {
        // Reload donation history untuk update list.
        await loadDonationHistory();

        // Kembali ke screen sebelumnya.
        Get.back();

        // Tampilkan snackbar sukses.
        Get.snackbar(
          'Sukses',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        // Jika create donation gagal, tampilkan error message.
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      // Catch exception dan tampilkan error detail.
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      // Set loading state menjadi false setelah proses selesai.
      isLoading.value = false;
    }
  }

  // --- REFRESH DONATIONS ---
  // Method untuk refresh riwayat donor.
  // Dipanggil saat user pull to refresh.
  Future<void> refreshDonations() async {
    // Reload semua riwayat donor dari awal.
    await loadDonationHistory();
  }
}