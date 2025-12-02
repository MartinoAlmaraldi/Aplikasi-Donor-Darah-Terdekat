import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/blood_bank.dart';
import '../services/api_service.dart';

class BloodBankController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var bloodBanks = <BloodBank>[].obs;
  var nearbyBloodBanks = <BloodBank>[].obs;
  Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    loadBloodBanks();
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Info', 'GPS tidak aktif');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Info', 'Izin lokasi ditolak');
          return;
        }
      }

      currentPosition.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> loadBloodBanks() async {
    try {
      isLoading.value = true;

      await getCurrentLocation();

      final data = await _apiService.getBloodBanks(
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
      );

      bloodBanks.value = data;
      nearbyBloodBanks.value = data.take(3).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data PMI: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBloodBanks() async {
    await loadBloodBanks();
    Get.snackbar(
      'Info',
      'Data berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}