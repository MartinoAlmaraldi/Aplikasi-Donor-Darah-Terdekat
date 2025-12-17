// ==================== MAIN APP ====================
// Entry point aplikasi Donor Darah Terdekat.
// Setup GetX routing, theme, dan dependency injection.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/blood_bank_list_screen.dart';
import 'screens/blood_bank_detail_screen.dart';
import 'screens/donation_history_screen.dart';
import 'screens/profile_screen.dart';

// Import controllers untuk dependency injection.
import 'controllers/auth_controller.dart';
import 'controllers/blood_bank_controller.dart';
import 'controllers/donation_controller.dart';
import 'controllers/profile_controller.dart';

void main() {
  // Initialize AuthController sebagai singleton.
  // Dipakai di semua screen untuk cek status login.
  Get.put(AuthController());

  runApp(const DonorDarahApp());
}

class DonorDarahApp extends StatelessWidget {
  const DonorDarahApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp: MaterialApp dengan GetX routing.
    return GetMaterialApp(
      title: 'Donor Darah Terdekat',
      debugShowCheckedModeBanner: false,
      // Theme merah untuk tema donor darah.
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFE53935),
        scaffoldBackgroundColor: Colors.grey[50],
        // AppBar theme dengan warna merah.
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE53935),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // Button theme dengan rounded corners.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // Initial route: splash screen.
      initialRoute: '/',
      // GetX routing dengan lazy loading controllers.
      getPages: [
        // Splash screen tanpa binding (hanya tampilan).
        GetPage(name: '/', page: () => const SplashScreen()),

        // Auth screens tanpa binding (pakai global AuthController).
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),

        // Home screen dengan BloodBankController binding.
        GetPage(name: '/home', page: () => const HomeScreen(), binding: HomeBinding()),

        // Blood bank screens dengan BloodBankController binding.
        GetPage(name: '/blood-banks', page: () => const BloodBankListScreen(), binding: BloodBankBinding()),
        GetPage(name: '/blood-bank-detail', page: () => const BloodBankDetailScreen()),

        // Donation history dengan DonationController binding.
        GetPage(name: '/donation-history', page: () => const DonationHistoryScreen(), binding: DonationBinding()),

        // Profile screen dengan ProfileController binding.
        GetPage(name: '/profile', page: () => const ProfileScreen(), binding: ProfileBinding()),
      ],
    );
  }
}

// ==================== BINDINGS ====================
// Lazy loading controllers per screen untuk efisiensi memory.

// Binding untuk home screen.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load BloodBankController saat home screen dibuka.
    Get.lazyPut(() => BloodBankController());
  }
}

// Binding untuk blood bank list screen.
class BloodBankBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load BloodBankController saat blood bank screen dibuka.
    Get.lazyPut(() => BloodBankController());
  }
}

// Binding untuk donation history screen.
class DonationBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load DonationController saat history screen dibuka.
    Get.lazyPut(() => DonationController());
  }
}

// Binding untuk profile screen.
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load ProfileController saat profile screen dibuka.
    Get.lazyPut(() => ProfileController());
  }
}