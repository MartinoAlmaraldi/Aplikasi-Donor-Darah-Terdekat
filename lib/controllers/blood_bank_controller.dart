// ==================== BLOOD BANK CONTROLLER ====================
// Controller untuk mengelola data PMI dan lokasi donor darah.
// Handle GPS location dan nearby blood banks.

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/blood_bank.dart';
import '../services/api_service.dart';

class BloodBankController extends GetxController {
  // Instance ApiService untuk fetch data PMI dari backend.
  final ApiService _apiService = ApiService();

  // --- OBSERVABLE VARIABLES ---
  // Observable boolean untuk status loading saat fetch data.
  var isLoading = false.obs;

  // Observable list berisi semua data PMI.
  // Diisi setelah fetch dari API, diurutkan berdasarkan jarak.
  var bloodBanks = <BloodBank>[].obs;

  // Observable list berisi 3 PMI terdekat.
  // Digunakan untuk ditampilkan di home screen.
  var nearbyBloodBanks = <BloodBank>[].obs;

  // Observable Position berisi koordinat GPS user saat ini.
  // Null jika GPS belum diambil atau permission ditolak.
  Rx<Position?> currentPosition = Rx<Position?>(null);

  // --- LIFECYCLE METHODS ---
  @override
  void onInit() {
    super.onInit(); // Initialize parent class.
    loadBloodBanks(); // Load data PMI saat controller dibuat.
  }

  // --- GET CURRENT LOCATION ---
  // Method untuk mendapatkan koordinat GPS user.
  // Request permission jika belum diberikan.
  Future<void> getCurrentLocation() async {
    try {
      // Cek apakah GPS service aktif di device.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Jika GPS tidak aktif, tampilkan info.
        Get.snackbar('Info', 'GPS tidak aktif');
        return;
      }

      // Cek permission lokasi sudah diberikan atau belum.
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Jika belum, request permission ke user.
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Jika user menolak permission.
          Get.snackbar('Info', 'Izin lokasi ditolak');
          return;
        }
      }

      // Ambil koordinat GPS user saat ini.
      // Set ke currentPosition untuk digunakan saat fetch PMI.
      currentPosition.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      // Catch exception dan print error ke console.
      print('Error getting location: $e');
    }
  }

  // --- LOAD BLOOD BANKS ---
  // Method untuk load data PMI dari API.
  // Include koordinat user untuk sorting berdasarkan jarak.
  Future<void> loadBloodBanks() async {
    try {
      // Set loading state menjadi true.
      isLoading.value = true;

      // Ambil koordinat GPS user terlebih dahulu.
      await getCurrentLocation();

      // Fetch data PMI dari API dengan parameter lat/lng.
      // Jika currentPosition null, API akan return tanpa sorting jarak.
      final data = await _apiService.getBloodBanks(
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
      );

      // Set list bloodBanks dengan data dari API.
      bloodBanks.value = data;

      // Ambil 3 PMI pertama untuk nearby list (sudah sorted by distance).
      nearbyBloodBanks.value = data.take(3).toList();
    } catch (e) {
      // Catch exception dan tampilkan error snackbar.
      Get.snackbar('Error', 'Gagal memuat data PMI: $e');
    } finally {
      // Set loading state menjadi false setelah proses selesai.
      isLoading.value = false;
    }
  }

  // --- REFRESH BLOOD BANKS ---
  // Method untuk refresh data PMI.
  // Dipanggil saat user pull to refresh.
  Future<void> refreshBloodBanks() async {
    // Reload semua data PMI dari awal.
    await loadBloodBanks();

    // Tampilkan snackbar konfirmasi refresh berhasil.
    Get.snackbar(
      'Info',
      'Data berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}