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
        const connection = await mysql.createConnection(config);
        const [sessionsSchema] = await connection.execute('SHOW CREATE TABLE ums_sessions');
        console.log('UMS_SESSIONS:', sessionsSchema[0]['Create Table']);
        
        await connection.end();
    } catch (error) {
        console.error('Error:', error);
    }
}
debugDB();
