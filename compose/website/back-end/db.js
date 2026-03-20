const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.PGUSER || 'bot',
  host: process.env.PGHOST || 'localhost',
  database: process.env.PGDATABASE || 'bot',
  password: process.env.PGPASSWORD || 'rayn',
  port: Number(process.env.PGPORT) || 5432,
});

module.exports = pool;
