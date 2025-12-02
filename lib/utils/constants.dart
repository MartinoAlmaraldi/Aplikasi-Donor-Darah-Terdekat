class AppConstants {
  // Base URL - ganti sesuai kebutuhan
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // untuk emulator
  // static const String baseUrl = 'http://192.168.1.100:3000/api'; // untuk device

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String bloodBanksEndpoint = '/blood-banks';
  static const String donationHistoryEndpoint = '/donations';
  static const String profileEndpoint = '/users/profile';

  // Blood Types
  static const List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  // Dummy Mode - Set true untuk testing tanpa backend
  static const bool useDummyData = true;  // ← PENTING: Set ini jadi true untuk testing
}