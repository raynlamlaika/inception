const fs = require('fs');
const path = require('path');
const pool = require('./db');

async function runMigration() {
  const sqlPath = path.join(__dirname, '..', 'database', 'migrations', 'init.sql');
  const sql = fs.readFileSync(sqlPath, 'utf8');
  await pool.query(sql);
  console.log('Migration applied');
}

module.exports = runMigration;
