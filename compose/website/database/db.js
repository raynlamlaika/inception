const { Pool } = require("pg");

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "myapp",
  password: "rayn",
  port: 5432,
});

const router = require('express').Router();

router.post('/', async (req, res) => {
  const { input } = req.body;
  await pool.query('INSERT INTO user_inputs (content) VALUES ($1)', [input]);
  res.status(201).json({ stored: true });
});

module.exports = { pool, router };