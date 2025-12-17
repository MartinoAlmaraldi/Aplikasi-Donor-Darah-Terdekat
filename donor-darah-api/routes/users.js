/**
 * ========================================
 * USERS ROUTES
 * ========================================
 *
 * Endpoint untuk mengelola data user/profil
 *
 * ENDPOINTS:
 * GET /api/users/profile/:id - Get profil user
 * PUT /api/users/profile/:id - Update profil user
 * PUT /api/users/password/:id - Update password
 * GET /api/users/stats/:id - Statistik donor user
 *
 * FITUR:
 * - Update profil (nama, telepon, golongan darah, alamat)
 * - Ganti password dengan verifikasi password lama
 * - Statistik: total donor, total darah, donor terakhir
 *
 * SECURITY:
 * - Password tidak pernah di-return dalam response
 * - Ganti password perlu verifikasi password lama
 * - Email tidak bisa diubah (untuk keamanan)
 */

const express = require('express');
const router = express.Router();
const db = require('../config/database');
const bcrypt = require('bcryptjs');

/**
 * GET /api/users/profile/:id
 * Get profil user
 *
 * Params:
 * - id: ID user
 *
 * Return: Data user tanpa password
 */
router.get('/profile/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Query user, exclude password dari result
    const [users] = await db.query(
      'SELECT id, name, email, phone, blood_type, address, created_at FROM users WHERE id = ?',
      [id]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User tidak ditemukan'
      });
    }

    res.json({
      success: true,
      data: users[0]
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil profil user'
    });
  }
});

/**
 * PUT /api/users/profile/:id
 * Update profil user
 *
 * Params:
 * - id: ID user
 *
 * Body: {
 *   name: string,
 *   phone: string,
 *   blood_type: string,
 *   address: string
 * }
 *
 * Note: Email tidak bisa diubah untuk keamanan
 */
router.put('/profile/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, phone, blood_type, address } = req.body;

    // Validasi: semua field required
    if (!name || !phone || !blood_type || !address) {
      return res.status(400).json({
        success: false,
        message: 'Semua field harus diisi'
      });
    }

    // Update profil user
    await db.query(
      'UPDATE users SET name = ?, phone = ?, blood_type = ?, address = ? WHERE id = ?',
      [name, phone, blood_type, address, id]
    );

    res.json({
      success: true,
      message: 'Profile berhasil diupdate'
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengupdate profile'
    });
  }
});

/**
 * PUT /api/users/password/:id
 * Update password user
 *
 * Params:
 * - id: ID user
 *
 * Body: {
 *   old_password: string,
 *   new_password: string
 * }
 *
 * SECURITY:
 * 1. Verifikasi password lama dulu
 * 2. Hash password baru
 * 3. Update di database
 */
router.put('/password/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { old_password, new_password } = req.body;

    // Validasi input
    if (!old_password || !new_password) {
      return res.status(400).json({
        success: false,
        message: 'Password lama dan baru harus diisi'
      });
    }

    // Get user dengan password
    const [users] = await db.query('SELECT password FROM users WHERE id = ?', [id]);

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User tidak ditemukan'
      });
    }

    // Verifikasi password lama
    const isValidPassword = await bcrypt.compare(old_password, users[0].password);

    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Password lama salah'
      });
    }

    // Hash password baru
    const hashedPassword = await bcrypt.hash(new_password, 10);

    // Update password
    await db.query('UPDATE users SET password = ? WHERE id = ?', [hashedPassword, id]);

    res.json({
      success: true,
      message: 'Password berhasil diupdate'
    });
  } catch (error) {
    console.error('Update password error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengupdate password'
    });
  }
});

/**
 * GET /api/users/stats/:id
 * Get statistik donor user
 *
 * Params:
 * - id: ID user
 *
 * Return: {
 *   total_donations: number,
 *   total_blood_donated: number (ml),
 *   last_donation: date
 * }
 *
 * Hanya menghitung donation dengan status completed
 */
router.get('/stats/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Hitung total donation completed
    const [countResult] = await db.query(
      'SELECT COUNT(*) as total FROM donation_history WHERE user_id = ? AND status = "completed"',
      [id]
    );

    // Hitung total darah yang didonasikan (dalam ml)
    const [bloodResult] = await db.query(
      'SELECT SUM(quantity) as total FROM donation_history WHERE user_id = ? AND status = "completed"',
      [id]
    );

    // Ambil tanggal donor terakhir
    const [lastDonation] = await db.query(
      'SELECT donation_date FROM donation_history WHERE user_id = ? AND status = "completed" ORDER BY donation_date DESC LIMIT 1',
      [id]
    );

    res.json({
      success: true,
      data: {
        total_donations: countResult[0].total || 0,
        total_blood_donated: bloodResult[0].total || 0,
        last_donation: lastDonation[0]?.donation_date || null
      }
    });
  } catch (error) {
    console.error('Get user stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil statistik user'
    });
  }
});

module.exports = router;