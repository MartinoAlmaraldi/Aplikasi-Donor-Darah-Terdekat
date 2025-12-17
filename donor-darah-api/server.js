/**
 * ========================================
 * SERVER ENTRY POINT
 * ========================================
 *
 * File utama untuk menjalankan backend server
 *
 * STACK:
 * - Express.js - Web framework
 * - CORS - Cross-origin resource sharing
 * - Body-parser - Parse request body
 * - Dotenv - Environment variables
 *
 * STRUKTUR:
 * 1. Import dependencies
 * 2. Setup middleware (CORS, body-parser)
 * 3. Mount routes
 * 4. Error handling
 * 5. Start server
 *
 * PORT:
 * - Default: 3000
 * - Development: 3001 (dari .env)
 * - Bisa diakses dari:
 *   - Localhost: http://localhost:3001
 *   - Emulator: http://10.0.2.2:3001
 *   - Device: http://[YOUR_IP]:3001
 */

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config(); // Load environment variables

const app = express();
const PORT = process.env.PORT || 3000;

// ========================================
// MIDDLEWARE
// ========================================

// CORS: Izinkan request dari origin lain (Flutter app)
app.use(cors());

// Body-parser: Parse JSON request body
app.use(bodyParser.json());

// Body-parser: Parse URL-encoded request body
app.use(bodyParser.urlencoded({ extended: true }));

// ========================================
// ROUTES
// ========================================

// Import route handlers
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const bloodBankRoutes = require('./routes/bloodBanks');
const donationRoutes = require('./routes/donations');

// Mount routes dengan prefix /api
app.use('/api/auth', authRoutes);           // /api/auth/*
app.use('/api/users', userRoutes);          // /api/users/*
app.use('/api/blood-banks', bloodBankRoutes); // /api/blood-banks/*
app.use('/api/donations', donationRoutes);   // /api/donations/*

// ========================================
// ROOT ENDPOINT
// ========================================

// GET /
// Endpoint untuk testing apakah server running
app.get('/', (req, res) => {
  res.json({
    message: 'Donor Darah API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      bloodBanks: '/api/blood-banks',
      donations: '/api/donations'
    }
  });
});

// ========================================
// ERROR HANDLING
// ========================================

// Middleware untuk handle error
// Akan catch semua error yang di-throw dari route handlers
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: err.message
  });
});

// Handler untuk 404 Not Found
// Akan dipanggil jika tidak ada route yang match
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found'
  });
});

// ========================================
// START SERVER
// ========================================

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📱 For Flutter emulator use: http://10.0.2.2:${PORT}`);
  console.log(`📱 For device use your IP: http://[YOUR_IP]:${PORT}`);
});