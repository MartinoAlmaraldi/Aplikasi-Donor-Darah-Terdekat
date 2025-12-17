/**
 * ========================================
 * AUTHENTICATION MIDDLEWARE
 * ========================================
 *
 * Middleware untuk memverifikasi JWT token pada setiap request
 *
 * CARA KERJA:
 * 1. Ambil token dari header Authorization
 * 2. Verifikasi token menggunakan JWT_SECRET
 * 3. Jika valid, lanjutkan ke route handler
 * 4. Jika tidak, return error 401/403
 *
 * FORMAT TOKEN:
 * Authorization: Bearer <token>
 *
 * PENGGUNAAN:
 * router.get('/profile', authenticateToken, (req, res) => {
 *   // req.user berisi data dari token
 * });
 */

const jwt = require('jsonwebtoken');

/**
 * Middleware untuk autentikasi JWT token
 * @param {Object} req - Request object dari Express
 * @param {Object} res - Response object dari Express
 * @param {Function} next - Callback untuk melanjutkan ke handler berikutnya
 */
function authenticateToken(req, res, next) {
  // Ambil header Authorization dari request
  const authHeader = req.headers['authorization'];

  // Extract token dari format "Bearer TOKEN"
  // authHeader.split(' ')[0] = "Bearer"
  // authHeader.split(' ')[1] = "TOKEN"
  const token = authHeader && authHeader.split(' ')[1];

  // Jika tidak ada token, tolak request
  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access token tidak ditemukan'
    });
  }

  // Verifikasi token menggunakan JWT_SECRET
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    // Jika token tidak valid atau expired
    if (err) {
      return res.status(403).json({
        success: false,
        message: 'Token tidak valid atau expired'
      });
    }

    // Simpan data user dari token ke req.user
    // Data ini bisa diakses di route handler
    req.user = user;

    // Lanjutkan ke route handler
    next();
  });
}

module.exports = { authenticateToken };