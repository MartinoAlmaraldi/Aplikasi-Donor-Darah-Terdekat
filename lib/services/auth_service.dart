// ==================== AUTH SERVICE ====================
// Service untuk handle local storage autentikasi.
// Menyimpan dan mengambil token serta data user dari SharedPreferences.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // Key untuk simpan token di SharedPreferences.
  static const String _tokenKey = 'auth_token';

  // Key untuk simpan data user di SharedPreferences.
  static const String _userKey = 'user_data';

  // Simpan token dan data user ke local storage.
  // Return true jika berhasil, false jika error.
  Future<bool> saveAuthData(String token, User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Simpan token sebagai string.
      await prefs.setString(_tokenKey, token);
      // Simpan user sebagai JSON string.
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      return true;
    } catch (e) {
      print('Error saving auth data: $e');
      return false;
    }
  }

  // Ambil token dari local storage.
  // Return token string atau null jika tidak ada.
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Ambil data user dari local storage.
  // Parse JSON string menjadi User object.
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Cek apakah user sudah login.
  // Return true jika token ada dan tidak kosong.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout: hapus token dan data user dari storage.
  // Return true jika berhasil, false jika error.
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      return true;
    } catch (e) {
      print('Error logging out: $e');
      return false;
    }
  }

  // Update data user di local storage.
  // Dipakai setelah update profile dari API.
  Future<bool> updateUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }
}