/**
 * ========================================
 * DATABASE CONFIGURATION
 * ========================================
 *
 * File ini mengelola koneksi ke database MySQL
 *
 * FITUR:
 * - Connection pooling untuk efisiensi koneksi
 * - Auto-reconnection jika koneksi terputus
 * - Promise-based query untuk async/await
 *
 * KONFIGURASI:
 * - Host, user, password diambil dari .env file
 * - Connection limit: 10 koneksi simultan
 * - Queue limit: unlimited
 *
 * PENGGUNAAN:
 * const db = require('./config/database');
 * const [rows] = await db.query('SELECT * FROM users');
 */

const mysql = require('mysql2');
require('dotenv').config();

// Membuat connection pool untuk mengelola koneksi database
// Pool memungkinkan reuse koneksi untuk performa lebih baik
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'donor_darah_db',
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,  // Tunggu jika semua koneksi sedang dipakai
  connectionLimit: 10,        // Maksimal 10 koneksi aktif
  queueLimit: 0              // Unlimited queue untuk request koneksi
});

// Konversi ke promise-based untuk mendukung async/await
const promisePool = pool.promise();

// Test koneksi saat aplikasi start
// Jika gagal, akan tampil error di console
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ Error connecting to database:', err.message);
    return;
  }
  console.log('✅ Database connected successfully');
  connection.release(); // Kembalikan koneksi ke pool
});

module.exports = promisePool;