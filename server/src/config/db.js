const { Pool } = require("pg");
require("dotenv").config();

const pool = new Pool({
    host: process.env.POSTGRES_HOST,
    port: process.env.POSTGRES_PORT || 5432,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB
});

pool.on('error', (err) => {
    console.error('Unexpected database error:', err);
});

module.exports = pool;