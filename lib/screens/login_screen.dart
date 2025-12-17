import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';

// Menampilkan UI dan menangani input untuk proses login pengguna.
// Widget ini bersifat StatelessWidget karena state dikelola oleh GetX.
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- CONTROLLER & STATE INITIALIZATION ---
    // Mengambil instance AuthController yang sudah ada, untuk mengakses logika otentikasi.
    final authController = Get.find<AuthController>();
    // GlobalKey untuk mengidentifikasi dan mengelola state dari widget Form.
    final formKey = GlobalKey<FormState>();
    // Controller untuk mengambil nilai dari setiap field teks.
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    // State reaktif (.obs) untuk mengontrol visibilitas password (apakah teks disembunyikan).
    final obscurePassword = true.obs;

    // Kerangka utama halaman.
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea memastikan konten tidak tumpang tindih dengan elemen sistem (misal: notch).
      body: SafeArea(
        // Memastikan konten bisa di-scroll pada layar kecil atau saat keyboard muncul.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Widget Form digunakan untuk mengelompokkan dan memvalidasi field input.
          child: Form(
            key: formKey, // Menghubungkan Form ini dengan GlobalKey-nya.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                // Logo & Title Section
                Center(
                  child: Column(
                    children: [
                      // Container untuk visual logo aplikasi.
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          // Efek gradasi warna sesuai tema aplikasi.
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          // Membuat sudut container menjadi lebih membulat.
                          borderRadius: BorderRadius.circular(30),
                          // Menambahkan efek bayangan untuk kesan mendalam (depth).
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        // Ikon utama di tengah container logo.
                        child: const Icon(
                          Icons.water_drop_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Teks judul utama aplikasi.
                      const Text(
                        'Donor Darah',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                          letterSpacing: -1, // Mengurangi spasi antar huruf agar lebih rapat.
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Teks sub-judul atau tagline.
                      Text(
                        'Masuk untuk melanjutkan',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Email Field
                TextFormField(
                  controller: emailController, // Menghubungkan field dengan controller-nya.
                  keyboardType: TextInputType.emailAddress, // Menampilkan keyboard khusus email.
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600], size: 22),
                    filled: true, // Mengaktifkan warna latar belakang.
                    fillColor: Colors.grey[50], // Warna latar belakang field.
                    // Mengatur style border untuk setiap state (normal, fokus, error).
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), // Border dasar.
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!, width: 1)), // Border saat field aktif.
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE53935), width: 2)), // Border saat field di-fokus (diklik).
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red, width: 1)), // Border saat terjadi error validasi.
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding di dalam field.
                  ),
                  // Fungsi validator yang dipanggil saat form divalidasi.
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),
                // Password Field
                // Dibungkus Obx agar UI (ikon mata) otomatis update saat state `obscurePassword` berubah.
                Obx(() => TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword.value, // Visibilitas teks dikontrol oleh state reaktif.
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600], size: 22),
                    // Ikon di akhir field (suffix) untuk mengubah visibilitas password.
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Ikon berubah berdasarkan state: mata tertutup jika obscure, terbuka jika tidak.
                        obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      // Membalik nilai state saat tombol ikon ditekan.
                      onPressed: () => obscurePassword.value = !obscurePassword.value,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!, width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE53935), width: 2)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red, width: 1)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  validator: Validators.validatePassword,
                )),
                const SizedBox(height: 32),
                // Login Button
                // Dibungkus Obx agar tombol bisa menampilkan status loading dari controller.
                Obx(() => CustomButton(
                  text: 'Masuk',
                  onPressed: () {
                    // Validasi form sebelum melanjutkan. `validate()` akan memicu semua validator di field.
                    if (formKey.currentState!.validate()) {
                      // Jika valid, panggil method login dari controller dengan data dari field.
                      // `.trim()` digunakan untuk menghapus spasi di awal/akhir input.
                      authController.login(
                        emailController.text.trim(),
                        passwordController.text,
                      );
                    }
                  },
                  // Melewatkan status loading ke CustomButton agar dapat menampilkan indikator loading.
                  isLoading: authController.isLoading.value,
                  icon: Icons.arrow_forward_rounded,
                )),
                const SizedBox(height: 24),
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    // Menggunakan GestureDetector untuk membuat teks bisa diklik.
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'), // Navigasi ke halaman register menggunakan GetX.
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

