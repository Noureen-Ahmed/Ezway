const mysql = require('mysql2/promise');
require('dotenv').config();

async function addColumns() {
    const pool = mysql.createPool({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });
    try {
        await pool.query("ALTER TABLE users ADD COLUMN address VARCHAR(255)");
        console.log("Added address column");
    } catch(e) { console.log(e.message); }
    
    try {
        await pool.query("ALTER TABLE users ADD COLUMN phone VARCHAR(20)");
        console.log("Added phone column");
    } catch(e) { console.log(e.message); }
    process.exit(0);
}
addColumns();
