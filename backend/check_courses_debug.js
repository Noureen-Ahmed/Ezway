const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkCourses() {
    const db = await mysql.createConnection({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });

    try {
        const [rows] = await db.query("SELECT id, code, name, professors FROM courses LIMIT 20");
        console.log(JSON.stringify(rows, null, 2));
    } catch (err) {
        console.error(err);
    } finally {
        await db.end();
    }
}

checkCourses();
