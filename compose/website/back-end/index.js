const express = require("express");
const cors = require("cors");
const pool = require('./db');
const runMigration = require('./runMigration');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`, req.body);
  next();
});

// Routes
const userRoutes = require("./routes/userRoutes");
app.use("/api/data", userRoutes);

// Health check route
app.get('/ping', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', db: true });
  } catch (err) {
    console.error('DB ping failed:', err.message);
    res.status(500).json({ status: 'error', db: false });
  }
});

// Server
const PORT = 1337;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});


