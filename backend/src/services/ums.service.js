/**
 * UMS (University Management System) Integration Service
 * Uses Puppeteer (headless Chrome) for login since UMS requires JavaScript.
 * After login, uses the browser context to fetch profile/courses/grades.
 */
const puppeteer = require('puppeteer-core');
const cheerio = require('cheerio');
const { prisma } = require('../utils/database');
const logger = require('../utils/logger');

const UMS_BASE = 'https://ums.asu.edu.eg';
const CHROME_PATH = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

// ============ BROWSER LOGIN ============

/**
 * Login to UMS using headless Chrome and return session cookies
 */
async function loginToUMS(loginName, password) {
  logger.info(`[UMS] Launching headless Chrome for login: ${loginName}`);

  const browser = await puppeteer.launch({
    executablePath: CHROME_PATH,
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
  });

  try {
    const page = await browser.newPage();
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

    // Navigate to login page
    await page.goto(`${UMS_BASE}/App/Login_Form`, { waitUntil: 'networkidle2', timeout: 30000 });
    logger.info('[UMS] Login page loaded');

    // Wait for Kendo dropdown to initialize
    await new Promise(r => setTimeout(r, 2000));

    // Extract just the student number (remove @domain if present)
    const loginId = loginName.includes('@') ? loginName.split('@')[0] : loginName;
    
    // Determine the domain — extract from email or default to sci.asu.edu.eg
    let domain = '@sci.asu.edu.eg'; // default
    if (loginName.includes('@')) {
      domain = '@' + loginName.split('@')[1]; // e.g., "@sci.asu.edu.eg"
    }

    // Set the Kendo DomainName dropdown via JavaScript
    await page.evaluate((domainValue) => {
      // Method 1: Kendo API
      const ddl = $('#DomainName').data('kendoDropDownList');
      if (ddl) {
        ddl.value(domainValue);
        ddl.trigger('change');
      }
      // Method 2: Set both input fields directly
      document.querySelectorAll('input[name="DomainName"]').forEach(el => {
        el.value = domainValue;
      });
    }, domain);
    
    logger.info(`[UMS] Set DomainName to: ${domain}`);

    // Fill LoginName (id="user-name")
    const loginField = await page.$('#user-name') || await page.$('input[name="LoginName"]');
    if (loginField) {
      await loginField.click({ clickCount: 3 });
      await loginField.type(loginId, { delay: 30 });
    }
    logger.info(`[UMS] Set LoginName to: ${loginId}`);

    // Fill password (id="pass")
    const passwordField = await page.$('#pass') || await page.$('input[name="password"]');
    if (passwordField) {
      await passwordField.type(password, { delay: 30 });
    }

    // Submit form
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 30000 }).catch(() => {}),
      page.click('button[type="submit"], input[type="submit"], .btn-primary, #btnLogin').catch(async () => {
        await page.keyboard.press('Enter');
      })
    ]);

    // Check if login succeeded — look for login form still present
    const currentUrl = page.url();
    const isLoginPage = currentUrl.includes('Login_Form');
    
    if (isLoginPage) {
      const errorText = await page.evaluate(() => {
        const el = document.querySelector('.validation-summary-errors, .text-danger, .alert-danger, .error');
        return el ? el.textContent.trim() : null;
      });
      throw new Error(errorText || 'UMS login failed — invalid credentials');
    }

    logger.info(`[UMS] ✅ Login successful! Current URL: ${currentUrl}`);

    // Extract all cookies from the browser
    const cookies = await page.cookies();
    const cookieStrings = cookies.map(c => `${c.name}=${c.value}`);
    logger.info(`[UMS] Got ${cookies.length} cookies: ${cookies.map(c => c.name).join(', ')}`);

    // Now fetch profile and courses while the browser session is active
    const result = {
      cookies: cookieStrings,
      profile: {},
      courses: [],
      grades: []
    };

    // ── Extract profile from /UserInformation using page.evaluate() ──
    try {
      await page.goto(`${UMS_BASE}/UserInformation`, { waitUntil: 'networkidle2', timeout: 30000 });
      // Wait for content to render
      await new Promise(r => setTimeout(r, 3000));

      // Save debug HTML for inspection
      const fs = require('fs');
      const debugHtml = await page.content();
      fs.writeFileSync('ums_profile_debug.html', debugHtml, 'utf-8');
      logger.info(`[UMS] Saved profile page HTML to ums_profile_debug.html (${debugHtml.length} chars)`);

      // Extract profile data straight from the rendered DataTable row or labels
      const profileData = await page.evaluate(() => {
        const profile = {};
        const clean = (s) => s ? s.replace(/<[^>]*>/g, '').trim().replace(/\s{2,}/g, ' ') : null;

        // STRATEGY 1: Extract from the DataTable row if it exists (very reliable)
        // The data row looks like: <td>Status</td><td></td><td>NameAr</td><td>NameEn</td><td>Email</td><td>AltEmail</td><td>DOB</td><td>City</td><td>Address</td><td>Phone</td>
        const tableRows = document.querySelectorAll('table tbody tr');
        for (const row of tableRows) {
          const cells = row.querySelectorAll('td');
          // Check if this row looks like the main student profile row (has > 10 columns and contains an email)
          if (cells.length >= 12 && Array.from(cells).some(c => c.textContent.includes('@'))) {
            profile.nameAr = clean(cells[2]?.textContent);
            profile.nameEn = clean(cells[3]?.textContent);
            profile.email = clean(cells[4]?.textContent);
            profile.address = clean(cells[8]?.textContent);
            profile.phone = clean(cells[9]?.textContent);
            break;
          }
        }

        // STRATEGY 2: Fallback to the top nav link / welcome message for the name
        if (!profile.nameAr || profile.nameAr.length < 3) {
          const navLinks = document.querySelectorAll('a');
          for (const a of navLinks) {
            const text = a.textContent.trim();
            if (a.querySelector('.fa-user') && text !== 'الصفحة الشخصية') {
              profile.nameAr = text;
              break;
            }
          }
        }

        return profile;
      });

      // Merge the extracted data into result.profile
      Object.assign(result.profile, profileData);

      // Parse level number
      if (result.profile.level) {
        const m = result.profile.level.match(/(\d+)/);
        if (m) result.profile.levelNum = parseInt(m[1]);
      }

      logger.info(`[UMS] ✅ Profile extracted: nameAr=${result.profile.nameAr}, nameEn=${result.profile.nameEn}, phone=${result.profile.phone}, address=${result.profile.address}, ssn=${result.profile.ssn}`);
    } catch (err) {
      logger.error(`[UMS] HTML profile error: ${err.message}`);
    }

    // Fetch courses
    try {
      await page.goto(`${UMS_BASE}/UserInformation/CurrentCourse`, { waitUntil: 'networkidle2', timeout: 20000 });
      const coursesHtml = await page.content();
      result.courses = parseCoursesHtml(coursesHtml);
      logger.info(`[UMS] ✅ Found ${result.courses.length} courses`);
    } catch (err) {
      logger.error(`[UMS] Courses fetch error: ${err.message}`);
    }

    // Fetch grades
    try {
      await page.goto(`${UMS_BASE}/StudentGrades`, { waitUntil: 'networkidle2', timeout: 20000 });
      const gradesHtml = await page.content();
      result.grades = parseGradesHtml(gradesHtml);
      logger.info(`[UMS] ✅ Found ${result.grades.length} grades`);
    } catch (err) {
      logger.error(`[UMS] Grades fetch error: ${err.message}`);
    }

    // Fetch advisor page for structural analysis and data extraction
    try {
      await page.goto(`${UMS_BASE}/RegisterElectiveCourse/Registration`, { waitUntil: 'networkidle2', timeout: 20000 });
      const advisorHtml = await page.content();
      
      // Extract advisor name and email using Regex based on the HTML structure
      const advisorNameMatch = advisorHtml.match(/للمرشد الأكاديمى\s*:?\s*([^<]+)|المرشد\s*:?\s*([^<]+)|Advisor\s*:?\s*([^<]+)/i);
      const advisorEmailMatch = advisorHtml.match(/mailto:([^"]+)/i);
      
      if (advisorNameMatch) {
        result.profile.advisorName = (advisorNameMatch[1] || advisorNameMatch[2] || advisorNameMatch[3]).trim();
      }
      
      if (advisorEmailMatch && advisorEmailMatch[1]) {
        result.profile.advisorEmail = advisorEmailMatch[1].trim();
      }

      logger.info(`[UMS] ✅ Extracted advisor: ${result.profile.advisorName || 'Not found'} (${result.profile.advisorEmail || 'Not found'})`);
    } catch (err) {
      logger.error(`[UMS] Advisor form fetch error: ${err.message}`);
    }

    return result;
  } finally {
    await browser.close();
    logger.info('[UMS] Browser closed');
  }
}

// ============ HTML PARSERS ============

function parseCoursesHtml(html) {
  const $ = cheerio.load(html);
  const courses = [];

  // Parse from modern card layout
  $('h5.text-dark').each((i, el) => {
    const text = $(el).text().trim();
    const match = text.match(/(.*)\[(.*)\]/);
    if (match) {
      courses.push({
        courseCode: match[2].trim(),
        courseName: match[1].trim(),
        creditHours: null
      });
    }
  });

  // Fallback to table parsing
  if (courses.length === 0) {
    $('table').each((tableIdx, table) => {
      $(table).find('tr').each((i, row) => {
        if (i === 0) return;
        const cells = $(row).find('td');
        if (cells.length >= 2) {
          const course = {
            courseCode: $(cells[0]).text().trim(),
            courseName: $(cells[1]).text().trim(),
            creditHours: cells.length > 2 ? parseInt($(cells[2]).text().trim()) || null : null,
            section: cells.length > 3 ? $(cells[3]).text().trim() : null,
            instructorName: cells.length > 4 ? $(cells[4]).text().trim() : null
          };
          if (course.courseCode && course.courseCode.length > 1) {
            courses.push(course);
          }
        }
      });
    });
  }

  logger.info(`[UMS] Parsed ${courses.length} courses from HTML`);
  return courses;
}

function parseGradesHtml(html) {
  const $ = cheerio.load(html);
  const grades = [];

  $('table').each((tableIdx, table) => {
    $(table).find('tr').each((i, row) => {
      if (i === 0) return;
      const cells = $(row).find('td');
      if (cells.length >= 2) {
        const grade = {
          courseCode: $(cells[0]).text().trim(),
          courseName: $(cells[1]).text().trim(),
          grade: cells.length > 2 ? $(cells[2]).text().trim() : null,
          gradePoints: cells.length > 3 ? parseFloat($(cells[3]).text().trim()) || null : null,
          creditHours: cells.length > 4 ? parseInt($(cells[4]).text().trim()) || null : null
        };
        if (grade.courseCode && grade.courseCode.length > 1) {
          grades.push(grade);
        }
      }
    });
  });

  logger.info(`[UMS] Parsed ${grades.length} grades from HTML`);
  return grades;
}

// ============ SYNC ============

async function syncStudentData(userId, umsResult) {
  const results = { courses: 0, grades: 0 };

  // Sync courses
  for (const course of (umsResult.courses || [])) {
    try {
      await prisma.umsCourse.upsert({
        where: {
          userId_courseCode_semester_academicYear: {
            userId,
            courseCode: course.courseCode || 'UNKNOWN',
            semester: course.semester || 'current',
            academicYear: course.academicYear || new Date().getFullYear().toString()
          }
        },
        update: {
          courseName: course.courseName || '',
          creditHours: course.creditHours,
          section: course.section,
          instructorName: course.instructorName,
          rawData: course,
          syncedAt: new Date()
        },
        create: {
          userId,
          courseCode: course.courseCode || 'UNKNOWN',
          courseName: course.courseName || '',
          creditHours: course.creditHours,
          section: course.section,
          semester: course.semester || 'current',
          academicYear: course.academicYear || new Date().getFullYear().toString(),
          instructorName: course.instructorName,
          rawData: course
        }
      });
      results.courses++;

      // Auto-enroll in specific App Courses, linking them appropriately
      if (course.courseCode) {
        const rawCode = course.courseCode || 'UNKNOWN';
        const rawName = course.courseName || '';
        const normalizedCode = rawCode.replace(/\s+/g, '').toUpperCase();
        
        // 1. Match by normalized code
        let appCourse = await prisma.course.findFirst({
          where: { code: normalizedCode }
        });
        
        // 2. Match by exact or partial name if code fails
        if (!appCourse && rawName) {
          appCourse = await prisma.course.findFirst({
            where: {
              OR: [
                { name: { equals: rawName } },
                { nameAr: { equals: rawName } },
                { name: { contains: rawName } },
                { nameAr: { contains: rawName } }
              ]
            }
          });
        }
        
        // 3. Fallback: Create stub only if no match found
        if (!appCourse) {
          const categoryString = normalizedCode.replace(/[0-9]/g, '');
          const validCategories = ['COMP', 'MATH', 'CHEM', 'PHYS', 'BIO', 'GENERAL', 'ELECTIVE'];
          const category = validCategories.includes(categoryString) ? categoryString : 'GENERAL';

          appCourse = await prisma.course.create({
            data: {
              code: normalizedCode,
              name: rawName || rawCode,
              category: category, 
              creditHours: course.creditHours || 3,
              semester: course.semester || 'current',
              academicYear: course.academicYear || new Date().getFullYear().toString(),
              isActive: true,
            }
          });
        }
        
        if (appCourse && appCourse.isActive) {
          await prisma.enrollment.upsert({
            where: {
              userId_courseId: {
                userId,
                courseId: appCourse.id
              }
            },
            update: { status: 'ENROLLED' },
            create: {
              userId,
              courseId: appCourse.id,
              status: 'ENROLLED'
            }
          });
        }
      }
    } catch (err) {
      logger.error(`[UMS] Course upsert error: ${err.message}`);
    }
  }

  // Sync grades
  for (const grade of (umsResult.grades || [])) {
    try {
      await prisma.umsGrade.upsert({
        where: {
          userId_courseCode_semester_academicYear: {
            userId,
            courseCode: grade.courseCode || 'UNKNOWN',
            semester: grade.semester || 'unknown',
            academicYear: grade.academicYear || new Date().getFullYear().toString()
          }
        },
        update: {
          courseName: grade.courseName || '',
          grade: grade.grade,
          gradePoints: grade.gradePoints,
          creditHours: grade.creditHours,
          rawData: grade,
          syncedAt: new Date()
        },
        create: {
          userId,
          courseCode: grade.courseCode || 'UNKNOWN',
          courseName: grade.courseName || '',
          grade: grade.grade,
          gradePoints: grade.gradePoints,
          creditHours: grade.creditHours,
          semester: grade.semester || 'unknown',
          academicYear: grade.academicYear || new Date().getFullYear().toString(),
          rawData: grade
        }
      });
      results.grades++;
    } catch (err) {
      logger.error(`[UMS] Grade upsert error: ${err.message}`);
    }
  }

  return results;
}

// Kept for backward compatibility — not used with Puppeteer approach
async function fetchUserInfo(cookies) { return {}; }
async function fetchCurrentCourses(cookies) { return []; }
async function fetchStudentGrades(cookies) { return []; }

module.exports = {
  loginToUMS,
  fetchUserInfo,
  fetchCurrentCourses,
  fetchStudentGrades,
  syncStudentData,
  parseCoursesHtml,
  parseGradesHtml
};
