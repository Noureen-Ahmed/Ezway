/**
 * UMS (University Management System) Integration Service
 * Login strategy: HTTP POST first (fast, ~2–5s), falls back to Puppeteer if blocked.
 */
const puppeteer = require('puppeteer-core');
const cheerio = require('cheerio');
const axios = require('axios');
const { prisma } = require('../utils/database');
const logger = require('../utils/logger');
// axios-cookiejar-support and tough-cookie are ESM-only (v5+/v6+),
// so they must be loaded with dynamic import() inside async functions.

const UMS_BASE = 'https://ums.asu.edu.eg';

const BASE_HEADERS = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  'Accept-Language': 'ar,en-US;q=0.9,en;q=0.8',
};

// Detect Chrome/Chromium path based on platform
function getChromePath() {
  const { execSync } = require('child_process');

  // Allow override via Railway environment variable
  if (process.env.CHROMIUM_PATH) return process.env.CHROMIUM_PATH;

  if (process.platform === 'win32') {
    return 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
  }

  // Nix profile paths — Railway nixpacks installs chromium here
  const nixProfilePaths = [
    '/root/.nix-profile/bin/chromium',
    '/nix/var/nix/profiles/default/bin/chromium',
  ];
  for (const p of nixProfilePaths) {
    try { execSync(`test -f "${p}"`); return p; } catch {}
  }

  // Search nix store directly (avoids Ubuntu snap stubs in /usr/bin)
  try {
    const found = execSync(
      'find /nix/store -maxdepth 5 -name "chromium" -type f 2>/dev/null | head -1'
    ).toString().trim();
    if (found) return found;
  } catch {}

  // Standard Linux paths — intentionally skip /usr/bin/chromium-browser
  // because on Ubuntu it is a snap stub that cannot run without snapd
  const linuxPaths = [
    '/usr/bin/chromium',
    '/usr/bin/google-chrome',
    '/usr/bin/google-chrome-stable',
  ];
  for (const p of linuxPaths) {
    try { execSync(`test -f "${p}"`); return p; } catch {}
  }

  // Last resort: which, but reject snap stubs
  try {
    const p = execSync('which chromium 2>/dev/null').toString().trim();
    if (p && !p.includes('snap')) return p;
  } catch {}

  throw new Error(
    'Chromium not found. Set the CHROMIUM_PATH environment variable in your Railway service settings.'
  );
}

// ============ HTTP LOGIN (fast path — no browser needed) ============

async function loginToUMSHttp(loginId, domain, password) {
  const { wrapper } = await import('axios-cookiejar-support');
  const { CookieJar } = await import('tough-cookie');

  const jar = new CookieJar();
  const client = wrapper(axios.create({ jar, withCredentials: true, maxRedirects: 10 }));

  // Step 1: GET login page → pick up session cookie + any CSRF token
  const loginPageRes = await client.get(`${UMS_BASE}/App/Login_Form`, {
    headers: BASE_HEADERS,
    timeout: 15000,
  });

  const $ = cheerio.load(loginPageRes.data);
  const csrfToken = $('input[name="__RequestVerificationToken"]').val();

  // Step 2: POST credentials as a standard form submission
  const body = new URLSearchParams();
  body.append('LoginName', loginId);
  body.append('password', password);
  body.append('DomainName', domain);
  if (csrfToken) body.append('__RequestVerificationToken', csrfToken);

  const postRes = await client.post(`${UMS_BASE}/App/Login_Form`, body.toString(), {
    headers: {
      ...BASE_HEADERS,
      'Content-Type': 'application/x-www-form-urlencoded',
      'Referer': `${UMS_BASE}/App/Login_Form`,
    },
    timeout: 15000,
    validateStatus: () => true,
  });

  // If still on the login page, credentials are wrong
  const finalUrl = postRes.request?.res?.responseUrl || postRes.config?.url || '';
  if (finalUrl.includes('Login_Form') || postRes.status === 401) {
    const $r = cheerio.load(postRes.data);
    const errText = $r('.validation-summary-errors, .text-danger, .alert-danger').first().text().trim();
    throw new Error(errText || 'invalid credentials');
  }

  const cookies = await jar.getCookies(UMS_BASE);
  if (!cookies.length) throw new Error('HTTP login returned no cookies');

  return { cookieStrings: cookies.map(c => `${c.key}=${c.value}`), landingHtml: postRes.data, client };
}

// ============ BROWSER LOGIN (slow fallback) ============

async function loginToUMSBrowser(loginId, domain, password) {
  const chromePath = getChromePath();
  logger.info(`[UMS] Fallback: launching headless Chrome at: ${chromePath}`);

  const browser = await puppeteer.launch({
    executablePath: chromePath,
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-gpu'],
  });

  try {
    const page = await browser.newPage();
    await page.setUserAgent(BASE_HEADERS['User-Agent']);
    await page.goto(`${UMS_BASE}/App/Login_Form`, { waitUntil: 'load', timeout: 30000 });
    await page.waitForSelector('input[name="DomainName"], [data-role="dropdownlist"]', { timeout: 15000 });

    await page.evaluate((d) => {
      const ddl = window.jQuery && window.jQuery('#DomainName').data('kendoDropDownList');
      if (ddl) { ddl.value(d); ddl.trigger('change'); }
      document.querySelectorAll('input[name="DomainName"]').forEach(el => { el.value = d; });
    }, domain);

    const loginField = await page.$('#user-name') || await page.$('input[name="LoginName"]');
    if (loginField) { await loginField.click({ clickCount: 3 }); await loginField.type(loginId); }
    const passField = await page.$('#pass') || await page.$('input[name="password"]');
    if (passField) await passField.type(password);

    await Promise.all([
      page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 20000 }).catch(() => {}),
      page.click('button[type="submit"], input[type="submit"], .btn-primary, #btnLogin').catch(async () => {
        await page.keyboard.press('Enter');
      }),
    ]);

    if (page.url().includes('Login_Form')) {
      const errText = await page.evaluate(() => {
        const el = document.querySelector('.validation-summary-errors, .text-danger, .alert-danger, .error');
        return el ? el.textContent.trim() : null;
      });
      throw new Error(errText || 'UMS login failed — invalid credentials');
    }

    const cookies = await page.cookies();
    return cookies.map(c => `${c.name}=${c.value}`);
  } finally {
    await browser.close();
  }
}

// ============ PROFILE SCRAPER (Puppeteer — gets JS-rendered data) ============

async function scrapeProfileWithBrowser(cookieStrings) {
  const chromePath = getChromePath();
  const browser = await puppeteer.launch({
    executablePath: chromePath,
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-gpu'],
  });
  try {
    const page = await browser.newPage();
    await page.setUserAgent(BASE_HEADERS['User-Agent']);
    // Inject session cookies
    for (const c of cookieStrings) {
      const eq = c.indexOf('=');
      await page.setCookie({ name: c.slice(0, eq), value: c.slice(eq + 1), domain: 'ums.asu.edu.eg', path: '/' });
    }
    await page.goto(`${UMS_BASE}/UserInformation`, { waitUntil: 'networkidle0', timeout: 30000 });
    const html = await page.content();
    logger.info(`[UMS] Puppeteer profile HTML length: ${html.length}`);
    return html;
  } finally {
    await browser.close();
  }
}

// ============ MAIN LOGIN ENTRY POINT ============

async function loginToUMS(loginName, password) {
  const loginId = loginName.includes('@') ? loginName.split('@')[0] : loginName;
  const domain  = loginName.includes('@') ? '@' + loginName.split('@')[1] : '@sci.asu.edu.eg';

  let cookieStrings;
  let landingHtml = '';
  let httpClient = null;

  // Try fast HTTP path first
  try {
    logger.info(`[UMS] Attempting HTTP login for: ${loginId}${domain}`);
    const result = await loginToUMSHttp(loginId, domain, password);
    cookieStrings = result.cookieStrings;
    landingHtml   = result.landingHtml || '';
    httpClient    = result.client;
    logger.info(`[UMS] ✅ HTTP login succeeded (${cookieStrings.length} cookies)`);
  } catch (httpErr) {
    if (httpErr.message.includes('invalid credentials') || httpErr.message.includes('Login failed')) {
      throw new Error('UMS login failed — invalid credentials');
    }
    logger.warn(`[UMS] HTTP login failed (${httpErr.message}), falling back to browser...`);
    try {
      cookieStrings = await loginToUMSBrowser(loginId, domain, password);
      logger.info(`[UMS] ✅ Browser login succeeded (${cookieStrings.length} cookies)`);
    } catch (browserErr) {
      if (browserErr.message.includes('invalid credentials') || browserErr.message.includes('Login failed')) {
        throw new Error('UMS login failed — invalid credentials');
      }
      throw browserErr;
    }
  }

  const cookieHeader = cookieStrings.join('; ');
  const headers = { ...BASE_HEADERS, Cookie: cookieHeader, Referer: UMS_BASE };

  // Fetch courses, grades, advisor via HTTP (these are server-rendered)
  logger.info('[UMS] Fetching courses, grades, advisor...');
  const [coursesRes, gradesRes, advisorRes] = await Promise.all([
    axios.get(`${UMS_BASE}/UserInformation/CurrentCourse`,       { headers, timeout: 20000 }).catch(() => ({ data: '' })),
    axios.get(`${UMS_BASE}/StudentGrades`,                       { headers, timeout: 20000 }).catch(() => ({ data: '' })),
    axios.get(`${UMS_BASE}/RegisterElectiveCourse/Registration`, { headers, timeout: 20000 }).catch(() => ({ data: '' })),
  ]);

  const courses = parseCoursesHtml(coursesRes.data);
  const grades  = parseGradesHtml(gradesRes.data);

  // ── Profile: try three sources in order ──────────────────────────────────

  // Source 1: Kendo Grid JSON endpoint (fastest if available)
  let profile = {};
  try {
    const jsonRes = await axios.post(`${UMS_BASE}/UserInformation/Read`, 'sort=&page=1&pageSize=10&group=&filter=', {
      headers: { ...headers, 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
      timeout: 10000,
    });
    if (jsonRes.data && typeof jsonRes.data === 'object') {
      const row = (jsonRes.data.Data || jsonRes.data.data || [])[0] || jsonRes.data;
      if (row && (row.Faculty || row.faculty || row.FacultyName)) {
        profile.faculty    = row.Faculty || row.FacultyName || row.faculty;
        profile.department = row.Department || row.DepartmentName || row.department;
        profile.program    = row.Program || row.ProgramName || row.program || row.Major;
        profile.nameAr     = row.StudentNameAr || row.NameAr || row.nameAr;
        profile.nameEn     = row.StudentNameEn || row.NameEn || row.nameEn;
        profile.level      = row.Level || row.level;
        profile.gpa        = row.GPA || row.Gpa || row.gpa;
        profile.semester   = row.Semester || row.semester;
        profile.email      = row.Email || row.email;
        profile.phone      = row.Phone || row.phone || row.Mobile;
        profile.studentId  = row.SSN || row.Ssn || row.StudentId || row.studentId;
        if (profile.level) { const m = String(profile.level).match(/(\d+)/); if (m) profile.levelNum = parseInt(m[1]); }
        logger.info(`[UMS] ✅ Profile from Kendo JSON: faculty=${profile.faculty}, dept=${profile.department}`);
      }
    }
  } catch (e) {
    logger.info(`[UMS] Kendo JSON endpoint not available: ${e.message}`);
  }

  // Source 2: Parse landing page HTML (navbar/header after login often has name + faculty)
  if (!profile.faculty && landingHtml) {
    const landingProfile = parseProfileHtml(landingHtml);
    Object.assign(profile, Object.fromEntries(Object.entries(landingProfile).filter(([, v]) => v)));
    logger.info(`[UMS] Landing page profile keys: ${Object.keys(landingProfile).join(', ')}`);
  }

  // Source 3: Puppeteer renders /UserInformation with full JS execution
  if (!profile.faculty && !profile.department) {
    logger.info('[UMS] Falling back to Puppeteer for JS-rendered profile...');
    try {
      const renderedHtml = await scrapeProfileWithBrowser(cookieStrings);
      const browserProfile = parseProfileHtml(renderedHtml);
      Object.assign(profile, Object.fromEntries(Object.entries(browserProfile).filter(([, v]) => v)));
      logger.info(`[UMS] Puppeteer profile keys: ${Object.keys(browserProfile).join(', ')}`);
    } catch (e) {
      logger.warn(`[UMS] Puppeteer profile scrape failed: ${e.message}`);
    }
  }

  Object.assign(profile, parseAdvisorHtml(advisorRes.data));
  if (profile.level && !profile.levelNum) {
    const m = String(profile.level).match(/(\d+)/);
    if (m) profile.levelNum = parseInt(m[1]);
  }

  logger.info(`[UMS] ✅ Courses: ${courses.length}, Grades: ${grades.length}`);
  logger.info(`[UMS] ✅ faculty=${profile.faculty}, dept=${profile.department}, program=${profile.program}, level=${profile.levelNum}`);

  return { cookies: cookieStrings, profile, courses, grades };
}

// ============ HTML PARSERS ============

/**
 * Map an Arabic/English label string to a profile field key.
 */
function labelToKey(label) {
  if (/القومي|رقم قومي|SSN/i.test(label))                          return 'studentId';
  if (/جواز|Passport/i.test(label))                                return 'passportNumber';
  if (/بالعربية|Arabic/i.test(label))                              return 'nameAr';
  if (/بالإنجليزية|English/i.test(label))                          return 'nameEn';
  if (/الإلكتروني|email/i.test(label))                             return 'email';
  if (/الهاتف|تليفون|موبايل|Mobile|phone/i.test(label))           return 'phone';
  if (/الكلية|Faculty|كلية/i.test(label))                          return 'faculty';
  if (/القسم|Department|قسم/i.test(label))                         return 'department';
  if (/البرنامج|Program/i.test(label))                             return 'program';
  if (/العنوان|address/i.test(label))                              return 'address';
  if (/المستوى|Level/i.test(label))                                return 'level';
  if (/المعدل|GPA|معدل/i.test(label))                             return 'gpa';
  if (/الفصل|semester/i.test(label))                               return 'semester';
  if (/الأكاديمية|السنة|academicYear/i.test(label))                return 'academicYear';
  return null;
}

/**
 * Parse /UserInformation HTML and extract full profile.
 * Tries multiple layout strategies used by UMS:
 *   1. div.row > h5 (label) + p/span (value)  — server-rendered card layout
 *   2. dl > dt (label) + dd (value)
 *   3. 2-column table rows
 *   4. 12-column DataTable row with email     — Kendo DataTable (if JS-rendered)
 */
function parseProfileHtml(html) {
  if (!html) return {};
  const $ = cheerio.load(html);
  const profile = {};

  const clean = (s) => s
    ? s.replace(/<[^>]*>/g, '').trim().replace(/\s{2,}/g, ' ')
    : null;

  const set = (key, val) => {
    if (!key || !val || profile[key]) return;
    const v = clean(val);
    if (v && v.length > 0) profile[key] = v;
  };

  // Strategy 1: div.row > h5 (label) + p or span (value)
  $('div.row').each((_, row) => {
    const label = clean($(row).find('h5').first().text());
    const value = clean($(row).find('p, span').not('h5').first().text());
    if (label && value) set(labelToKey(label), value);
  });

  // Strategy 2: dl > dt + dd
  $('dl').each((_, dl) => {
    $(dl).find('dt').each((_, dt) => {
      const label = clean($(dt).text());
      const value = clean($(dt).next('dd').text());
      if (label && value) set(labelToKey(label), value);
    });
  });

  // Strategy 3: 2-column table rows (label | value)
  $('table').each((_, table) => {
    $(table).find('tr').each((_, row) => {
      const cells = $(row).find('td');
      if (cells.length === 2) {
        const label = clean($(cells[0]).text());
        const value = clean($(cells[1]).text());
        if (label && value) set(labelToKey(label), value);
      }
    });
  });

  // Strategy 4: 12-column Kendo DataTable row containing an email address
  if (!profile.nameAr) {
    $('table tbody tr').each((_, row) => {
      const cells = $(row).find('td');
      if (cells.length >= 12 && cells.toArray().some(c => $(c).text().includes('@'))) {
        set('nameAr',   $(cells[2]).text());
        set('nameEn',   $(cells[3]).text());
        set('email',    $(cells[4]).text());
        set('address',  $(cells[8]).text());
        set('phone',    $(cells[9]).text());
        return false; // break
      }
    });
  }

  // Strategy 5: nav bar user link as last-resort name fallback
  if (!profile.nameAr) {
    $('a').each((_, a) => {
      if ($(a).find('.fa-user').length) {
        const text = $(a).text().trim();
        if (text && text !== 'الصفحة الشخصية') { profile.nameAr = text; return false; }
      }
    });
  }

  // Convert level text to number
  if (profile.level) {
    const m = profile.level.match(/(\d+)/);
    if (m) profile.levelNum = parseInt(m[1], 10);
  }

  return profile;
}

/**
 * Parse /RegisterElectiveCourse/Registration HTML for advisor info.
 */
function parseAdvisorHtml(html) {
  if (!html) return {};
  const info = {};
  const nameMatch  = html.match(/للمرشد الأكاديم[يى]\s*:?\s*([^<\r\n]{2,80})|المرشد\s*:?\s*([^<\r\n]{2,80})/i);
  const emailMatch = html.match(/mailto:([^"'\s>]+)/i);
  if (nameMatch)  info.advisorName  = (nameMatch[1] || nameMatch[2]).trim();
  if (emailMatch) info.advisorEmail = emailMatch[1].trim();
  return info;
}

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

async function resyncWithStoredSession(userId) {
  const session = await prisma.umsSession.findUnique({ where: { userId } });
  if (!session || !session.isActive || !session.cookies?.length) {
    throw new Error('No active UMS session — please login again');
  }

  const cookieHeader = session.cookies.join('; ');
  const headers = { ...BASE_HEADERS, Cookie: cookieHeader, Referer: UMS_BASE };

  const [profileRes, coursesRes, gradesRes, advisorRes] = await Promise.all([
    axios.get(`${UMS_BASE}/UserInformation`,                     { headers, timeout: 20000 }).catch(() => ({ data: '' })),
    axios.get(`${UMS_BASE}/UserInformation/CurrentCourse`,       { headers, timeout: 20000 }).catch(() => ({ data: '' })),
    axios.get(`${UMS_BASE}/StudentGrades`,                       { headers, timeout: 20000 }).catch(() => ({ data: '' })),
    axios.get(`${UMS_BASE}/RegisterElectiveCourse/Registration`, { headers, timeout: 20000 }).catch(() => ({ data: '' })),
  ]);

  // Detect expired session: profile page redirects back to login
  if (profileRes.data && profileRes.data.includes('Login_Form')) {
    await prisma.umsSession.update({ where: { userId }, data: { isActive: false } });
    throw new Error('UMS session expired — please login again');
  }

  const courses = parseCoursesHtml(coursesRes.data);
  const grades  = parseGradesHtml(gradesRes.data);
  const result  = await syncStudentData(userId, { courses, grades });

  await prisma.umsSession.update({ where: { userId }, data: { lastSyncAt: new Date() } });
  return result;
}

// Kept for backward compatibility
async function fetchUserInfo(cookies) { return {}; }
async function fetchCurrentCourses(cookies) { return []; }
async function fetchStudentGrades(cookies) { return []; }

module.exports = {
  loginToUMS,
  resyncWithStoredSession,
  fetchUserInfo,
  fetchCurrentCourses,
  fetchStudentGrades,
  syncStudentData,
  parseCoursesHtml,
  parseGradesHtml
};
