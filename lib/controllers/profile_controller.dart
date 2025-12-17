// ==================== PROFILE CONTROLLER ====================
// Controller untuk mengelola data profil user.
// Handle load dan update profile dengan fallback ke local storage.

import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class ProfileController extends GetxController {
  // Instance AuthService untuk akses local storage.
  final AuthService _authService = AuthService();

  // Instance ApiService untuk komunikasi dengan backend.
  final ApiService _apiService = ApiService();

  // --- OBSERVABLE VARIABLES ---
  // Observable boolean untuk status loading saat fetch/update data.
  var isLoading = false.obs;

  // Observable User object berisi data profil user.
  // Null jika belum di-load, diisi setelah loadProfile() dipanggil.
  Rx<User?> user = Rx<User?>(null);

  // --- LIFECYCLE METHODS ---
  @override
  void onInit() {
    super.onInit(); // Initialize parent class.
    loadProfile(); // Load profil user saat controller dibuat.
  }

  // --- LOAD PROFILE ---
  // Method untuk load data profil user.
  // Try dari API first, fallback ke local storage jika gagal.
  Future<void> loadProfile() async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Try ambil data profil dari API terlebih dahulu.
      final apiUser = await _apiService.getProfile();

      // Jika berhasil dapat data dari API.
      if (apiUser != null) {
        // Set user dari response API.
        user.value = apiUser;

        // Update local storage dengan data terbaru dari API.
        await _authService.updateUser(apiUser);
      } else {
        // Jika API gagal atau return null, fallback ke local storage.
        user.value = await _authService.getUser();
      }
    } catch (e) {
      // Catch exception jika API error.
      // Fallback ke local storage untuk get data user.
      user.value = await _authService.getUser();
    } finally {
      // Set loading state menjadi false setelah proses selesai.
      isLoading.value = false;
    }
  }

  // --- UPDATE PROFILE ---
  // Method untuk update data profil user.
  // Parameter userData berisi: name, phone, blood_type, address (field yang bisa diupdate).
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Put data ke API untuk update profile.
      final result = await _apiService.updateProfile(userData);

      // Jika update berhasil.
      if (result['success']) {
        // Reload profile untuk get data terbaru.
        await loadProfile();

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
        // Jika update gagal, tampilkan error message.
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
}