const express = require('express');
const cors = require('cors');
require('dotenv').config();

// Initialize Firebase Admin SDK
const firebaseAdmin = require('./config/firebase');

const alertRoutes = require('./routes/alertRoutes');

const app = express();

app.use(cors());
app.use(express.json());

// Load Routes
app.use('/api/alerts', alertRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Rapid Response Backend is running' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Rapid Response Backend Server running on port ${PORT}`);
});
