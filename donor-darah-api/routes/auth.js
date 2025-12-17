/**
 * ========================================
 * AUTHENTICATION ROUTES
 * ========================================
 *
 * Endpoint untuk autentikasi user (register & login)
 *
 * ENDPOINTS:
 * POST /api/auth/register - Registrasi user baru
 * POST /api/auth/login - Login user
 *
 * SECURITY:
 * - Password di-hash menggunakan bcrypt (salt rounds: 10)
 * - JWT token dengan expiry 7 hari
 * - Validasi input sebelum proses data
 *
 * FLOW REGISTER:
 * 1. Validasi semua field required
 * 2. Cek email sudah terdaftar atau belum
 * 3. Hash password dengan bcrypt
 * 4. Insert user ke database
 * 5. Return success dengan data user (tanpa password)
 *
 * FLOW LOGIN:
 * 1. Validasi email & password tidak kosong
 * 2. Cari user berdasarkan email
 * 3. Verifikasi password dengan bcrypt.compare
 * 4. Generate JWT token
 * 5. Return token dan data user
 */

const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');

/**
 * POST /api/auth/register
 * Registrasi user baru
 *
 * Body: {
 *   name: string,
 *   email: string,
 *   password: string,
 *   phone: string,
 *   blood_type: string,
 *   address: string
 * }
 */
router.post('/register', async (req, res) => {
  try {
    const { name, email, password, phone, blood_type, address } = req.body;

    // Validasi: pastikan semua field diisi
    if (!name || !email || !password || !phone || !blood_type || !address) {
      return res.status(400).json({
        success: false,
        message: 'Semua field harus diisi'
      });
    }

    // Cek apakah email sudah terdaftar
    const [existingUser] = await db.query(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );

    if (existingUser.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Email sudah terdaftar'
      });
    }

    // Hash password dengan bcrypt
    // Salt rounds 10 = password di-hash 2^10 kali
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert user baru ke database
    const [result] = await db.query(
      'INSERT INTO users (name, email, password, phone, blood_type, address) VALUES (?, ?, ?, ?, ?, ?)',
      [name, email, hashedPassword, phone, blood_type, address]
    );

    // Return success dengan data user (tanpa password)
    res.status(201).json({
      success: true,
      message: 'Registrasi berhasil',
      data: {
        id: result.insertId,
        name,
        email,
        phone,
        blood_type,
        address
      }
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat registrasi'
    });
  }
});

/**
 * POST /api/auth/login
 * Login user dan generate JWT token
 *
 * Body: {
 *   email: string,
 *   password: string
 * }
 */
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validasi input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email dan password harus diisi'
      });
    }

    // Cari user berdasarkan email
    const [users] = await db.query(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    // Jika user tidak ditemukan
    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Email atau password salah'
      });
    }

    const user = users[0];

    // Verifikasi password
    // bcrypt.compare akan hash input password dan bandingkan dengan hash di DB
    const isValidPassword = await bcrypt.compare(password, user.password);

    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Email atau password salah'
      });
    }

    // Generate JWT token
    // Payload: data yang akan di-encode dalam token
    // Secret: key untuk signing token
    // Options: expiry time
    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Hapus password dari response
    delete user.password;

    // Return token dan data user
    res.json({
      success: true,
      message: 'Login berhasil',
      data: {
        user,
        token
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat login'
    });
  }
});

module.exports = router;