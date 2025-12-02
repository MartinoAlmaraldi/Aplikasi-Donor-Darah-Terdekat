import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  // Observable variables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn.value = await _authService.isLoggedIn();
    if (isLoggedIn.value) {
      currentUser.value = await _authService.getUser();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final result = await _apiService.login(email, password);

      if (result['success']) {
        currentUser.value = result['user'];
        isLoggedIn.value = true;

        Get.offAllNamed('/home');
        Get.snackbar(
          'Sukses',
          'Login berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;

      final result = await _apiService.register(userData);

      if (result['success']) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Registrasi berhasil! Silakan login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Registrasi gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    isLoggedIn.value = false;
    currentUser.value = null;
    Get.offAllNamed('/login');
    Get.snackbar(
      'Info',
      'Anda telah keluar',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
