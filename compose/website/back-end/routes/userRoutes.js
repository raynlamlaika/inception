const express = require('express');
const pool = require('../db');

const router = express.Router();

router.post('/', async (req, res) => {
  try {
    const { input } = req.body;
    const result = await pool.query(
      'INSERT INTO user_inputs (content) VALUES ($1) RETURNING *',
      [input]
    );
    res.status(201).json({ saved: true, row: result.rows[0] });
  } catch (err) {
    console.error('Failed to insert input:', err);
    res.status(500).json({ saved: false, error: 'Failed to store input' });
  }
});

router.get('/', async (_req, res) => {
  try {
    const { rows } = await pool.query(
      'SELECT id, content, created_at FROM user_inputs ORDER BY created_at DESC'
    );
    res.json(rows);
  } catch (err) {
    console.error('Failed to fetch inputs:', err);
    res.status(500).json({ error: 'Failed to fetch inputs' });
  }
});

module.exports = router;
