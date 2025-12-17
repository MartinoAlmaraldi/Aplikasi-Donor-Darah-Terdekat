/**
 * ========================================
 * BLOOD BANKS ROUTES
 * ========================================
 *
 * Endpoint untuk data PMI dan bank darah
 *
 * ENDPOINTS:
 * GET /api/blood-banks - List semua PMI
 * GET /api/blood-banks/:id - Detail PMI spesifik
 * GET /api/blood-banks/:id/stock - Stok darah per PMI
 *
 * FITUR KHUSUS:
 * - Sorting berdasarkan jarak dari lokasi user
 * - Menggunakan Haversine formula untuk hitung jarak
 * - Query parameter: lat & lng untuk lokasi user
 *
 * HAVERSINE FORMULA:
 * Formula matematika untuk menghitung jarak antara 2 titik
 * koordinat di permukaan bumi (sphere)
 * Input: latitude & longitude 2 titik
 * Output: jarak dalam kilometer
 */

const express = require('express');
const router = express.Router();
const db = require('../config/database');

/**
 * Fungsi untuk menghitung jarak antara 2 koordinat
 * Menggunakan Haversine formula
 *
 * @param {number} lat1 - Latitude titik 1
 * @param {number} lon1 - Longitude titik 1
 * @param {number} lat2 - Latitude titik 2
 * @param {number} lon2 - Longitude titik 2
 * @returns {number} Jarak dalam kilometer
 */
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius bumi dalam km

  // Konversi derajat ke radian
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;

  // Haversine formula
  const a =
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon/2) * Math.sin(dLon/2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  const distance = R * c;

  return distance;
}

/**
 * GET /api/blood-banks
 * Get semua blood banks dengan optional sorting berdasarkan jarak
 *
 * Query params (optional):
 * - lat: latitude user
 * - lng: longitude user
 *
 * Jika lat & lng ada, hasil akan di-sort berdasarkan jarak terdekat
 */
router.get('/', async (req, res) => {
  try {
    const { lat, lng } = req.query;

    // Query semua blood banks dari database
    const [bloodBanks] = await db.query('SELECT * FROM blood_banks');

    // Jika lokasi user tersedia, hitung jarak dan sort
    if (lat && lng) {
      const userLat = parseFloat(lat);
      const userLng = parseFloat(lng);

      // Hitung jarak untuk setiap blood bank
      bloodBanks.forEach(bank => {
        bank.distance = calculateDistance(
          userLat,
          userLng,
          parseFloat(bank.latitude),
          parseFloat(bank.longitude)
        );
      });

      // Sort berdasarkan jarak (terdekat dulu)
      bloodBanks.sort((a, b) => a.distance - b.distance);
    }

    res.json({
      success: true,
      data: bloodBanks
    });
  } catch (error) {
    console.error('Get blood banks error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil data PMI'
    });
  }
});

/**
 * GET /api/blood-banks/:id
 * Get detail blood bank spesifik beserta stok darahnya
 *
 * Params:
 * - id: ID blood bank
 *
 * Return: Data blood bank + array stok darah per golongan
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Query data blood bank
    const [bloodBanks] = await db.query(
      'SELECT * FROM blood_banks WHERE id = ?',
      [id]
    );

    if (bloodBanks.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'PMI tidak ditemukan'
      });
    }

    // Query stok darah untuk blood bank ini
    const [bloodStock] = await db.query(
      'SELECT blood_type, quantity FROM blood_stock WHERE blood_bank_id = ?',
      [id]
    );

    // Gabungkan data blood bank dengan stok darah
    res.json({
      success: true,
      data: {
        ...bloodBanks[0],
        blood_stock: bloodStock
      }
    });
  } catch (error) {
    console.error('Get blood bank error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil data PMI'
    });
  }
});

/**
 * GET /api/blood-banks/:id/stock
 * Get stok darah untuk blood bank tertentu
 *
 * Params:
 * - id: ID blood bank
 *
 * Return: Array stok darah per golongan darah
 */
router.get('/:id/stock', async (req, res) => {
  try {
    const { id } = req.params;

    // Query stok darah, sort berdasarkan blood_type
    const [bloodStock] = await db.query(
      'SELECT * FROM blood_stock WHERE blood_bank_id = ? ORDER BY blood_type',
      [id]
    );

    res.json({
      success: true,
      data: bloodStock
    });
  } catch (error) {
    console.error('Get blood stock error:', error);
    res.status(500).json({
      success: false,
      message: 'Gagal mengambil data stok darah'
    });
  }
});

module.exports = router;