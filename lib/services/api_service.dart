// ==================== API SERVICE ====================
// Service untuk komunikasi dengan backend API.
// Handle semua HTTP request (login, register, CRUD) dengan fallback dummy data.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/blood_bank.dart';
import '../models/donation_history.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class ApiService {
  // Instance AuthService untuk ambil token dari storage.
  final AuthService _authService = AuthService();

  // Helper untuk buat headers dengan Authorization token.
  // Dipakai di semua request yang butuh autentikasi.
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      // Tambahkan Bearer token jika ada.
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ==================== LOGIN ====================
  // Login user dengan email dan password.
  // Return: {success, user, token, message}
  // Mode dummy: langsung success tanpa API call.
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Jika mode dummy aktif, langsung return dummy success.
    if (AppConstants.useDummyData) {
      // Simulasi loading 1 detik.
      await Future.delayed(const Duration(seconds: 1));

      // Buat dummy user untuk testing.
      final dummyUser = User(
        id: 1,
        name: 'Ahmad Banjarbaru',
        email: email,
        phone: '081234567890',
        bloodType: 'A+',
        address: 'Jl. Pramuka No. 123, Loktabat, Banjarbaru, Kalimantan Selatan',
      );

      // Generate dummy token.
      final token = 'dummy_token_12345';

      // Simpan ke local storage.
      await _authService.saveAuthData(token, dummyUser);

      return {
        'success': true,
        'user': dummyUser,
        'token': token,
        'message': 'Login berhasil (Dummy Mode)',
      };
    }

    // Mode API: kirim request ke backend.
    try {
      print('🔵 Attempting login to: ${AppConstants.baseUrl}${AppConstants.loginEndpoint}');

      // POST request ke endpoint login.
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout - pastikan backend sedang running');
        },
      );

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response body: ${response.body}');

      // Jika status 200 (OK), parse response.
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Validasi struktur response.
        if (data == null || data['data'] == null) {
          print('❌ Invalid response structure: $data');
          return {
            'success': false,
            'message': 'Response dari server tidak valid',
          };
        }

        // Ambil user data dan token dari response.
        final userData = data['data']['user'];
        final token = data['data']['token'];

        // Validasi user data dan token tidak null.
        if (userData == null || token == null) {
          print('❌ Missing user data or token');
          return {
            'success': false,
            'message': 'Data login tidak lengkap',
          };
        }

        // Parse JSON menjadi User object.
        final user = User.fromJson(userData);

        // Simpan token dan user ke local storage.
        await _authService.saveAuthData(token, user);

        return {
          'success': true,
          'user': user,
          'message': 'Login berhasil',
        };
      } else {
        // Jika status bukan 200, parse error message.
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      // Catch semua error (network, timeout, parsing).
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  // ==================== REGISTER ====================
  // Register user baru dengan data lengkap.
  // Parameter: {name, email, phone, password, blood_type, address}
  // Return: {success, message}
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    // Jika mode dummy aktif.
    if (AppConstants.useDummyData) {
      await Future.delayed(const Duration(seconds: 1));

      return {
        'success': true,
        'message': 'Registrasi berhasil (Dummy Mode)',
      };
    }

    // Mode API: kirim request ke backend.
    try {
      print('🔵 Attempting register to: ${AppConstants.baseUrl}${AppConstants.registerEndpoint}');

      // POST request ke endpoint register.
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.registerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response body: ${response.body}');

      // Jika status 201 (Created), registrasi berhasil.
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registrasi berhasil',
        };
      } else {
        // Parse error message dari server.
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      print('❌ Register error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  // ==================== GET BLOOD BANKS ====================
  // Ambil semua data PMI dari API.
  // Parameter: latitude, longitude (optional untuk sorting by distance).
  // Return: List<BloodBank> sorted by distance.
  Future<List<BloodBank>> getBloodBanks({double? latitude, double? longitude}) async {
    // Jika mode dummy aktif.
    if (AppConstants.useDummyData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _getDummyBloodBanks();
    }

    // Mode API: fetch dari backend.
    try {
      // Build URL dengan query parameter lat/lng jika ada.
      String url = '${AppConstants.baseUrl}${AppConstants.bloodBanksEndpoint}';

      if (latitude != null && longitude != null) {
        url += '?lat=$latitude&lng=$longitude';
      }

      print('🔵 Fetching blood banks from: $url');

      // GET request ke endpoint blood banks.
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      print('🔵 Response status: ${response.statusCode}');

      // Jika status 200, parse list blood banks.
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List bloodBanksList = data['data'] ?? [];
        // Map setiap item menjadi BloodBank object.
        return bloodBanksList.map((json) => BloodBank.fromJson(json)).toList();
      } else {
        print('❌ Failed to load blood banks: ${response.statusCode}');
        // Fallback ke dummy data jika API gagal.
        return _getDummyBloodBanks();
      }
    } catch (e) {
      print('❌ Get blood banks error: $e');
      // Fallback ke dummy data jika error.
      return _getDummyBloodBanks();
    }
  }

  // ==================== GET DONATION HISTORY ====================
  // Ambil riwayat donor user yang sedang login.
  // Return: List<DonationHistory> sorted by date descending.
  Future<List<DonationHistory>> getDonationHistory() async {
    // Jika mode dummy aktif.
    if (AppConstants.useDummyData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _getDummyDonationHistory();
    }

    // Mode API: fetch dari backend.
    try {
      // Ambil user ID dari local storage.
      final user = await _authService.getUser();
      if (user == null || user.id == null) {
        print('❌ No user found');
        return [];
      }

      // Build URL dengan user ID.
      final url = '${AppConstants.baseUrl}/donations/user/${user.id}';
      print('🔵 Fetching donation history from: $url');

      // GET request ke endpoint donation history.
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      print('🔵 Response status: ${response.statusCode}');

      // Jika status 200, parse list donations.
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List historyList = data['data'] ?? [];
        // Map setiap item menjadi DonationHistory object.
        return historyList.map((json) => DonationHistory.fromJson(json)).toList();
      } else {
        print('❌ Failed to load donation history: ${response.statusCode}');
        // Fallback ke dummy data.
        return _getDummyDonationHistory();
      }
    } catch (e) {
      print('❌ Get donation history error: $e');
      // Fallback ke dummy data.
      return _getDummyDonationHistory();
    }
  }

  // ==================== CREATE DONATION ====================
  // Buat request donor baru.
  // Parameter: {blood_bank_id, donation_date, blood_type, quantity, notes}
  // Return: {success, message}
  Future<Map<String, dynamic>> createDonation(Map<String, dynamic> donationData) async {
    // Jika mode dummy aktif.
    if (AppConstants.useDummyData) {
      await Future.delayed(const Duration(seconds: 1));

      return {
        'success': true,
        'message': 'Permintaan donor berhasil dibuat (Dummy Mode)',
      };
    }

    // Mode API: kirim request ke backend.
    try {
      print('🔵 Creating donation: $donationData');

      // POST request ke endpoint donations.
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.donationHistoryEndpoint}'),
        headers: await _getHeaders(),
        body: jsonEncode(donationData),
      ).timeout(const Duration(seconds: 10));

      print('🔵 Response status: ${response.statusCode}');

      // Jika status 201 (Created), berhasil buat donation.
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Permintaan donor berhasil dibuat',
        };
      } else {
        // Parse error message dari server.
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal membuat permintaan',
        };
      }
    } catch (e) {
      print('❌ Create donation error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  // ==================== GET PROFILE ====================
  // Ambil data profil user dari API.
  // Return: User object atau null jika gagal.
  Future<User?> getProfile() async {
    // Jika mode dummy aktif.
    if (AppConstants.useDummyData) {
      await Future.delayed(const Duration(milliseconds: 300));
      // Return user dari local storage.
      return await _authService.getUser();
    }

    // Mode API: fetch dari backend.
    try {
      // Ambil user ID dari local storage.
      final user = await _authService.getUser();
      if (user == null || user.id == null) {
        return null;
      }

      // Build URL dengan user ID.
      final url = '${AppConstants.baseUrl}/users/profile/${user.id}';
      print('🔵 Fetching profile from: $url');

      // GET request ke endpoint profile.
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      print('🔵 Response status: ${response.statusCode}');

      // Jika status 200, parse User object.
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print('❌ Get profile error: $e');
      return null;
    }
  }

  // ==================== UPDATE PROFILE ====================
  // Update data profil user.
  // Parameter: {name, phone, blood_type, address}
  // Return: {success, message}
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> userData) async {
    // Jika mode dummy aktif.
    if (AppConstants.useDummyData) {
      await Future.delayed(const Duration(seconds: 1));

      return {
        'success': true,
        'message': 'Profile berhasil diupdate (Dummy Mode)',
      };
    }

    // Mode API: kirim request ke backend.
    try {
      // Ambil user ID dari local storage.
      final user = await _authService.getUser();
      if (user == null || user.id == null) {
        return {
          'success': false,
          'message': 'User tidak ditemukan',
        };
      }

      // Build URL dengan user ID.
      final url = '${AppConstants.baseUrl}/users/profile/${user.id}';
      print('🔵 Updating profile: $url');

      // PUT request ke endpoint profile.
      final response = await http.put(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: jsonEncode(userData),
      ).timeout(const Duration(seconds: 10));

      print('🔵 Response status: ${response.statusCode}');

      // Jika status 200, update berhasil.
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Profile berhasil diupdate',
        };
      } else {
        // Parse error message dari server.
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal update profile',
        };
      }
    } catch (e) {
      print('❌ Update profile error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  // ==================== DUMMY DATA ====================
  // Data dummy untuk testing tanpa backend.

  // Dummy data: 5 lokasi PMI di sekitar Banjarbaru.
  List<BloodBank> _getDummyBloodBanks() {
    return [
      BloodBank(
        id: 1,
        name: 'PMI Kota Banjarbaru',
        address: 'Jl. Jenderal Sudirman No.1, Loktabat Utara, Banjarbaru',
        phone: '0511-4774090',
        latitude: -3.4543,
        longitude: 114.8417,
        operatingHours: 'Senin-Jumat: 08:00-16:00, Sabtu: 08:00-12:00',
        distance: 1.2,
      ),
      BloodBank(
        id: 2,
        name: 'RSUD Banjarbaru',
        address: 'Jl. Panglima Batur Barat No.4A, Banjarbaru',
        phone: '0511-4772150',
        latitude: -3.4625,
        longitude: 114.8372,
        operatingHours: '24 Jam (Unit Transfusi Darah)',
        distance: 2.5,
      ),
      BloodBank(
        id: 3,
        name: 'RS Islam Banjarbaru',
        address: 'Jl. A. Yani KM 36, Landasan Ulin, Banjarbaru',
        phone: '0511-4774400',
        latitude: -3.4398,
        longitude: 114.8234,
        operatingHours: 'Senin-Jumat: 08:00-20:00',
        distance: 3.8,
      ),
      BloodBank(
        id: 4,
        name: 'RS Ansyari Saleh Banjarmasin',
        address: 'Jl. Brig Jend. H. Hasan Basry, Banjarmasin (Dekat Banjarbaru)',
        phone: '0511-3252180',
        latitude: -3.3189,
        longitude: 114.5897,
        operatingHours: '24 Jam',
        distance: 15.2,
      ),
      BloodBank(
        id: 5,
        name: 'RS Bhayangkara Banjarbaru',
        address: 'Jl. Ahmad Yani KM 35, Banjarbaru',
        phone: '0511-4774455',
        latitude: -3.4507,
        longitude: 114.8295,
        operatingHours: 'Senin-Sabtu: 07:00-19:00',
        distance: 4.1,
      ),
    ];
  }

  // Dummy data: 3 riwayat donor dengan berbagai status.
  List<DonationHistory> _getDummyDonationHistory() {
    return [
      DonationHistory(
        id: 1,
        userId: 1,
        bloodBankId: 1,
        bloodBankName: 'PMI Kota Banjarbaru',
        donationDate: DateTime.now().subtract(const Duration(days: 90)),
        bloodType: 'A+',
        quantity: 350,
        status: 'completed',
        notes: 'Donor berhasil, kondisi sehat',
      ),
      DonationHistory(
        id: 2,
        userId: 1,
        bloodBankId: 2,
        bloodBankName: 'RSUD Banjarbaru',
        donationDate: DateTime.now().subtract(const Duration(days: 180)),
        bloodType: 'A+',
        quantity: 350,
        status: 'completed',
        notes: 'Donor rutin, tidak ada keluhan',
      ),
      DonationHistory(
        id: 3,
        userId: 1,
        bloodBankId: 1,
        bloodBankName: 'PMI Kota Banjarbaru',
        donationDate: DateTime.now().subtract(const Duration(days: 10)),
        bloodType: 'A+',
        quantity: 350,
        status: 'pending',
        notes: 'Menunggu konfirmasi jadwal',
      ),
    ];
  }
}