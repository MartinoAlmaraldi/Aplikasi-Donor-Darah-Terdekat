const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const bloodBankRoutes = require('./routes/bloodBanks');
const donationRoutes = require('./routes/donations');

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/blood-banks', bloodBankRoutes);
app.use('/api/donations', donationRoutes);

// Root endpoint
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

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: err.message
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📱 For Flutter emulator use: http://10.0.2.2:${PORT}`);
  console.log(`📱 For device use your IP: http://[YOUR_IP]:${PORT}`);
});