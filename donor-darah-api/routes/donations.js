/**
 * ========================================
 * DONATIONS ROUTES
 * ========================================
 *
 * Endpoint untuk mengelola riwayat dan permintaan donor darah
 *
 * ENDPOINTS:
 * GET /api/donations/user/:userId - Riwayat donor user
 * POST /api/donations - Buat permintaan donor baru
 * PUT /api/donations/:id/status - Update status donor
 * GET /api/donations/:id - Detail donor spesifik
 * DELETE /api/donations/:id - Hapus riwayat donor
 *
 * STATUS DONOR:
 * - pending: Menunggu konfirmasi
 * - approved: Disetujui PMI
 * - rejected: Ditolak
 * - completed: Selesai donor
 *
 * FLOW DONOR:
 * 1. User buat permintaan (status: pending)
 * 2. PMI approve/reject
 * 3. Jika approved, user donor
 * 4. Update status jadi completed
 */

const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

/**
 * GET /api/donations/user/:userId
 * Get riwayat donor untuk user tertentu
 *
 * Params:
 * - userId: ID user
 *
 * Return: Array riwayat donor dengan nama blood bank
 * Sort: Terbaru dulu (DESC)
 */
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    // Query dengan JOIN untuk mendapatkan nama blood bank
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

/**
 * POST /api/donations
 * Buat permintaan donor baru
 *
 * Body: {
 *   user_id: number,
 *   blood_bank_id: number,
 *   donation_date: date,
 *   blood_type: string,
 *   quantity: number (ml),
 *   notes: string (optional)
 * }
 *
 * Status default: pending
 */
router.post('/', async (req, res) => {
  try {
    const { user_id, blood_bank_id, donation_date, blood_type, quantity, notes } = req.body;

    // Validasi: pastikan field required diisi
    if (!user_id || !blood_bank_id || !donation_date || !blood_type || !quantity) {
      return res.status(400).json({
        success: false,
        message: 'Data tidak lengkap'
      });
    }

    // Insert donation dengan status pending
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

/**
 * PUT /api/donations/:id/status
 * Update status donation
 *
 * Params:
 * - id: ID donation
 *
 * Body: {
 *   status: string (pending|approved|rejected|completed),
 *   notes: string (optional)
 * }
 *
 * Digunakan oleh PMI untuk approve/reject/complete donation
 */
router.put('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;

    // Validasi status harus salah satu dari yang valid
    const validStatuses = ['pending', 'approved', 'rejected', 'completed'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Status tidak valid'
      });
    }

    // Update status dan notes
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

/**
 * GET /api/donations/:id
 * Get detail donation spesifik
 *
 * Params:
 * - id: ID donation
 *
 * Return: Detail lengkap dengan nama blood bank dan user
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Query dengan JOIN untuk mendapatkan nama blood bank dan user
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

/**
 * DELETE /api/donations/:id
 * Hapus riwayat donor
 *
 * Params:
 * - id: ID donation
 *
 * Biasanya hanya untuk donation dengan status pending
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Hard delete dari database
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