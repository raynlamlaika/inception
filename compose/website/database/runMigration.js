const pool = require('./db');
const fs = require('fs');
const path = require('path');

async function runMigration() {
  const sql = fs.readFileSync(
    path.join(__dirname, 'migrations', 'init.sql'),
    'utf8'
  );
  await pool.query(sql);
  console.log('Migration applied');
}

module.exports = runMigration;