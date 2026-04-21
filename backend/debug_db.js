const mysql = require('mysql2/promise');
require('dotenv').config();

async function debugDB() {
    const config = {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false },
        connectTimeout: 10000
    };

    try {
        console.log('Connecting to:', config.host);
        const connection = await mysql.createConnection(config);
        console.log('✅ Connected');

        const [tables] = await connection.execute('SHOW TABLES');
        console.log('Tables:', tables.map(t => Object.values(t)[0]));

        if (tables.some(t => Object.values(t)[0] === 'users')) {
            const [usersSchema] = await connection.execute('SHOW CREATE TABLE users');
            console.log('USERS Schema:', usersSchema[0]['Create Table']);
        }

        if (tables.some(t => Object.values(t)[0] === 'ums_profile')) {
            const [umsSchema] = await connection.execute('SHOW CREATE TABLE ums_profile');
            console.log('UMS_PROFILE Schema:', umsSchema[0]['Create Table']);
        }

        await connection.end();
    } catch (error) {
        console.error('❌ DB Debug Error:', error);
    }
}

debugDB();
