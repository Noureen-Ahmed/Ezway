const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkSchema() {
    const pool = mysql.createPool({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });

    try {
        const [usersDesc] = await pool.execute('DESCRIBE users');
        console.log('USERS Table:', usersDesc);

        try {
            const [umsProfileDesc] = await pool.execute('DESCRIBE ums_profile');
            console.log('UMS_PROFILE Table:', umsProfileDesc);
        } catch (e) {
            console.log('UMS_PROFILE table does not exist yet or failed to describe.');
        }
    } catch (error) {
        console.error('Error checking schema:', error);
    } finally {
        await pool.end();
    }
}

checkSchema();
