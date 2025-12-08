const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

// Get donation history by user
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    const [donations] = await db.query(`
      SELECT
        dh.*,
        bb.name as blood_bank_name
      FROM donation_history dh
      JOIN blood_banks bb ON dh.blood_bank_id = bb.id
      WHERE dh.user_id = ?
      ORDER BY dh.donation_date DESC
    `, [userId]);

    res.json({
      success: true,
      data: donations
    });
  } catch (error) {
    console.error('Get donation history error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil riwayat donor'
    });
  }
});

// Create new donation request
router.post('/', async (req, res) => {
  try {
    const { user_id, blood_bank_id, donation_date, blood_type, quantity, notes } = req.body;

    // Validasi input
    if (!user_id || !blood_bank_id || !donation_date || !blood_type || !quantity) {
      return res.status(400).json({
        success: false,
        message: 'Data tidak lengkap'
      });
    }

    // Insert donation
    const [result] = await db.query(`
      INSERT INTO donation_history
      (user_id, blood_bank_id, donation_date, blood_type, quantity, status, notes)
      VALUES (?, ?, ?, ?, ?, 'pending', ?)
    `, [user_id, blood_bank_id, donation_date, blood_type, quantity, notes]);

    res.status(201).json({
      success: true,
      message: 'Permintaan donor berhasil dibuat',
      data: {
        id: result.insertId
      }
    });
  } catch (error) {
    console.error('Create donation error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal membuat permintaan donor'
    });
  }
});

// Update donation status
router.put('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;

    // Validasi status
    const validStatuses = ['pending', 'approved', 'rejected', 'completed'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Status tidak valid'
      });
    }

    await db.query(
      'UPDATE donation_history SET status = ?, notes = ? WHERE id = ?',
      [status, notes, id]
    );

    res.json({
      success: true,
      message: 'Status donor berhasil diupdate'
    });
  } catch (error) {
    console.error('Update donation status error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengupdate status donor'
    });
  }
});

// Get donation by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [donations] = await db.query(`
      SELECT
        dh.*,
        bb.name as blood_bank_name,
        u.name as user_name
      FROM donation_history dh
      JOIN blood_banks bb ON dh.blood_bank_id = bb.id
      JOIN users u ON dh.user_id = u.id
      WHERE dh.id = ?
    `, [id]);

    if (donations.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Riwayat donor tidak ditemukan'
      });
    }

    res.json({
      success: true,
      data: donations[0]
    });
  } catch (error) {
    console.error('Get donation error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil data donor'
    });
  }
});

// Delete donation
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    await db.query('DELETE FROM donation_history WHERE id = ?', [id]);

    res.json({
      success: true,
      message: 'Riwayat donor berhasil dihapus'
    });
  } catch (error) {
    console.error('Delete donation error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal menghapus riwayat donor'
    });
  }
});

module.exports = router;