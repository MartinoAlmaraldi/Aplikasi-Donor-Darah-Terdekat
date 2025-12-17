// ==================== AUTH CONTROLLER ====================
// Controller untuk mengelola state dan logic autentikasi aplikasi.
// Menggunakan GetX untuk reactive state management.

import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  // Instance AuthService untuk akses local storage.
  // Handle save/get token dan user data.
  final AuthService _authService = AuthService();

  // Instance ApiService untuk komunikasi dengan backend.
  // Handle HTTP requests ke server.
  final ApiService _apiService = ApiService();

  // --- OBSERVABLE VARIABLES ---
  // Observable boolean untuk status loading saat proses autentikasi.
  // True: proses berjalan, False: proses selesai.
  var isLoading = false.obs;

  // Observable boolean untuk status login user.
  // True: user sudah login, False: belum login atau logout.
  var isLoggedIn = false.obs;

  // Observable User object yang sedang login.
  // Null jika belum ada user, berisi data lengkap setelah login.
  Rx<User?> currentUser = Rx<User?>(null);

  // --- LIFECYCLE METHODS ---
  @override
  void onInit() {
    super.onInit(); // Initialize parent class.
    checkLoginStatus(); // Cek apakah user sudah login.
  }

  // --- CHECK LOGIN STATUS ---
  // Method untuk cek status login dari local storage.
  // Dipanggil saat app pertama kali dibuka.
  Future<void> checkLoginStatus() async {
    // Ambil status login dari AuthService.
    isLoggedIn.value = await _authService.isLoggedIn();

    // Jika sudah login, ambil data user dari storage.
    if (isLoggedIn.value) {
      currentUser.value = await _authService.getUser();
    }
  }

  // --- LOGIN METHOD ---
  // Method untuk proses login user dengan email dan password.
  // Navigate ke home jika berhasil, show error jika gagal.
  Future<void> login(String email, String password) async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Call API login dengan email dan password.
      final result = await _apiService.login(email, password);

      // Jika login berhasil.
      if (result['success']) {
        // Set current user dari response.
        currentUser.value = result['user'];

        // Set status login menjadi true.
        isLoggedIn.value = true;

        // Navigate ke home screen dan clear stack.
        Get.offAllNamed('/home');

        // Tampilkan snackbar sukses.
        Get.snackbar(
          'Sukses',
          'Login berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        // Jika login gagal, tampilkan error message.
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      // Catch exception dan tampilkan error detail.
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      // Set loading state menjadi false setelah proses selesai.
      isLoading.value = false;
    }
  }

  // --- REGISTER METHOD ---
  // Method untuk registrasi user baru.
  // Parameter userData berisi: name, email, phone, password, blood_type, address.
  Future<void> register(Map<String, dynamic> userData) async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Call API register dengan user data.
      final result = await _apiService.register(userData);

      // Jika registrasi berhasil.
      if (result['success']) {
        // Kembali ke screen sebelumnya (login screen).
        Get.back();

        // Tampilkan snackbar sukses dengan instruksi login.
        Get.snackbar(
          'Sukses',
          'Registrasi berhasil! Silakan login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        // Jika registrasi gagal, tampilkan error message dari server.
        Get.snackbar(
          'Error',
          result['message'] ?? 'Registrasi gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      // Catch exception dan tampilkan error detail.
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      // Set loading state menjadi false setelah proses selesai.
      isLoading.value = false;
    }
  }

  // --- LOGOUT METHOD ---
  // Method untuk logout user dari aplikasi.
  // Hapus semua data autentikasi dan navigate ke login screen.
  Future<void> logout() async {
    // Hapus token dan user data dari local storage.
    await _authService.logout();

    // Reset status login menjadi false.
    isLoggedIn.value = false;

    // Reset current user menjadi null.
    currentUser.value = null;

    // Navigate ke login screen dan clear stack.
    Get.offAllNamed('/login');

    // Tampilkan info snackbar logout.
    Get.snackbar(
      'Info',
      'Anda telah keluar',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}