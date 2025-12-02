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

// Binding untuk Dependency Injection
import 'controllers/auth_controller.dart';
import 'controllers/blood_bank_controller.dart';
import 'controllers/donation_controller.dart';
import 'controllers/profile_controller.dart';

void main() {
  // Initialize dependencies
  Get.put(AuthController());

  runApp(const DonorDarahApp());
}

class DonorDarahApp extends StatelessWidget {
  const DonorDarahApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // Ganti MaterialApp dengan GetMaterialApp
      title: 'Donor Darah Terdekat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFE53935),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE53935),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
      initialRoute: '/',
      getPages: [  // Ganti routes dengan getPages
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen(), binding: HomeBinding()),
        GetPage(name: '/blood-banks', page: () => const BloodBankListScreen(), binding: BloodBankBinding()),
        GetPage(name: '/blood-bank-detail', page: () => const BloodBankDetailScreen()),
        GetPage(name: '/donation-history', page: () => const DonationHistoryScreen(), binding: DonationBinding()),
        GetPage(name: '/profile', page: () => const ProfileScreen(), binding: ProfileBinding()),
      ],
    );
  }
}

// Bindings untuk lazy loading controllers
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BloodBankController());
  }
}

class BloodBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BloodBankController());
  }
}

class DonationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DonationController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}