const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const nodemailer = require('nodemailer');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const axios = require('axios');
const crypto = require('crypto');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const SCRAPER_URL = process.env.SCRAPER_URL || 'http://localhost:5000';
const JWT_SECRET = process.env.JWT_SECRET || 'fallback_secret_key_change_in_production';

// MySQL Connection Pool - Aiven Cloud Database
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
        rejectUnauthorized: false
    },
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Initialize database tables
async function initDatabase() {
    try {
        const connection = await pool.getConnection();
        console.log('🔌 Connected to database');

        // Create users table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(100) NOT NULL,
        avatar VARCHAR(255),
        student_id VARCHAR(50),
        major VARCHAR(100),
        department VARCHAR(100),
        program VARCHAR(100),
        gpa DECIMAL(3,2),
        level INT,
        mode VARCHAR(20) DEFAULT 'student',
        is_verified BOOLEAN DEFAULT FALSE,
        is_onboarding_complete BOOLEAN DEFAULT FALSE,
        enrolled_courses TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      )
    `);

        // Create doctor_courses linking table (professors to their courses)
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS doctor_courses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        doctor_email VARCHAR(100) NOT NULL,
        course_id VARCHAR(50) NOT NULL,
        is_primary BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_doctor_course (doctor_email, course_id),
        INDEX idx_doctor (doctor_email),
        INDEX idx_course (course_id)
      )
    `);

        // Create courses table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS courses (
        id VARCHAR(50) PRIMARY KEY,
        code VARCHAR(20) NOT NULL,
        name VARCHAR(100) NOT NULL,
        category VARCHAR(50),
        credit_hours INT,
        professors JSON,
        description TEXT,
        schedule JSON,
        content JSON,
        assignments JSON,
        exams JSON
      )
    `);

        // Create tasks table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS tasks (
        id VARCHAR(50) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        course_id VARCHAR(50),
        course_name VARCHAR(100),
        priority VARCHAR(20) DEFAULT 'low',
        completed BOOLEAN DEFAULT FALSE,
        description TEXT,
        user_id VARCHAR(50),
        due_date DATETIME,
        points INT DEFAULT 100,
        notification_id INT,
        created_by VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_user (user_id),
        INDEX idx_course (course_id)
      )
    `);

        // Create announcements table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS announcements (
        id VARCHAR(50) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        message TEXT,
        date DATETIME DEFAULT CURRENT_TIMESTAMP,
        type VARCHAR(30) DEFAULT 'general',
        is_read BOOLEAN DEFAULT FALSE,
        course_id VARCHAR(50),
        created_by VARCHAR(100),
        target_audience VARCHAR(20) DEFAULT 'all',
        INDEX idx_course (course_id),
        INDEX idx_date (date)
      )
    `);

        // Create notifications table for student notifications
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS notifications (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_email VARCHAR(100) NOT NULL,
        title VARCHAR(255) NOT NULL,
        message TEXT,
        type VARCHAR(30) DEFAULT 'general',
        reference_type VARCHAR(30),
        reference_id VARCHAR(50),
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_user (user_email),
        INDEX idx_read (is_read),
        INDEX idx_created (created_at)
      )
    `);

        // Create course_content table for lectures, materials, etc.
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS course_content (
        id VARCHAR(50) PRIMARY KEY,
        course_id VARCHAR(50) NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        content_type VARCHAR(30) NOT NULL,
        file_url VARCHAR(500),
        week_number INT,
        order_index INT DEFAULT 0,
        created_by VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_course (course_id),
        INDEX idx_type (content_type)
      )
    `);

        // Create verification codes table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS verification_codes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(100) NOT NULL,
        code VARCHAR(10) NOT NULL,
        type VARCHAR(20) NOT NULL,
        expires_at DATETIME NOT NULL,
        used BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_email (email),
        INDEX idx_code (code)
      )
    `);

        // Create schedule_events table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS schedule_events (
        id VARCHAR(50) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        start_time DATETIME NOT NULL,
        end_time DATETIME NOT NULL,
        location VARCHAR(100),
        instructor VARCHAR(100),
        course_id VARCHAR(50),
        description TEXT,
        type VARCHAR(20) DEFAULT 'lecture',
        user_email VARCHAR(100),
        INDEX idx_course (course_id),
        INDEX idx_user (user_email)
      )
    `);

        // Create academic_advising table (links students to advisors)
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS academic_advising (
        id INT AUTO_INCREMENT PRIMARY KEY,
        advisor_email VARCHAR(100) NOT NULL,
        student_email VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_advising (advisor_email, student_email),
        INDEX idx_advisor (advisor_email),
        INDEX idx_student (student_email)
      )
    `);

        // Create advising_messages table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS advising_messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        sender_email VARCHAR(100) NOT NULL,
        receiver_email VARCHAR(100), -- Null for broadcast
        message TEXT NOT NULL,
        is_broadcast BOOLEAN DEFAULT FALSE,
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_sender (sender_email),
        INDEX idx_receiver (receiver_email),
        INDEX idx_broadcast (is_broadcast)
      )
    `);

        // ==========================================
        // NEW UMS UNIFIED TABLES
        // ==========================================
        
        await connection.execute(`
            CREATE TABLE IF NOT EXISTS ums_sessions (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id VARCHAR(50) NOT NULL,
                cookies JSON,
                last_sync_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                expires_at TIMESTAMP,
                is_active BOOLEAN DEFAULT TRUE,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            )
        `);

        await connection.execute(`
            CREATE TABLE IF NOT EXISTS ums_courses (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id VARCHAR(50) NOT NULL,
                course_code VARCHAR(50),
                course_name VARCHAR(255),
                course_name_ar VARCHAR(255),
                credit_hours INT,
                section VARCHAR(50),
                semester VARCHAR(50),
                academic_year VARCHAR(50),
                instructor_name VARCHAR(255),
                raw_data JSON,
                synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            )
        `);

        await connection.execute(`
            CREATE TABLE IF NOT EXISTS ums_grades (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id VARCHAR(50) NOT NULL,
                course_code VARCHAR(50),
                course_name VARCHAR(255),
                grade VARCHAR(10),
                grade_points DECIMAL(3,2),
                credit_hours INT,
                semester VARCHAR(50),
                academic_year VARCHAR(50),
                raw_data JSON,
                synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            )
        `);

        await connection.execute(`
            CREATE TABLE IF NOT EXISTS ums_profile (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id VARCHAR(50) NOT NULL UNIQUE,
                faculty VARCHAR(255),
                major VARCHAR(255),
                semester VARCHAR(50),
                academic_year VARCHAR(50),
                advisor_name VARCHAR(255),
                advisor_email VARCHAR(255),
                student_id_ums VARCHAR(100),
                synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            )
        `);
        
        // Add columns that may not exist yet
        const alterColumns = [
            'ALTER TABLE users ADD COLUMN ums_username VARCHAR(100)',
            'ALTER TABLE users ADD COLUMN name_ar VARCHAR(255)',
            'ALTER TABLE users ADD COLUMN phone VARCHAR(50)',
            'ALTER TABLE users ADD COLUMN address TEXT',
            'ALTER TABLE users ADD COLUMN faculty VARCHAR(255)',
            'ALTER TABLE users ADD COLUMN semester VARCHAR(50)',
            'ALTER TABLE users ADD COLUMN academic_year VARCHAR(50)',
            'ALTER TABLE users ADD COLUMN advisor_name VARCHAR(255)',
            'ALTER TABLE users ADD COLUMN advisor_email VARCHAR(255)',
            // FCM push token
            'ALTER TABLE users ADD COLUMN fcm_token VARCHAR(500)',
            // Tasks: extra columns used by professor content creation
            'ALTER TABLE tasks ADD COLUMN task_type VARCHAR(30) DEFAULT \'ASSIGNMENT\'',
            'ALTER TABLE tasks ADD COLUMN status VARCHAR(20) DEFAULT \'PENDING\'',
            'ALTER TABLE tasks ADD COLUMN max_points INT DEFAULT 100',
            'ALTER TABLE tasks ADD COLUMN created_by_id VARCHAR(100)',
            // Announcements & content: creator foreign key
            'ALTER TABLE announcements ADD COLUMN created_by_id VARCHAR(100)',
            'ALTER TABLE course_content ADD COLUMN created_by_id VARCHAR(100)',
            // course_content: camelCase alias for content_type (used by some INSERT paths)
            'ALTER TABLE course_content ADD COLUMN contentType VARCHAR(30) DEFAULT \'LECTURE\'',
        ];
        for (const sql of alterColumns) {
            try { await connection.execute(sql); } catch (e) { /* column already exists */ }
        }

        // Ensure notifications.id is VARCHAR so generateId() string values work.
        // If the column is currently INT AUTO_INCREMENT (from the CREATE TABLE above),
        // this converts existing rows ('1','2',...) and accepts new string IDs.
        try {
            await connection.execute(
                `ALTER TABLE notifications MODIFY COLUMN id VARCHAR(50) NOT NULL DEFAULT ''`
            );
        } catch (_) { /* already VARCHAR or conversion not needed */ }

        connection.release();
        console.log('✅ Database tables initialized');
    } catch (error) {
        console.error('❌ Database initialization error:', error);
    }
}

// Email transporter (configure with actual SMTP settings)
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'noreply@example.com',
        pass: process.env.EMAIL_PASS || 'password'
    }
});

// ============ HELPER FUNCTIONS ============

// Strip DataTable / Kendo UI artifacts that leak into scraped text
function sanitizeValue(val) {
    if (!val || typeof val !== 'string') return val;
    // Remove "activate to sort column ascending/descending" and surrounding junk
    let cleaned = val.replace(/activate to sort column (ascending|descending)/gi, '').trim();
    // Remove stray HTML tags
    cleaned = cleaned.replace(/<[^>]*>/g, '').trim();
    // Remove leading/trailing quotes, >, and whitespace
    cleaned = cleaned.replace(/^[">\s]+|[">\s]+$/g, '').trim();
    // Collapse multiple spaces
    cleaned = cleaned.replace(/\s{2,}/g, ' ').trim();
    // If the result is empty or just punctuation, return null
    if (!cleaned || /^[:\-,>"\s]+$/.test(cleaned)) return null;
    return cleaned;
}

function formatUser(row) {
    const coursesStr = row.enrolled_courses || '';
    const courses = coursesStr ? coursesStr.split(',').filter(s => s) : [];

    return {
        id: row.id,
        name: sanitizeValue(row.name) || row.name,
        nameAr: sanitizeValue(row.name_ar) || null,
        email: row.email,
        avatar: row.avatar,
        studentId: row.student_id,
        phone: sanitizeValue(row.phone) || null,
        address: sanitizeValue(row.address) || null,
        major: sanitizeValue(row.major) || null,
        department: sanitizeValue(row.department) || null,
        program: sanitizeValue(row.program) || null,
        faculty: sanitizeValue(row.faculty) || null,
        semester: sanitizeValue(row.semester) || null,
        academicYear: sanitizeValue(row.academic_year) || null,
        gpa: row.gpa ? parseFloat(row.gpa) : null,
        level: row.level,
        mode: row.mode || 'student',
        isOnboardingComplete: !!row.is_onboarding_complete,
        isVerified: !!row.is_verified,
        enrolledCourses: courses,
        advisorName: sanitizeValue(row.advisor_name) || null,
        advisorEmail: sanitizeValue(row.advisor_email) || null
    };
}

function generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// Safe JSON parsing helper
function parseJson(field) {
    if (!field) return [];
    if (typeof field === 'object') return field;
    try {
        return JSON.parse(field);
    } catch (e) {
        return [];
    }
}

// Upsert UMS course list into the courses catalog table so doctors can find and post to them.
// Also auto-assigns matching doctors (by name) via doctor_courses.
async function syncUmsCoursesToCatalog(umsCourses) {
    for (const c of umsCourses) {
        const rawCode = (c.courseCode || '').trim();
        if (!rawCode) continue;
        const normalizedCode = rawCode.replace(/\s+/g, '').toUpperCase();
        const courseName = (c.courseName || normalizedCode).trim();

        try {
            // Upsert into courses table
            const [existing] = await pool.execute('SELECT id, professors FROM courses WHERE code = ?', [normalizedCode]);
            let courseDbId;
            if (existing.length === 0) {
                courseDbId = generateId();
                const professors = c.instructorName ? JSON.stringify([{ name: c.instructorName }]) : '[]';
                await pool.execute(
                    'INSERT INTO courses (id, code, name, professors) VALUES (?, ?, ?, ?)',
                    [courseDbId, normalizedCode, courseName, professors]
                );
                console.log(`📚 Created course: ${normalizedCode} - ${courseName}`);
            } else {
                courseDbId = existing[0].id;
                // Add instructor to professors JSON if not already listed
                if (c.instructorName) {
                    const profs = parseJson(existing[0].professors || '[]');
                    if (!profs.some(p => p.name === c.instructorName)) {
                        profs.push({ name: c.instructorName });
                        await pool.execute('UPDATE courses SET professors = ? WHERE id = ?', [JSON.stringify(profs), courseDbId]);
                    }
                }
            }

            // Try to auto-assign matching doctor by searching instructor name in users table
            if (c.instructorName && c.instructorName.length >= 3) {
                // Strip "Dr." prefix and use first word for matching
                const searchTerm = c.instructorName.replace(/^dr\.?\s*/i, '').trim().split(/\s+/)[0];
                if (searchTerm.length >= 3) {
                    const [matchedDoctors] = await pool.execute(
                        `SELECT id, email FROM users WHERE mode IN ('doctor', 'professor') AND LOWER(name) LIKE LOWER(?)`,
                        [`%${searchTerm}%`]
                    );
                    for (const doctor of matchedDoctors) {
                        await pool.execute(
                            'INSERT IGNORE INTO doctor_courses (doctor_email, course_id) VALUES (?, ?)',
                            [doctor.email, courseDbId]
                        );
                    }
                }
            }
        } catch (e) {
            console.error(`[syncUmsCoursesToCatalog] Error for ${normalizedCode}:`, e.message);
        }
    }
}

// Send notification to students enrolled in a course (checks both legacy enrolled_courses and ums_courses)
async function notifyStudentsInCourse(courseId, notification) {
    try {
        // Resolve the course code from the courses table
        let courseCode = courseId;
        try {
            const [courseRows] = await pool.execute('SELECT code FROM courses WHERE id = ?', [courseId]);
            if (courseRows.length > 0 && courseRows[0].code) {
                courseCode = courseRows[0].code;
            }
        } catch (_) {}

        console.log(`🔍 Notifying students for courseId=${courseId}, courseCode=${courseCode}`);

        // Legacy: students whose enrolled_courses CSV contains this courseId
        const [legacyUsers] = await pool.execute(`
            SELECT DISTINCT id, email FROM users 
            WHERE mode = 'student' AND (enrolled_courses LIKE ? OR enrolled_courses LIKE ?)
        `, [`%${courseId}%`, `%${courseCode}%`]);

        // UMS students: match by the resolved course code (e.g. COMP404)
        // Also try partial match for codes with spaces like 'COMP 404'
        const codeNoSpaces = courseCode.replace(/\s+/g, '');
        const [umsUsers] = await pool.execute(`
            SELECT DISTINCT u.id, u.email
            FROM users u
            INNER JOIN ums_courses uc ON uc.user_id = u.id
            WHERE u.mode = 'student'
              AND (
                uc.course_code = ?
                OR REPLACE(uc.course_code, ' ', '') = ?
                OR uc.course_code LIKE ?
              )
        `, [courseCode, codeNoSpaces, `%${codeNoSpaces}%`]);

        // Merge unique users by id -> email
        const userMap = new Map();
        for (const u of legacyUsers) userMap.set(u.id, u.email);
        for (const u of umsUsers) userMap.set(u.id, u.email);

        console.log(`📋 Found ${userMap.size} students (legacy: ${legacyUsers.length}, ums: ${umsUsers.length})`);

        let count = 0;
        let notifType = (notification.type || 'GENERAL').toUpperCase();
        if (!['GENERAL', 'ANNOUNCEMENT', 'ASSIGNMENT', 'EXAM', 'GRADE', 'REMINDER', 'SYSTEM'].includes(notifType)) {
            notifType = 'GENERAL';
        }
        let refType = (notification.referenceType || 'ANNOUNCEMENT').toUpperCase();
        if (!['ANNOUNCEMENT', 'ASSIGNMENT', 'EXAM', 'LECTURE', 'COURSE', 'USER'].includes(refType)) {
            refType = null;
        }

        for (const [, userEmail] of userMap) {
            await pool.execute(`
                INSERT INTO notifications (id, user_email, title, message, type, reference_type, reference_id, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
            `, [
                generateId(),
                userEmail,
                notification.title,
                notification.message,
                notifType,
                refType,
                notification.referenceId || null
            ]);
            count++;
        }

        console.log(`📢 Notified ${count} students about: ${notification.title}`);
        return count;
    } catch (error) {
        console.error('Error sending notifications:', error);
        return 0;
    }
}

// ============ MIDDLEWARE (JWT) ============

function verifyToken(req, res, next) {
    const bearerHeader = req.headers['authorization'];
    if (!bearerHeader) {
        return res.status(401).json({ success: false, error: 'Access denied. No token provided.' });
    }
    
    const token = bearerHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({ success: false, error: 'Access denied. Invalid token format.' });
    }

    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(403).json({ success: false, error: 'Invalid or expired token.' });
    }
}

app.use((req, res, next) => {
    if (req.path.startsWith('/api/auth') || req.path === '/api/health' || req.path.startsWith('/api/ums/login')) {
        return next();
    }
    verifyToken(req, res, next);
});

// ============ AUTH ENDPOINTS ============

app.post('/api/auth/register', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Check if user exists
        const [existing] = await pool.execute('SELECT id FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(409).json({ error: 'User already exists' });
        }

        const id = generateId();
        const mode = email.includes('doctor') || email.includes('professor') || email.includes('dr.') ? 'professor' : 'student';
        const studentId = mode === 'student' ? `STU${Date.now().toString().slice(-8)}` : null;

        const hashedPassword = await bcrypt.hash(password, 10);

        await pool.execute(`
            INSERT INTO users (id, name, email, password, student_id, mode, is_onboarding_complete)
            VALUES (?, ?, ?, ?, ?, ?, FALSE)
        `, [id, name, email, hashedPassword, studentId, mode]);

        // Generate verification code
        const code = Math.floor(1000 + Math.random() * 9000).toString();
        const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes

        await pool.execute(`
            INSERT INTO verification_codes (email, code, type, expires_at)
            VALUES (?, ?, 'registration', ?)
        `, [email, code, expiresAt]);

        // Try to send email
        try {
            await transporter.sendMail({
                from: process.env.EMAIL_USER,
                to: email,
                subject: 'Verify Your Account',
                text: `Your verification code is: ${code}`,
                html: `<p>Your verification code is: <strong>${code}</strong></p>`
            });
            console.log(`📧 Verification email sent to ${email} with code ${code}`);
        } catch (emailError) {
            console.log(`📧 Email not configured. Code for ${email}: ${code}`);
        }

        // Generate JWT
        const token = jwt.sign({ id, email, role: mode }, JWT_SECRET, { expiresIn: '7d' });

        const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);
        const user = formatUser(rows[0]);

        console.log(`✅ User registered: ${email} (${mode})`);
        res.status(201).json({ success: true, user, token });
    } catch (error) {
        console.error('Register error:', error);
        res.status(500).json({ error: 'Registration failed' });
    }
});

app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const [rows] = await pool.execute(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );

        if (rows.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const userRow = rows[0];
        const isMatch = await bcrypt.compare(password, userRow.password);
        
        // Allow plain text login if bcrypt compare fails (Legacy support while transitioning)
        let passwordValid = isMatch;
        if (!passwordValid && password === userRow.password) {
            passwordValid = true;
            // Upgrade password immediately to bcrypt
            const hashed = await bcrypt.hash(password, 10);
            await pool.execute('UPDATE users SET password = ? WHERE id = ?', [hashed, userRow.id]);
        }

        if (!passwordValid) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const token = jwt.sign({ id: userRow.id, email: userRow.email, role: userRow.mode }, JWT_SECRET, { expiresIn: '7d' });

        const user = formatUser(userRow);
        console.log(`✅ User logged in: ${email}`);
        res.json({ success: true, user, token });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Login failed' });
    }
});

app.post('/api/auth/send-code', async (req, res) => {
    try {
        const { email, type } = req.body;
        const code = Math.floor(1000 + Math.random() * 9000).toString();
        const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

        // Delete old codes
        await pool.execute('DELETE FROM verification_codes WHERE email = ? AND type = ?', [email, type]);

        await pool.execute(`
            INSERT INTO verification_codes (email, code, type, expires_at)
            VALUES (?, ?, ?, ?)
        `, [email, code, type, expiresAt]);

        try {
            await transporter.sendMail({
                from: process.env.EMAIL_USER,
                to: email,
                subject: 'Verification Code',
                text: `Your verification code is: ${code}`,
                html: `<p>Your verification code is: <strong>${code}</strong></p>`
            });
        } catch (emailError) {
            console.log(`📧 Email not configured. Code for ${email}: ${code}`);
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Send code error:', error);
        res.status(500).json({ error: 'Failed to send code' });
    }
});

app.post('/api/auth/verify-code', async (req, res) => {
    try {
        const { email, code, type } = req.body;
        const [rows] = await pool.execute(`
            SELECT * FROM verification_codes 
            WHERE email = ? AND code = ? AND type = ? AND used = FALSE AND expires_at > NOW()
            ORDER BY created_at DESC LIMIT 1
        `, [email, code, type]);

        if (rows.length === 0) {
            return res.status(400).json({ error: 'Invalid or expired code' });
        }

        // Mark code as used
        await pool.execute('UPDATE verification_codes SET used = TRUE WHERE id = ?', [rows[0].id]);

        // Update user as verified
        await pool.execute('UPDATE users SET is_verified = TRUE WHERE email = ?', [email]);

        res.json({ success: true });
    } catch (error) {
        console.error('Verify code error:', error);
        res.status(500).json({ error: 'Verification failed' });
    }
});

app.post('/api/auth/reset-password', async (req, res) => {
    try {
        const { email, newPassword } = req.body;
        await pool.execute('UPDATE users SET password = ? WHERE email = ?', [newPassword, email]);
        res.json({ success: true });
    } catch (error) {
        console.error('Reset password error:', error);
        res.status(500).json({ error: 'Password reset failed' });
    }
});

// ============ USER ENDPOINTS ============

app.get('/api/users/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const [rows] = await pool.execute(`
            SELECT u.*, p.advisor_name, p.advisor_email 
            FROM users u 
            LEFT JOIN ums_profile p ON u.id = p.user_id 
            WHERE u.email = ?
        `, [email]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json({ success: true, user: formatUser(rows[0]) });
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Failed to get user' });
    }
});

app.put('/api/users/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const { name, avatar, department, gpa, level, mode, isOnboardingComplete, enrolledCourses } = req.body;
        const major = req.body.program || req.body.major;

        const coursesStr = Array.isArray(enrolledCourses) ? enrolledCourses.join(',') : (enrolledCourses || '');

        await pool.execute(`
            UPDATE users SET
                name = ?,
                avatar = ?,
                major = ?,
                department = ?,
                gpa = ?,
                level = ?,
                mode = ?,
                is_onboarding_complete = ?,
                enrolled_courses = ?
            WHERE email = ?
        `, [
            name || null, 
            avatar || null, 
            major || null, 
            department || null, 
            gpa || null, 
            level || null, 
            mode || null, 
            isOnboardingComplete ? 1 : 0, 
            coursesStr, 
            email
        ]);

        const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);
        const user = rows.length > 0 ? formatUser(rows[0]) : null;

        console.log(`✅ User updated: ${email}`);
        res.json({ success: true, user });
    } catch (error) {
        console.error('Update user error:', error);
        res.status(500).json({ error: 'Failed to update user' });
    }
});

// ============ DOCTOR COURSES ENDPOINTS ============

// Get courses for a specific doctor
app.get('/api/doctor-courses/:email', async (req, res) => {
    try {
        const { email } = req.params;

        // Get course IDs for this doctor
        const [doctorCourses] = await pool.execute(`
            SELECT course_id, is_primary FROM doctor_courses WHERE doctor_email = ?
        `, [email]);

        if (doctorCourses.length === 0) {
            return res.json({ success: true, courses: [] });
        }

        // Get full course details
        const courseIds = doctorCourses.map(dc => dc.course_id);
        const placeholders = courseIds.map(() => '?').join(',');
        const [courses] = await pool.execute(`
            SELECT * FROM courses WHERE id IN (${placeholders})
        `, courseIds);

        // Parse JSON fields
        const formattedCourses = courses.map(course => ({
            ...course,
            professors: parseJson(course.professors),
            schedule: parseJson(course.schedule),
            content: parseJson(course.content),
            assignments: parseJson(course.assignments),
            exams: parseJson(course.exams),
        }));

        res.json({ success: true, courses: formattedCourses });
    } catch (error) {
        console.error('Get doctor courses error:', error);
        res.status(500).json({ error: 'Failed to get doctor courses' });
    }
});

// Assign a course to a doctor
app.post('/api/doctor-courses', async (req, res) => {
    try {
        const { doctorEmail, courseId, isPrimary } = req.body;

        await pool.execute(`
            INSERT INTO doctor_courses (doctor_email, course_id, is_primary)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE is_primary = ?
        `, [doctorEmail, courseId, isPrimary || false, isPrimary || false]);

        res.json({ success: true });
    } catch (error) {
        console.error('Assign doctor course error:', error);
        res.status(500).json({ error: 'Failed to assign course' });
    }
});

// Alias endpoint for Flutter getProfessorCourses (bridges /api/users/professor/courses?email=X)
app.get('/api/users/professor/courses', async (req, res) => {
    try {
        const email = req.query.email;
        if (!email) return res.status(400).json({ error: 'Email required' });

        const [doctorCourses] = await pool.execute(
            'SELECT course_id, is_primary FROM doctor_courses WHERE doctor_email = ?',
            [email]
        );

        if (doctorCourses.length === 0) {
            return res.json({ success: true, courses: [] });
        }

        const courseIds = doctorCourses.map(dc => dc.course_id);
        const placeholders = courseIds.map(() => '?').join(',');
        const [courses] = await pool.execute(
            `SELECT * FROM courses WHERE id IN (${placeholders})`,
            courseIds
        );

        const formattedCourses = courses.map(course => ({
            ...course,
            professors: parseJson(course.professors),
            schedule: parseJson(course.schedule),
            content: parseJson(course.content),
            assignments: parseJson(course.assignments),
            exams: parseJson(course.exams),
        }));

        res.json({ success: true, courses: formattedCourses });
    } catch (error) {
        console.error('Get professor courses error:', error);
        res.status(500).json({ error: 'Failed to get professor courses' });
    }
});

// ============ CONTENT CREATION ENDPOINTS ============

// Create lecture/content for a course
app.post('/api/content', async (req, res) => {
    try {
        const { courseId, title, description, contentType, fileUrl, weekNumber } = req.body;
        const createdById = req.user?.id;

        if (!createdById) return res.status(401).json({ error: 'Unauthorized' });

        const id = generateId();

        await pool.execute(`
            INSERT INTO course_content (id, course_id, title, description, contentType, file_url, week_number, created_by_id, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        `, [id, courseId, title, description || '', contentType || 'LECTURE', fileUrl || null, weekNumber || 0, createdById]);

        // Notify students
        await notifyStudentsInCourse(courseId, {
            title: `New ${contentType || 'LECTURE'}: ${title}`,
            message: description || '',
            type: 'ANNOUNCEMENT',
            referenceType: 'LECTURE',
            referenceId: id
        });

        // Also create an announcement
        const announcementId = generateId();
        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by_id)
            VALUES (?, ?, ?, 'LECTURE', ?, ?)
        `, [announcementId, `New ${contentType || 'LECTURE'}: ${title}`, description || '', courseId, createdById]);

        console.log(`✅ Content created: ${title} for course ${courseId}`);
        res.json({ success: true, contentId: id });
    } catch (error) {
        console.error('Create content error:', error);
        res.status(500).json({ error: 'Failed to create content' });
    }
});

// Create assignment for a course
app.post('/api/assignments', async (req, res) => {
    try {
        const { courseId, title, description, dueDate, points } = req.body;
        const createdById = req.user?.id;

        if (!createdById) return res.status(401).json({ error: 'Unauthorized' });

        const id = generateId();

        // Create task for the assignment
        await pool.execute(`
            INSERT INTO tasks (id, title, course_id, task_type, priority, description, due_date, max_points, created_by_id, updated_at, status)
            VALUES (?, ?, ?, 'ASSIGNMENT', 'medium', ?, ?, ?, ?, NOW(), 'PENDING')
        `, [id, title, courseId, description || '', dueDate || null, points || 100, createdById]);

        // Notify students
        await notifyStudentsInCourse(courseId, {
            title: `New Assignment: ${title}`,
            message: `Due: ${dueDate ? new Date(dueDate).toLocaleDateString() : 'TBA'}. ${description || ''}`,
            type: 'ASSIGNMENT',
            referenceType: 'ASSIGNMENT',
            referenceId: id
        });

        // Create announcement
        const announcementId = generateId();
        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by_id)
            VALUES (?, ?, ?, 'ASSIGNMENT', ?, ?)
        `, [announcementId, `New Assignment: ${title}`, `Due: ${dueDate ? new Date(dueDate).toLocaleDateString() : 'TBA'}`, courseId, createdById]);

        console.log(`✅ Assignment created: ${title} for course ${courseId}`);
        res.json({ success: true, assignmentId: id });
    } catch (error) {
        console.error('Create assignment error:', error);
        res.status(500).json({ error: 'Failed to create assignment' });
    }
});

// Create exam for a course
app.post('/api/exams', async (req, res) => {
    try {
        const { courseId, title, description, examDate, points } = req.body;
        const createdById = req.user?.id;

        if (!createdById) return res.status(401).json({ error: 'Unauthorized' });

        const id = generateId();

        // Create task for the exam
        await pool.execute(`
            INSERT INTO tasks (id, title, course_id, task_type, priority, description, due_date, max_points, created_by_id, updated_at, status)
            VALUES (?, ?, ?, 'EXAM', 'high', ?, ?, ?, ?, NOW(), 'PENDING')
        `, [id, title, courseId, description || '', examDate || null, points || 100, createdById]);

        // Notify students
        await notifyStudentsInCourse(courseId, {
            title: `Exam Scheduled: ${title}`,
            message: `Date: ${examDate ? new Date(examDate).toLocaleDateString() : 'TBA'}. ${description || ''}`,
            type: 'EXAM',
            referenceType: 'EXAM',
            referenceId: id
        });

        // Create announcement
        const announcementId = generateId();
        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by_id)
            VALUES (?, ?, ?, 'EXAM', ?, ?)
        `, [announcementId, `Exam Scheduled: ${title}`, `Date: ${examDate ? new Date(examDate).toLocaleDateString() : 'TBA'}`, courseId, createdById]);

        console.log(`✅ Exam created: ${title} for course ${courseId}`);
        res.json({ success: true, examId: id });
    } catch (error) {
        console.error('Create exam error:', error);
        res.status(500).json({ error: 'Failed to create exam' });
    }
});

// Route aliases – the Flutter DataService calls /content/assignment and /content/exam
app.post('/api/content/assignment', (req, res) => {
    // Forward to the canonical /api/assignments handler
    req.url = '/api/assignments';
    app.handle(req, res);
});

app.post('/api/content/exam', (req, res) => {
    // Forward to the canonical /api/exams handler
    req.url = '/api/exams';
    app.handle(req, res);
});


// ============ NOTIFICATIONS ENDPOINTS ============

// Get notifications for the logged-in user (JWT-based, no email in URL)
app.get('/api/notifications', async (req, res) => {
    try {
        const email = req.user?.email;
        if (!email) {
            return res.status(401).json({ error: 'Not authenticated' });
        }
        const [rows] = await pool.execute(`
            SELECT * FROM notifications 
            WHERE user_email = ? 
            ORDER BY created_at DESC 
            LIMIT 50
        `, [email]);

        res.json({ success: true, notifications: rows });
    } catch (error) {
        console.error('Get notifications error:', error);
        res.status(500).json({ error: 'Failed to get notifications' });
    }
});

// Get notifications by email (legacy fallback)
app.get('/api/notifications/:email', async (req, res) => {
    try {
        const { email } = req.params;
        // Prevent matching other routes like /read-all
        if (email === 'read-all' || email === 'token') {
            return res.status(400).json({ error: 'Invalid email' });
        }
        const [rows] = await pool.execute(`
            SELECT * FROM notifications 
            WHERE user_email = ? 
            ORDER BY created_at DESC 
            LIMIT 50
        `, [email]);

        res.json({ success: true, notifications: rows });
    } catch (error) {
        console.error('Get notifications error:', error);
        res.status(500).json({ error: 'Failed to get notifications' });
    }
});

// Mark notification as read
app.put('/api/notifications/:id/read', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.execute('UPDATE notifications SET is_read = TRUE WHERE id = ?', [id]);
        res.json({ success: true });
    } catch (error) {
        console.error('Mark notification read error:', error);
        res.status(500).json({ error: 'Failed to mark notification as read' });
    }
});

// Mark all notifications as read (JWT-based)
app.put('/api/notifications/read-all', async (req, res) => {
    try {
        const email = req.user?.email;
        if (!email) {
            return res.status(401).json({ error: 'Not authenticated' });
        }
        await pool.execute('UPDATE notifications SET is_read = TRUE WHERE user_email = ?', [email]);
        res.json({ success: true });
    } catch (error) {
        console.error('Mark all notifications read error:', error);
        res.status(500).json({ error: 'Failed to mark notifications as read' });
    }
});

// Mark all notifications as read for a user (legacy with email in URL)
app.put('/api/notifications/read-all/:email', async (req, res) => {
    try {
        const { email } = req.params;
        await pool.execute('UPDATE notifications SET is_read = TRUE WHERE user_email = ?', [email]);
        res.json({ success: true });
    } catch (error) {
        console.error('Mark all notifications read error:', error);
        res.status(500).json({ error: 'Failed to mark notifications as read' });
    }
});

// Store/update FCM push token for the logged-in user
app.put('/api/notifications/token', async (req, res) => {
    try {
        const userId = req.user?.id;
        const { fcmToken } = req.body;
        if (!userId || !fcmToken) return res.status(400).json({ error: 'Missing userId or fcmToken' });
        await pool.execute('UPDATE users SET fcm_token = ? WHERE id = ?', [fcmToken, userId]);
        res.json({ success: true });
    } catch (error) {
        console.error('Update FCM token error:', error);
        res.status(500).json({ error: 'Failed to update FCM token' });
    }
});

// ============ TASKS ENDPOINTS ============

app.get('/api/tasks', async (req, res) => {
    try {
        const userId = req.query.userId;
        let query = 'SELECT * FROM tasks ORDER BY due_date ASC';
        let params = [];

        if (userId) {
            query = 'SELECT * FROM tasks WHERE user_id = ? ORDER BY due_date ASC';
            params = [userId];
        }

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, tasks: rows });
    } catch (error) {
        console.error('Get tasks error:', error);
        res.status(500).json({ error: 'Failed to get tasks' });
    }
});

app.post('/api/tasks', async (req, res) => {
    try {
        const { id, title, course, priority, description, userId, dueDate } = req.body;
        const taskId = id || generateId();

        await pool.execute(`
            INSERT INTO tasks (id, title, course_name, priority, description, user_id, due_date)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [taskId, title, course, priority, description, userId, dueDate]);

        res.json({ success: true, taskId });
    } catch (error) {
        console.error('Create task error:', error);
        res.status(500).json({ error: 'Failed to create task' });
    }
});

app.put('/api/tasks/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { title, completed, priority, dueDate } = req.body;

        await pool.execute(`
            UPDATE tasks SET title = ?, completed = ?, priority = ?, due_date = ?
            WHERE id = ?
        `, [title, completed, priority, dueDate, id]);

        res.json({ success: true });
    } catch (error) {
        console.error('Update task error:', error);
        res.status(500).json({ error: 'Failed to update task' });
    }
});

app.delete('/api/tasks/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.execute('DELETE FROM tasks WHERE id = ?', [id]);
        res.json({ success: true });
    } catch (error) {
        console.error('Delete task error:', error);
        res.status(500).json({ error: 'Failed to delete task' });
    }
});

// ============ ANNOUNCEMENTS ENDPOINTS ============

app.get('/api/announcements', async (req, res) => {
    try {
        const { courseId } = req.query;
        // Use query email if provided, otherwise fallback to JWT token email
        const userEmail = req.query.userEmail || req.user?.email;

        let query = 'SELECT * FROM announcements ORDER BY date DESC LIMIT 50';
        let params = [];

        if (courseId) {
            query = 'SELECT * FROM announcements WHERE course_id = ? ORDER BY date DESC';
            params = [courseId];
        } else if (userEmail) {
            // Find all course IDs the user is enrolled in (Legacy + UMS)
            const courseIds = new Set();
            
            // 1. Legacy enrolled_courses
            const [userRows] = await pool.execute('SELECT id, enrolled_courses FROM users WHERE email = ?', [userEmail]);
            if (userRows.length > 0) {
                const legacyStr = userRows[0].enrolled_courses;
                if (legacyStr) {
                    legacyStr.split(',').filter(c => c).forEach(c => courseIds.add(c));
                }
                
                // 2. UMS courses
                const userId = userRows[0].id;
                const [umsRows] = await pool.execute('SELECT course_code FROM ums_courses WHERE user_id = ?', [userId]);
                
                if (umsRows.length > 0) {
                    const codes = umsRows.map(r => r.course_code);
                    const placeholders = codes.map(() => '?').join(',');
                    // We need to find the UUIDs in the courses table that match these UMS codes
                    const [courseUUIDs] = await pool.execute(`SELECT id FROM courses WHERE code IN (${placeholders})`, codes);
                    courseUUIDs.forEach(c => courseIds.add(c.id));
                }
            }

            if (courseIds.size > 0) {
                const ids = Array.from(courseIds);
                const placeholders = ids.map(() => '?').join(',');
                query = `SELECT * FROM announcements WHERE course_id IN (${placeholders}) OR course_id IS NULL ORDER BY date DESC LIMIT 50`;
                params = ids;
            } else {
                // If no courses, just show general announcements
                query = 'SELECT * FROM announcements WHERE course_id IS NULL ORDER BY date DESC LIMIT 50';
            }
        }

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, announcements: rows });
    } catch (error) {
        console.error('Get announcements error:', error);
        res.status(500).json({ error: 'Failed to get announcements' });
    }
});

app.post('/api/announcements', async (req, res) => {
    try {
        const { title, message, type, courseId } = req.body;
        const createdById = req.user?.id;
        
        if (!createdById) return res.status(401).json({ error: 'Unauthorized' });

        const id = generateId();
        
        let annType = (type || 'GENERAL').toUpperCase();
        if (!['GENERAL', 'ASSIGNMENT', 'EXAM', 'LECTURE', 'URGENT', 'MAINTENANCE'].includes(annType)) {
             annType = 'GENERAL';
        }

        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by_id)
            VALUES (?, ?, ?, ?, ?, ?)
        `, [id, title, message, annType, courseId || null, createdById]);

        // Notify students
        if (courseId) {
            await notifyStudentsInCourse(courseId, {
                title,
                message,
                type: 'ANNOUNCEMENT',
                referenceType: 'ANNOUNCEMENT',
                referenceId: id
            });
        }

        res.json({ success: true, announcementId: id });
    } catch (error) {
        console.error('Create announcement error:', error);
        res.status(500).json({ error: 'Failed to create announcement' });
    }
});

// ============ COURSES ENDPOINTS ============

app.get('/api/courses', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM courses');

        const courses = rows.map(course => ({
            ...course,
            professors: parseJson(course.professors),
            schedule: parseJson(course.schedule),
            content: parseJson(course.content),
            assignments: parseJson(course.assignments),
            exams: parseJson(course.exams),
        }));

        res.json({ success: true, courses });
    } catch (error) {
        console.error('Get courses error:', error);
        res.status(500).json({ error: 'Failed to get courses' });
    }
});

app.get('/api/courses/:id', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM courses WHERE id = ?', [req.params.id]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }

        const course = rows[0];
        const courseId = course.id;

        // Pull dynamic data from the DB tables
        const [dynamicContent] = await pool.execute(
            'SELECT * FROM course_content WHERE course_id = ? ORDER BY created_at DESC',
            [courseId]
        );
        const [dynamicTasks] = await pool.execute(
            'SELECT * FROM tasks WHERE course_id = ? ORDER BY created_at DESC',
            [courseId]
        );
        const [dynamicAnnouncements] = await pool.execute(
            'SELECT * FROM announcements WHERE course_id = ? ORDER BY date DESC',
            [courseId]
        );

        // Merge static JSON content with dynamic DB content
        const staticContent = parseJson(course.content);
        const staticAssignments = parseJson(course.assignments);
        const staticExams = parseJson(course.exams);

        // Map dynamic course_content rows to the content format
        const dbContent = dynamicContent.map(row => ({
            week: row.week_number || 0,
            topic: row.title,
            description: row.description || '',
            attachments: parseJson(row.file_url ? [row.file_url] : []),
            id: row.id,
            contentType: row.content_type,
            createdBy: row.created_by,
            createdAt: row.created_at,
        }));

        // Map dynamic tasks to assignments / exams format
        const dbAssignments = dynamicTasks
            .filter(t => (t.priority !== 'high') || (!t.title?.toLowerCase().includes('exam')))
            .filter(t => {
                const title = (t.title || '').toLowerCase();
                return !title.includes('exam') && !title.startsWith('exam');
            })
            .map(t => ({
                id: t.id,
                title: t.title,
                dueDate: t.due_date ? new Date(t.due_date).toISOString() : null,
                maxScore: t.points || 100,
                description: t.description || '',
                isSubmitted: t.completed || false,
                attachments: [],
                status: t.status || 'PENDING',
                createdBy: t.created_by,
                createdAt: t.created_at,
            }));

        const dbExams = dynamicTasks
            .filter(t => {
                const title = (t.title || '').toLowerCase();
                return title.includes('exam') || t.priority === 'high';
            })
            .map(t => ({
                id: t.id,
                title: t.title,
                date: t.due_date ? new Date(t.due_date).toISOString() : null,
                format: '',
                gradingBreakdown: '',
                attachments: [],
                isSubmitted: t.completed || false,
                status: t.status || 'PENDING',
                createdBy: t.created_by,
                createdAt: t.created_at,
            }));

        // Deduplicate: dynamic DB items take priority (by id overlap check)
        const staticContentIds = new Set(staticContent.map(c => c.id).filter(Boolean));
        const staticAssignmentIds = new Set(staticAssignments.map(a => a.id).filter(Boolean));
        const staticExamIds = new Set(staticExams.map(e => e.id).filter(Boolean));

        const mergedContent = [
            ...dbContent.filter(c => !staticContentIds.has(c.id)),
            ...staticContent,
        ];
        const mergedAssignments = [
            ...dbAssignments.filter(a => !staticAssignmentIds.has(a.id)),
            ...staticAssignments,
        ];
        const mergedExams = [
            ...dbExams.filter(e => !staticExamIds.has(e.id)),
            ...staticExams,
        ];

        // Get enrollment count
        let enrollmentCount = 0;
        try {
            // Count from both legacy enrolled_courses and ums_courses
            const [legacyCount] = await pool.execute(
                `SELECT COUNT(*) as cnt FROM users WHERE mode = 'student' AND enrolled_courses LIKE ?`,
                [`%${courseId}%`]
            );
            const [umsCount] = await pool.execute(
                `SELECT COUNT(DISTINCT uc.user_id) as cnt FROM ums_courses uc
                 INNER JOIN users u ON uc.user_id = u.id
                 WHERE u.mode = 'student' AND (uc.course_code = ? OR uc.course_code LIKE ?)`,
                [course.code, `%${course.code}%`]
            );
            enrollmentCount = (legacyCount[0]?.cnt || 0) + (umsCount[0]?.cnt || 0);
        } catch (_) {}

        res.json({
            success: true,
            course: {
                ...course,
                professors: parseJson(course.professors),
                schedule: parseJson(course.schedule),
                content: mergedContent,
                assignments: mergedAssignments,
                exams: mergedExams,
                announcements: dynamicAnnouncements,
                enrollmentCount,
                stats: { students: enrollmentCount },
            }
        });
    } catch (error) {
        console.error('Get course error:', error);
        res.status(500).json({ error: 'Failed to get course' });
    }
});

// Get unified feed for a course (all activity: announcements, lectures, exams, assignments)
app.get('/api/courses/:id/feed', async (req, res) => {
    try {
        const courseId = req.params.id;

        // Verify course exists
        const [courseRows] = await pool.execute('SELECT id, code, name FROM courses WHERE id = ?', [courseId]);
        if (courseRows.length === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }

        // Fetch all dynamic items
        const [contentRows] = await pool.execute(
            'SELECT * FROM course_content WHERE course_id = ? ORDER BY created_at DESC',
            [courseId]
        );
        const [taskRows] = await pool.execute(
            'SELECT * FROM tasks WHERE course_id = ? ORDER BY created_at DESC',
            [courseId]
        );
        const [announcementRows] = await pool.execute(
            'SELECT * FROM announcements WHERE course_id = ? ORDER BY date DESC',
            [courseId]
        );

        // Build unified feed
        const feed = [];

        for (const row of announcementRows) {
            feed.push({
                id: row.id,
                feedType: 'announcement',
                title: row.title,
                message: row.message,
                type: row.type,
                courseId: row.course_id,
                createdBy: row.created_by,
                createdAt: row.date || row.created_at,
            });
        }

        for (const row of contentRows) {
            feed.push({
                id: row.id,
                feedType: 'lecture',
                title: row.title,
                message: row.description,
                type: row.content_type,
                courseId: row.course_id,
                fileUrl: row.file_url,
                weekNumber: row.week_number,
                createdBy: row.created_by,
                createdAt: row.created_at,
            });
        }

        for (const row of taskRows) {
            const title = (row.title || '').toLowerCase();
            const isExam = title.includes('exam') || row.priority === 'high';

            feed.push({
                id: row.id,
                feedType: isExam ? 'exam' : 'assignment',
                title: row.title,
                message: row.description,
                type: isExam ? 'exam' : 'assignment',
                courseId: row.course_id,
                dueDate: row.due_date,
                points: row.points,
                status: row.status,
                createdBy: row.created_by,
                createdAt: row.created_at,
            });
        }

        // Sort by createdAt descending
        feed.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

        res.json({ success: true, feed, course: courseRows[0] });
    } catch (error) {
        console.error('Get course feed error:', error);
        res.status(500).json({ error: 'Failed to get course feed' });
    }
});

// Get content for a course
app.get('/api/courses/:id/content', async (req, res) => {
    try {
        const [rows] = await pool.execute(
            'SELECT * FROM course_content WHERE course_id = ? ORDER BY week_number, order_index',
            [req.params.id]
        );
        res.json({ success: true, content: rows });
    } catch (error) {
        console.error('Get course content error:', error);
        res.status(500).json({ error: 'Failed to get course content' });
    }
});

// Get courses assigned to a professor (by email)
app.get('/api/courses/professor/:email', async (req, res) => {
    try {
        const email = decodeURIComponent(req.params.email);

        // 1. Courses where professor is in professors JSON or created content
        const [rows] = await pool.execute(`
            SELECT DISTINCT c.* FROM courses c
            WHERE c.professors LIKE ?
               OR c.professors LIKE ?
               OR c.id IN (SELECT DISTINCT course_id FROM course_content WHERE created_by = ?)
               OR c.id IN (SELECT DISTINCT course_id FROM tasks WHERE created_by = ?)
               OR c.id IN (SELECT DISTINCT course_id FROM announcements WHERE created_by = ?)
        `, [`%${email}%`, `%${email.split('@')[0]}%`, email, email, email]);

        // 2. Also check doctor_courses table (explicit assignments)
        const [dcRows] = await pool.execute(`
            SELECT c.* FROM courses c
            INNER JOIN doctor_courses dc ON dc.course_id = c.id
            WHERE dc.doctor_email = ?
        `, [email]);

        // Merge, deduplicate by id
        const courseMap = new Map();
        for (const c of rows) courseMap.set(c.id, c);
        for (const c of dcRows) {
            if (!courseMap.has(c.id)) courseMap.set(c.id, c);
        }

        const courses = Array.from(courseMap.values()).map(course => ({
            ...course,
            professors: parseJson(course.professors),
            schedule: parseJson(course.schedule),
            content: parseJson(course.content),
            assignments: parseJson(course.assignments),
            exams: parseJson(course.exams),
        }));

        // Get enrollment counts for each course
        for (const course of courses) {
            try {
                const [legacyCount] = await pool.execute(
                    `SELECT COUNT(*) as cnt FROM users WHERE mode = 'student' AND enrolled_courses LIKE ?`,
                    [`%${course.id}%`]
                );
                const [umsCount] = await pool.execute(
                    `SELECT COUNT(DISTINCT uc.user_id) as cnt FROM ums_courses uc
                     INNER JOIN users u ON uc.user_id = u.id
                     WHERE u.mode = 'student' AND (uc.course_code = ? OR uc.course_code LIKE ?)`,
                    [course.code, `%${course.code}%`]
                );
                const enrollmentCount = (legacyCount[0]?.cnt || 0) + (umsCount[0]?.cnt || 0);
                course.enrollmentCount = enrollmentCount;
                course.stats = { students: enrollmentCount };
            } catch (_) {
                course.stats = { students: 0 };
            }
        }

        res.json({ success: true, courses });
    } catch (error) {
        console.error('Get professor courses error:', error);
        res.status(500).json({ error: 'Failed to get professor courses' });
    }
});

// ============ SCHEDULE ENDPOINTS ============

app.get('/api/schedule', async (req, res) => {
    try {
        const { userEmail } = req.query;
        let query = 'SELECT * FROM schedule_events ORDER BY start_time';
        let params = [];

        if (userEmail) {
            query = 'SELECT * FROM schedule_events WHERE user_email = ? ORDER BY start_time';
            params = [userEmail];
        }

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, events: rows });
    } catch (error) {
        console.error('Get schedule error:', error);
        res.status(500).json({ error: 'Failed to get schedule' });
    }
});

app.post('/api/schedule', async (req, res) => {
    try {
        const { title, startTime, endTime, location, instructor, courseId, description, type, userEmail } = req.body;
        const id = generateId();

        await pool.execute(`
            INSERT INTO schedule_events (id, title, start_time, end_time, location, instructor, course_id, description, type, user_email)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [id, title, startTime, endTime, location, instructor, courseId, description, type || 'lecture', userEmail]);

        res.json({ success: true, eventId: id });
    } catch (error) {
        console.error('Create schedule event error:', error);
        res.status(500).json({ error: 'Failed to create event' });
    }
});

// ============ ACADEMIC ADVISING ENDPOINTS ============

// Link students to an advisor
app.post('/api/advising/link', async (req, res) => {
    try {
        const { advisorEmail, studentEmails } = req.body;
        if (!advisorEmail || !Array.isArray(studentEmails)) {
            return res.status(400).json({ error: 'Invalid data' });
        }

        const values = studentEmails.map(email => [advisorEmail, email]);
        if (values.length > 0) {
            await pool.query(
                'INSERT IGNORE INTO academic_advising (advisor_email, student_email) VALUES ?',
                [values]
            );
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Link advising error:', error);
        res.status(500).json({ error: 'Failed to link students' });
    }
});

// Get students for an advisor
app.get('/api/advising/students/:advisorEmail', async (req, res) => {
    try {
        const { advisorEmail } = req.params;
        const [rows] = await pool.execute(`
            SELECT u.* FROM users u
            JOIN academic_advising aa ON u.email = aa.student_email
            WHERE aa.advisor_email = ?
        `, [advisorEmail]);

        const students = rows.map(formatUser);
        res.json({ success: true, students });
    } catch (error) {
        console.error('Get advising students error:', error);
        res.status(500).json({ error: 'Failed to get students' });
    }
});

// Get advisor for a student
app.get('/api/advising/advisor/:studentEmail', async (req, res) => {
    try {
        const { studentEmail } = req.params;
        const [rows] = await pool.execute(`
            SELECT u.* FROM users u
            JOIN academic_advising aa ON u.email = aa.advisor_email
            WHERE aa.student_email = ?
            LIMIT 1
        `, [studentEmail]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Advisor not found' });
        }

        res.json({ success: true, advisor: formatUser(rows[0]) });
    } catch (error) {
        console.error('Get advisor error:', error);
        res.status(500).json({ error: 'Failed to get advisor' });
    }
});

// Send message
app.post('/api/advising/messages', async (req, res) => {
    try {
        const { senderEmail, receiverEmail, message, isBroadcast } = req.body;

        await pool.execute(`
            INSERT INTO advising_messages (sender_email, receiver_email, message, is_broadcast)
            VALUES (?, ?, ?, ?)
        `, [senderEmail, receiverEmail || null, message, isBroadcast ? 1 : 0]);

        // If it's a broadcast from a doctor, we might want to notify students
        if (isBroadcast) {
            const [students] = await pool.execute(
                'SELECT student_email FROM academic_advising WHERE advisor_email = ?',
                [senderEmail]
            );

            for (const student of students) {
                await pool.execute(`
                    INSERT INTO notifications (user_email, title, message, type)
                    VALUES (?, ?, ?, 'advising')
                `, [student.student_email, 'New message from advisor', message]);
            }
        } else if (receiverEmail) {
            // Notify specific receiver
            await pool.execute(`
                INSERT INTO notifications (user_email, title, message, type)
                VALUES (?, ?, ?, 'advising')
            `, [receiverEmail, 'New advising message', message]);
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Send message error:', error);
        res.status(500).json({ error: 'Failed to send message' });
    }
});

// Get messages
app.get('/api/advising/messages', async (req, res) => {
    try {
        const { user1, user2 } = req.query; // For direct chat
        const { email, broadcast } = req.query; // For student getting broadcasts or doctor getting sent broadcasts

        let query = '';
        let params = [];

        if (user1 && user2) {
            // Direct chat between two users
            query = `
                SELECT * FROM advising_messages 
                WHERE (sender_email = ? AND receiver_email = ?) 
                   OR (sender_email = ? AND receiver_email = ?)
                ORDER BY created_at ASC
            `;
            params = [user1, user2, user2, user1];
        } else if (email && broadcast === 'true') {
            // Get broadcasts for a student OR broadcasts sent by a doctor
            // This is simplified: it gets broadcasts sent by the advisor of the student
            // or broadcasts sent by the doctor themselves.
            const [advisorRow] = await pool.execute(
                'SELECT advisor_email FROM academic_advising WHERE student_email = ?',
                [email]
            );

            const advisorEmail = advisorRow.length > 0 ? advisorRow[0].advisor_email : null;

            query = `
                SELECT * FROM advising_messages 
                WHERE (is_broadcast = TRUE AND (sender_email = ? OR sender_email = ?))
                ORDER BY created_at ASC
            `;
            params = [email, advisorEmail];
        }

        if (!query) return res.status(400).json({ error: 'Invalid query parameters' });

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, messages: rows });
    } catch (error) {
        console.error('Get messages error:', error);
        res.status(500).json({ error: 'Failed to get messages' });
    }
});

// ============ UMS SYNC & CACHE ENDPOINTS ============

app.post('/api/ums/sync', async (req, res) => {
    try {
        const { umsUsername, umsPassword } = req.body;
        const userId = req.user.id;

        if (!umsUsername || !umsPassword) {
            return res.status(400).json({ success: false, error: 'UMS credentials required to sync' });
        }

        console.log(`📡 Calling Python Scraper for ${umsUsername}...`);
        const scraperRes = await axios.post(`${SCRAPER_URL}/scrape/all`, {
            username: umsUsername,
            password: umsPassword
        }, { timeout: 120000 });

        if (!scraperRes.data.success) {
            return res.status(400).json({ success: false, error: scraperRes.data.error });
        }

        const { profile, courses, grades } = scraperRes.data.data;

        await pool.execute(`
            INSERT INTO ums_profile (user_id, faculty, major, semester, academic_year, advisor_name, advisor_email, student_id_ums)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
               faculty=VALUES(faculty), major=VALUES(major), semester=VALUES(semester),
               academic_year=VALUES(academic_year), advisor_name=VALUES(advisor_name),
               advisor_email=VALUES(advisor_email), student_id_ums=VALUES(student_id_ums),
               synced_at=CURRENT_TIMESTAMP
        `, [
            userId, 
            profile.faculty || null, 
            profile.major || null, 
            profile.semester || null, 
            profile.academicYear || null, 
            profile.advisorName || null, 
            profile.advisorEmail || null, 
            profile.studentId || null
        ]);

        await pool.execute('DELETE FROM ums_courses WHERE user_id = ?', [userId]);
        await pool.execute('DELETE FROM ums_grades WHERE user_id = ?', [userId]);

        for (const c of courses) {
            await pool.execute(`
                INSERT INTO ums_courses (user_id, course_code, course_name, credit_hours, section, instructor_name, raw_data)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `, [userId, c.courseCode || '', c.courseName || '', c.creditHours || null, c.section || null, c.instructorName || null, JSON.stringify(c.grades || {})]);
        }

        // Sync courses into the courses table so doctors can post announcements for them
        await syncUmsCoursesToCatalog(courses);

        for (const g of grades) {
            await pool.execute(`
                INSERT INTO ums_grades (user_id, course_code, course_name, grade, grade_points, credit_hours)
                VALUES (?, ?, ?, ?, ?, ?)
            `, [userId, g.courseCode, g.courseName, g.grade, g.gradePoints, g.creditHours]);
        }
        const numericLevel = profile.level ? parseInt(profile.level.match(/\d+/)?.[0]) || null : null;
        const nameEn = profile.nameEn || null;
        const nameAr = profile.nameAr || null;
        await pool.execute(`
            UPDATE users 
            SET name = COALESCE(?, name), name_ar = COALESCE(?, name_ar),
                ums_username = ?, department = ?, program = ?, level = ?,
                faculty = ?, phone = ?, address = ?, semester = ?, academic_year = ?
            WHERE id = ?
        `, [
            nameEn || nameAr,
            nameAr,
            umsUsername,
            profile.department || null,
            profile.program || null,
            numericLevel,
            profile.faculty || null,
            profile.phone || null,
            profile.address || null,
            profile.semester || null,
            profile.academicYear || null,
            userId
        ]);

        // Return updated user so Flutter doesn't need an extra /auth/me call
        const [updatedRows] = await pool.execute(`
            SELECT u.*, p.advisor_name, p.advisor_email
            FROM users u
            LEFT JOIN ums_profile p ON u.id = p.user_id
            WHERE u.id = ?
        `, [userId]);
        const updatedUser = updatedRows.length > 0 ? formatUser(updatedRows[0]) : null;

        res.json({ success: true, message: 'UMS synced successfully', timestamp: new Date().toISOString(), user: updatedUser });
    } catch (error) {
        console.error('UMS Sync error:', error.message);
        res.status(502).json({ success: false, error: 'Failed to communicate with UMS portal' });
    }
});

app.get('/api/ums/status/:userEmail', async (req, res) => {
    try {
        const userId = req.user.id;
        const [rows] = await pool.execute('SELECT MAX(synced_at) as lastSync FROM ums_courses WHERE user_id = ?', [userId]);
        
        if (rows.length > 0 && rows[0].lastSync) {
            return res.json({ success: true, hasCachedData: true, lastSyncAt: rows[0].lastSync });
        }
        return res.json({ success: true, hasCachedData: false });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to get UMS status' });
    }
});

app.get('/api/ums/courses', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM ums_courses WHERE user_id = ? ORDER BY course_code', [req.user.id]);
        if (rows.length === 0) return res.json({ success: true, needsSync: true, courses: [] });
        res.json({ success: true, courses: rows });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Database error fetching courses' });
    }
});

app.get('/api/ums/grades', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM ums_grades WHERE user_id = ? ORDER BY course_code', [req.user.id]);
        if (rows.length === 0) return res.json({ success: true, needsSync: true, grades: [] });
        res.json({ success: true, grades: rows });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Database error fetching grades' });
    }
});

app.get('/api/ums/profile', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM ums_profile WHERE user_id = ? LIMIT 1', [req.user.id]);
        if (rows.length === 0) return res.json({ success: true, needsSync: true, profile: null });
        res.json({ success: true, profile: rows[0] });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Database error fetching profile' });
    }
});

app.post('/api/ums/login', async (req, res) => {
    try {
        const { loginName, password } = req.body;
        if (!loginName || !password) {
            return res.status(400).json({ success: false, error: 'loginName and password required' });
        }

        // Derive email – if loginName has no @, append default sci domain
        const umsUsername = loginName.includes('@') ? loginName : `${loginName}@sci.asu.edu.eg`;

        // ── 1. Scrape from UMS first (validates credentials + gets all data) ──
        console.log(`📡 Calling Python Scraper for ${umsUsername}...`);
        let scraperData = null;
        try {
            const scraperRes = await axios.post(`${SCRAPER_URL}/scrape/all`, {
                username: umsUsername,
                password: password
            }, { timeout: 120000 });

            if (scraperRes.data.success) {
                scraperData = scraperRes.data.data;
                console.log(`✅ Scrape OK for ${umsUsername}, profile keys:`, Object.keys(scraperData.profile || {}));
            } else {
                return res.status(401).json({ success: false, error: scraperRes.data.error || 'ums_auth_failed' });
            }
        } catch (scraperErr) {
            console.error('Scraper error:', scraperErr.message);
            return res.status(401).json({ success: false, error: 'ums_server_error' });
        }

        const profile = scraperData.profile || {};
        const courses = scraperData.courses || [];
        const grades = scraperData.grades || [];

        // Derive real student name and email from scraped data
        const studentName = profile.nameAr || profile.nameEn || loginName;
        const studentEmail = profile.email || umsUsername;
        const numericLevel = profile.level ? parseInt(profile.level.match(/\d+/)?.[0]) || null : null;

        // Derive the student ID — UMS may return it in profile, or it's the loginName itself
        const derivedStudentId = profile.studentId || loginName;

        // ── 2. Find or create user in DB ──
        // Search by email, ums_username, OR student_id (SSN/passport)
        let user;
        const [rows] = await pool.execute(`
            SELECT u.*, p.advisor_name, p.advisor_email 
            FROM users u 
            LEFT JOIN ums_profile p ON u.id = p.user_id 
            WHERE u.email = ? OR u.ums_username = ? OR u.ums_username = ? OR u.student_id = ?
        `, [studentEmail, loginName, umsUsername, derivedStudentId]);

        if (rows.length > 0) {
            user = rows[0];
            // For UMS login, credentials are already validated by the scraper above.
            // No bcrypt re-check needed — the scraper would have returned 401 if wrong.
        } else {
            // New student — create account
            const id = generateId();
            const hashed = await bcrypt.hash(password, 10);
            await pool.execute(`
                INSERT INTO users (id, name, email, password, mode, ums_username, is_verified, is_onboarding_complete, student_id)
                VALUES (?, ?, ?, ?, 'student', ?, true, true, ?)
            `, [id, studentName, studentEmail, hashed, umsUsername, derivedStudentId]);
            const [newRows] = await pool.execute(`
                SELECT u.*, p.advisor_name, p.advisor_email 
                FROM users u LEFT JOIN ums_profile p ON u.id = p.user_id 
                WHERE u.id = ?
            `, [id]);
            user = newRows[0];
        }

        // ── 3. Save all scraped fields to users + ums_profile ──
        const nameEn = profile.nameEn || null;
        const nameAr = profile.nameAr || null;
        // Use profile phone/address from scrape; also check the raw UMS API fields
        const phoneNumber = profile.phone || profile.PhoneNo || null;
        const addressStr = profile.address || profile.Address || null;
        await pool.execute(`
            UPDATE users 
            SET name = COALESCE(?, name), name_ar = COALESCE(?, name_ar), 
                ums_username = ?, department = COALESCE(?, department), 
                program = COALESCE(?, program), level = COALESCE(?, level),
                faculty = COALESCE(?, faculty), phone = COALESCE(?, phone), 
                address = COALESCE(?, address), semester = COALESCE(?, semester), 
                academic_year = COALESCE(?, academic_year), student_id = COALESCE(?, student_id),
                is_onboarding_complete = 1, is_verified = 1
            WHERE id = ?
        `, [
            nameEn || nameAr || studentName, nameAr,
            umsUsername,
            profile.department || null, profile.program || null, numericLevel,
            profile.faculty || null, phoneNumber, addressStr,
            profile.semester || null, profile.academicYear || null, derivedStudentId,
            user.id
        ]);

        await pool.execute(`
            INSERT INTO ums_profile (user_id, faculty, major, semester, academic_year, advisor_name, advisor_email, student_id_ums)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
               faculty=VALUES(faculty), major=VALUES(major), semester=VALUES(semester),
               academic_year=VALUES(academic_year), advisor_name=VALUES(advisor_name),
               advisor_email=VALUES(advisor_email), student_id_ums=VALUES(student_id_ums),
               synced_at=CURRENT_TIMESTAMP
        `, [
            user.id,
            profile.faculty || null, profile.program || null,
            profile.semester || null, profile.academicYear || null,
            profile.advisorName || null, profile.advisorEmail || null,
            profile.studentId || loginName
        ]);

        // Save courses
        await pool.execute('DELETE FROM ums_courses WHERE user_id = ?', [user.id]);
        for (const c of courses) {
            await pool.execute(`
                INSERT INTO ums_courses (user_id, course_code, course_name, credit_hours, section, instructor_name, raw_data)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `, [user.id, c.courseCode || '', c.courseName || '', c.creditHours || null, c.section || null, c.instructorName || null, JSON.stringify(c.grades || {})]);
        }

        // Sync courses into the courses table so doctors can post announcements for them
        await syncUmsCoursesToCatalog(courses);

        // Save grades
        await pool.execute('DELETE FROM ums_grades WHERE user_id = ?', [user.id]);
        for (const g of grades) {
            await pool.execute(`
                INSERT INTO ums_grades (user_id, course_code, course_name, grade, grade_points, credit_hours)
                VALUES (?, ?, ?, ?, ?, ?)
            `, [user.id, g.courseCode, g.courseName, g.grade, g.gradePoints, g.creditHours]);
        }

        // ── 4. Return fresh user with all fields ──
        const [updatedRows] = await pool.execute(`
            SELECT u.*, p.advisor_name, p.advisor_email
            FROM users u LEFT JOIN ums_profile p ON u.id = p.user_id
            WHERE u.id = ?
        `, [user.id]);

        const token = jwt.sign({ id: user.id, email: studentEmail, role: 'student' }, JWT_SECRET, { expiresIn: '7d' });
        res.json({ success: true, user: formatUser(updatedRows[0]), token });
    } catch (error) {
        console.error('UMS login error:', error);
        res.status(500).json({ success: false, error: 'Login failed' });
    }
});


// ============ COURSE CATALOG ============

// Create a course (doctor/admin use)
app.post('/api/courses', async (req, res) => {
    try {
        const { code, name, category, creditHours } = req.body;
        if (!code || !name) return res.status(400).json({ error: 'code and name required' });

        const normalizedCode = code.replace(/\s+/g, '').toUpperCase();
        const [existing] = await pool.execute('SELECT id FROM courses WHERE code = ?', [normalizedCode]);
        if (existing.length > 0) {
            return res.json({ success: true, courseId: existing[0].id, existing: true });
        }

        const id = generateId();
        await pool.execute(
            'INSERT INTO courses (id, code, name, category, credit_hours) VALUES (?, ?, ?, ?, ?)',
            [id, normalizedCode, name, category || 'GENERAL', creditHours || 3]
        );
        res.json({ success: true, courseId: id });
    } catch (error) {
        console.error('Create course error:', error);
        res.status(500).json({ error: 'Failed to create course' });
    }
});

// Get all unique courses from UMS data (for doctor course discovery)
app.get('/api/ums/available-courses', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT
                REPLACE(uc.course_code, ' ', '') AS normalized_code,
                uc.course_code,
                MAX(uc.course_name)               AS course_name,
                MAX(uc.instructor_name)            AS instructor_name,
                COUNT(DISTINCT uc.user_id)         AS student_count,
                c.id                               AS course_id
            FROM ums_courses uc
            LEFT JOIN courses c ON c.code = REPLACE(uc.course_code, ' ', '')
            WHERE uc.course_code IS NOT NULL AND uc.course_code != ''
            GROUP BY REPLACE(uc.course_code, ' ', ''), uc.course_code, c.id
            ORDER BY uc.course_code
        `);
        res.json({ success: true, courses: rows });
    } catch (error) {
        console.error('Get available courses error:', error);
        res.status(500).json({ error: 'Failed to get available courses' });
    }
});

// ============ HEALTH CHECK ============

app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start server
const PORT = process.env.PORT || 3000;

initDatabase().then(() => {
    app.listen(PORT, () => {
        console.log(`🚀 Server running on http://localhost:${PORT}`);
    });
}).catch(err => {
    console.error('Failed to start server:', err);
});
