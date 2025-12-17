// ==================== APP CONSTANTS ====================
// Konstanta global untuk konfigurasi aplikasi.
// Berisi base URL API, endpoints, dan setting dummy mode.

class AppConstants {
  // ==================== API CONFIGURATION ====================

  // Base URL untuk API backend.
  // Gunakan 10.0.2.2 untuk Android emulator (localhost).
  // Gunakan IP lokal (192.168.x.x) untuk testing di device fisik.
  static const String baseUrl = 'http://10.0.2.2:3001/api'; // untuk emulator
  // static const String baseUrl = 'http://192.168.1.100:3000/api'; // untuk device

  // ==================== API ENDPOINTS ====================

  // Endpoint untuk login user.
  static const String loginEndpoint = '/auth/login';

  // Endpoint untuk register user baru.
  static const String registerEndpoint = '/auth/register';

  // Endpoint untuk ambil data PMI.
  static const String bloodBanksEndpoint = '/blood-banks';

  // Endpoint untuk CRUD riwayat donor.
  static const String donationHistoryEndpoint = '/donations';

  // Endpoint untuk get/update profile user.
  static const String profileEndpoint = '/users/profile';

  // ==================== BLOOD TYPE OPTIONS ====================

  // List golongan darah yang tersedia.
  // Dipakai di dropdown form register dan update profile.
  static const List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  // ==================== DUMMY MODE ====================

  // Set true untuk testing tanpa backend (dummy data).
  // Set false untuk koneksi ke API backend.
  // PENTING: Ubah ini sesuai kebutuhan development.
  static const bool useDummyData = false;
}