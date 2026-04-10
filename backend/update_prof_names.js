const mysql = require('mysql2/promise');
require('dotenv').config();

async function updateProfessorNames() {
    const db = await mysql.createConnection({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });

    const updates = [
        { email: 'dr.ahmed@college.edu', name: 'Dr. Ahmed Hassan', nameAr: 'د. أحمد حسن' },
        { email: 'dr.mohamed@college.edu', name: 'Dr. Mohamed Ali', nameAr: 'د. محمد علي' },
        { email: 'dr.fatma@college.edu', name: 'Dr. Fatma Salem', nameAr: 'د. فاطمة سالم' },
        { email: 'dr.khaled@college.edu', name: 'Dr. Khaled Mostafa', nameAr: 'د. خالد مصطفى' },
        { email: 'dr.rania@college.edu', name: 'Dr. Rania Hassan', nameAr: 'د. رانيا حسن' },
        { email: 'dr.sami@college.edu', name: 'Dr. Sami Osman', nameAr: 'د. سامي عثمان' }
    ];

    try {
        console.log('🔄 Updating professor names...');
        for (const update of updates) {
            const [result] = await db.execute(
                "UPDATE users SET name = ?, name_ar = ? WHERE email = ?",
                [update.name, update.nameAr, update.email]
            );
            if (result.affectedRows > 0) {
                console.log(`✅ Updated: ${update.email} -> ${update.name}`);
            } else {
                console.log(`⚠️ No account found with email: ${update.email}`);
            }
        }
        console.log('✨ All updates complete.');
    } catch (err) {
        console.error('❌ Error updating names:', err);
    } finally {
        await db.end();
    }
}

updateProfessorNames();
