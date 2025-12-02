import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      // Try to get from API first
      final apiUser = await _apiService.getProfile();

      if (apiUser != null) {
        user.value = apiUser;
        await _authService.updateUser(apiUser);
      } else {
        // Fallback to local storage
        user.value = await _authService.getUser();
      }
    } catch (e) {
      // If API fails, get from local
      user.value = await _authService.getUser();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;

      final result = await _apiService.updateProfile(userData);

      if (result['success']) {
        await loadProfile();
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
}