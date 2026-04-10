const mysql = require('mysql2/promise');
require('dotenv').config();

const courseTransitions = [
    { code: 'COMP406', name: 'Computer Project (B)' },
    { code: 'COMP408', name: 'Advanced AI Topics' },
    { code: 'COMP416', name: 'Data & Web Mining' },
    { code: 'COMP418', name: 'Computer Project (Double Major)' },
    { code: 'STAT408', name: 'Time Series' },
    { code: 'STAT412', name: 'Queueing Theory' },
    { code: 'STAT418', name: 'Stochastic Processes (2)' },
    { code: 'STAT424', name: 'Statistics Research Project' }
];

async function updateCourses() {
    const db = await mysql.createConnection({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });

    try {
        for (const c of courseTransitions) {
            console.log(`Updating ${c.code} to ${c.name}...`);
            await db.query("UPDATE courses SET name = ?, name_ar = name WHERE code = ?", [c.name, c.code]);
        }
        console.log('✅ Courses updated successfully.');
    } catch (err) {
        console.error(err);
    } finally {
        await db.end();
    }
}

updateCourses();
