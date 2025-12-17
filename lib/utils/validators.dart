// ==================== VALIDATORS ====================
// Helper class untuk validasi input form.
// Return error message jika tidak valid, null jika valid.

class Validators {
  // Validasi format email dengan regex.
  // Return: error message atau null jika valid.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Regex untuk validasi format email standar.
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password minimal 6 karakter.
  // Return: error message atau null jika valid.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Validasi nomor telepon minimal 10 digit.
  // Return: error message atau null jika valid.
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (value.length < 10) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  // Validasi field required (tidak boleh kosong).
  // Parameter fieldName untuk custom error message.
  // Return: error message atau null jika valid.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }
}