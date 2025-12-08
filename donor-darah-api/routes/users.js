const express = require('express');
const router = express.Router();
const db = require('../config/database');
const bcrypt = require('bcryptjs');

// Get user profile
router.get('/profile/:id', async (req, res) => {
  try {
    const { id } = req.params;

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

// Update user profile
router.put('/profile/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, phone, blood_type, address } = req.body;

    // Validasi input
    if (!name || !phone || !blood_type || !address) {
      return res.status(400).json({
        success: false,
        message: 'Semua field harus diisi'
      });
    }

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

// Update password
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

    // Get user
    const [users] = await db.query('SELECT password FROM users WHERE id = ?', [id]);

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User tidak ditemukan'
      });
    }

    // Verify old password
    const isValidPassword = await bcrypt.compare(old_password, users[0].password);

    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Password lama salah'
      });
    }

    // Hash new password
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

// Get user stats
router.get('/stats/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Get donation count
    const [countResult] = await db.query(
      'SELECT COUNT(*) as total FROM donation_history WHERE user_id = ? AND status = "completed"',
      [id]
    );

    // Get total blood donated
    const [bloodResult] = await db.query(
      'SELECT SUM(quantity) as total FROM donation_history WHERE user_id = ? AND status = "completed"',
      [id]
    );

    // Get last donation date
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