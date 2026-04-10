const mysql = require('mysql2/promise');
require('dotenv').config();

async function findArabic() {
    const db = await mysql.createConnection({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });

    try {
        console.log('--- USERS ---');
        const [users] = await db.query("SELECT id, name, email, role FROM users WHERE name LIKE '%د.%' OR name REGEXP '[أ-ي]'");
        console.log(JSON.stringify(users, null, 2));

        console.log('\n--- COURSES ---');
        const [courses] = await db.query("SELECT id, code, name FROM courses WHERE name LIKE '%د.%' OR name REGEXP '[أ-ي]'");
        console.log(JSON.stringify(courses, null, 2));

    } catch (err) {
        console.error(err);
    } finally {
        await db.end();
    }
}

findArabic();
