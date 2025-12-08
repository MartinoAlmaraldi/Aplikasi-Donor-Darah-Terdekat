const express = require('express');
const router = express.Router();
const db = require('../config/database');

// Function to calculate distance using Haversine formula
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius of the Earth in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  const distance = R * c;
  return distance;
}

// Get all blood banks (with optional location-based sorting)
router.get('/', async (req, res) => {
  try {
    const { lat, lng } = req.query;

    const [bloodBanks] = await db.query('SELECT * FROM blood_banks');

    // If lat and lng provided, calculate distance and sort
    if (lat && lng) {
      const userLat = parseFloat(lat);
      const userLng = parseFloat(lng);

      bloodBanks.forEach(bank => {
        bank.distance = calculateDistance(
          userLat,
          userLng,
          parseFloat(bank.latitude),
          parseFloat(bank.longitude)
        );
      });

      // Sort by distance
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

// Get blood bank by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

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

    // Get blood stock for this blood bank
    const [bloodStock] = await db.query(
      'SELECT blood_type, quantity FROM blood_stock WHERE blood_bank_id = ?',
      [id]
    );

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

// Get blood stock by blood bank ID
router.get('/:id/stock', async (req, res) => {
  try {
    const { id } = req.params;

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