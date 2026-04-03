const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkDb() {
    const pool = mysql.createPool({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });
    const [rows] = await pool.query("DESCRIBE users");
    console.log(rows);
    process.exit(0);
}
checkDb();
