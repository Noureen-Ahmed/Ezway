/**
 * UMS (University Management System) Integration Service
 * Uses Puppeteer (headless Chrome) for login since UMS requires JavaScript.
 * After login, uses the browser context to fetch profile/courses/grades.
 */
const puppeteer = require('puppeteer-core');
const cheerio = require('cheerio');
const path = require('path');
const fs = require('fs');
const { prisma } = require('../utils/database');
const logger = require('../utils/logger');

const UMS_BASE = 'https://ums.asu.edu.eg';
const CHROME_PATH = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
const DEBUG_DIR = path.join(__dirname, '..', '..', 'ums_debug');

// Ensure debug directory exists
if (!fs.existsSync(DEBUG_DIR)) fs.mkdirSync(DEBUG_DIR, { recursive: true });

// ============ HELPER: Clean scraped text ============

// Garbage strings that Kendo/DataTables inject into the DOM
const GARBAGE_STRINGS = [
  'no data available in table',
  'no records available',
  'no matching records',
  'activate to sort',
  'showing 0 to 0',
  'loading...',
  'processing...',
];

function cleanText(s) {
  if (!s || typeof s !== 'string') return null;
  let clean = s
    .replace(/<[^>]*>/g, '')
    .replace(/activate\s+to\s+sort\s+column[ a-zA-Z]*/gi, '')
    .replace(/[\r\n\t]+/g, ' ')
    .replace(/\s{2,}/g, ' ')
    .trim();
  if (!clean) return null;
  // Reject Kendo/DataTable garbage strings
  const lower = clean.toLowerCase();
  for (const g of GARBAGE_STRINGS) {
    if (lower.includes(g)) return null;
  }
  return clean;
}

/** Check if a string is a valid Arabic name (contains Arabic chars, reasonable length) */
function isValidArabicName(s) {
  if (!s) return false;
  // Must contain Arabic characters
  if (!/[\u0600-\u06FF]/.test(s)) return false;
  // Must be reasonable length (at least 2 words)
  const words = s.trim().split(/\s+/);
  if (words.length < 2 || s.length < 4 || s.length > 80) return false;
  // Must NOT be a UI label
  const lower = s.toLowerCase();
  for (const g of GARBAGE_STRINGS) {
    if (lower.includes(g)) return false;
  }
  return true;
}

// ============ BROWSER LOGIN ============

/**
 * Login to UMS using headless Chrome and return session cookies + REAL scraped profile data
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
    await page.setViewport({ width: 1366, height: 900 });
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

    // ═══════════════════════════════════════════════════════════
    // REAL PROFILE SCRAPER — Multiple pages, multiple strategies
    // ═══════════════════════════════════════════════════════════
    
    // --- Strategy 1: Get REAL Arabic name from top navigation bar ---
    try {
      const navName = await page.evaluate(() => {
        // The navbar always shows the logged-in user's Arabic name next to fa-user icon
        const allLinks = document.querySelectorAll('a');
        for (const a of allLinks) {
          const text = a.textContent.trim();
          // Must have fa-user icon, not be a page title, and contain Arabic text
          if (a.querySelector('.fa-user') && text !== 'الصفحة الشخصية' && text.length > 3) {
            // Check it actually contains Arabic characters (not English UI text)
            if (/[\u0600-\u06FF]/.test(text)) {
              return text;
            }
          }
        }
        // Fallback: look for .navbar-text or similar
        const navText = document.querySelector('.navbar-text, .user-name, #user-display-name');
        return navText ? navText.textContent.trim() : null;
      });
      
      const cleaned = cleanText(navName);
      if (cleaned && isValidArabicName(cleaned)) {
        // Extract first two names from full Arabic name
        const parts = cleaned.split(/\s+/);
        if (parts.length >= 2) {
          result.profile.nameAr = `${parts[0]} ${parts[1]}`;
        } else {
          result.profile.nameAr = cleaned;
        }
        logger.info(`[UMS] Nav bar name (first two): ${result.profile.nameAr}`);
      } else {
        logger.warn(`[UMS] Nav name rejected (not valid Arabic): "${navName}"`);
      }
    } catch (err) {
      logger.warn(`[UMS] Nav name extraction failed: ${err.message}`);
    }

    // --- Strategy 2: Scrape /UserInformation page (main profile page) ---
    try {
      await page.goto(`${UMS_BASE}/UserInformation`, { waitUntil: 'networkidle2', timeout: 25000 });
      await new Promise(r => setTimeout(r, 3000)); // Wait for Kendo grids to render

      // Save debug screenshot
      try {
        await page.screenshot({ path: path.join(DEBUG_DIR, 'profile_page.png'), fullPage: true });
        logger.info(`[UMS] 📸 Saved profile page screenshot`);
      } catch (e) { /* ignore screenshot errors */ }

      // Save raw HTML for debugging
      try {
        const html = await page.content();
        fs.writeFileSync(path.join(DEBUG_DIR, 'profile_page.html'), html, 'utf8');
        logger.info(`[UMS] 📄 Saved profile page HTML (${html.length} bytes)`);
      } catch (e) { /* ignore */ }

      // --- Strategy 2a: Read ALL input fields (UMS often stores data in inputs) ---
      const inputData = await page.evaluate(() => {
        const data = {};
        document.querySelectorAll('input[type="text"], input[type="email"], input[type="tel"], input[type="hidden"], input:not([type="password"])').forEach(input => {
          const id = input.id || input.name || '';
          const val = (input.value || '').trim();
          if (val && val.length > 0) {
            data[id] = val;
          }
        });
        // Also read select elements
        document.querySelectorAll('select').forEach(sel => {
          const id = sel.id || sel.name || '';
          const selectedOption = sel.options[sel.selectedIndex];
          if (selectedOption && selectedOption.text.trim()) {
            data[id] = selectedOption.text.trim();
          }
        });
        // Read Kendo dropdowns
        if (window.jQuery) {
          try {
            jQuery('.k-dropdown, .k-combobox').each(function() {
              const widget = jQuery(this).find('input').data('kendoDropDownList') || jQuery(this).find('input').data('kendoComboBox');
              if (widget) {
                const id = jQuery(this).find('input').attr('id') || jQuery(this).find('input').attr('name') || '';
                data['kendo_' + id] = widget.text();
              }
            });
          } catch(e) {}
        }
        return data;
      });

      logger.info(`[UMS] 📋 Found ${Object.keys(inputData).length} input fields:`);
      for (const [key, val] of Object.entries(inputData)) {
        logger.info(`[UMS]   ${key} = "${val}"`);
        
        // Map known input IDs to profile fields
        const k = key.toLowerCase();
        if (k.includes('phone') || k.includes('mobile') || k.includes('تليفون')) {
          if (!result.profile.phone) result.profile.phone = cleanText(val);
        }
        if (k.includes('address') || k.includes('عنوان') || k.includes('سكن')) {
          if (!result.profile.address) result.profile.address = cleanText(val);
        }
        if (k.includes('namear') || k.includes('arabicname') || k.includes('name_ar')) {
          if (!result.profile.nameAr) result.profile.nameAr = cleanText(val);
        }
        if (k.includes('nameen') || k.includes('englishname') || k.includes('name_en')) {
          if (!result.profile.nameEn) result.profile.nameEn = cleanText(val);
        }
      }

      // --- Strategy 2b: Scrape ALL table/grid data systematically ---
      const tableData = await page.evaluate(() => {
        const results = { rows: [], cells: [] };
        
        // Extract from DataTables / Kendo Grids
        document.querySelectorAll('table').forEach((table, tIdx) => {
          const headerCells = [];
          table.querySelectorAll('thead th, thead td').forEach(th => {
            headerCells.push(th.textContent.trim());
          });
          
          table.querySelectorAll('tbody tr').forEach((row, rIdx) => {
            const rowData = {};
            const cells = row.querySelectorAll('td');
            cells.forEach((cell, cIdx) => {
              const header = headerCells[cIdx] || `col${cIdx}`;
              rowData[header] = cell.textContent.trim();
            });
            if (Object.keys(rowData).length > 0) {
              results.rows.push({ table: tIdx, row: rIdx, data: rowData });
            }
          });
        });

        // Also get ALL td content for pattern matching
        document.querySelectorAll('td').forEach(td => {
          const text = td.textContent.trim();
          if (text && text.length > 0 && text.length < 200) {
            results.cells.push(text);
          }
        });

        return results;
      });

      logger.info(`[UMS] 📊 Found ${tableData.rows.length} table rows and ${tableData.cells.length} cells`);

      // Log each table row for debugging
      for (const row of tableData.rows) {
        logger.info(`[UMS]   Table[${row.table}] Row[${row.row}]: ${JSON.stringify(row.data)}`);
      }

      // Extract profile data from table cells
      for (const cell of tableData.cells) {
        const text = cleanText(cell);
        if (!text) continue;

        // Email pattern
        if (!result.profile.email && (text.includes('@sci.asu.edu.eg') || text.includes('@asu.edu.eg'))) {
          result.profile.email = text;
        }
        // Egyptian phone pattern
        if (!result.profile.phone && /^01[0-9]{9}$/.test(text)) {
          result.profile.phone = text;
        }
        // SSN pattern (14 digits)
        if (!result.profile.ssn && /^[0-9]{14}$/.test(text)) {
          result.profile.ssn = text;
        }
        // English name: all Latin letters, reasonable length, not a common header
        if (!result.profile.nameEn && /^[a-zA-Z\s]{6,60}$/.test(text)) {
          const skipWords = ['Student', 'Name', 'Faculty', 'Program', 'Email', 'Active', 'Pending', 'Phone', 'Address', 'Level', 'Semester', 'Department', 'Course'];
          if (!skipWords.includes(text.trim())) {
            result.profile.nameEn = text;
          }
        }
      }

      // Extract from table row header/value pairs
      for (const row of tableData.rows) {
        const pairs = Object.entries(row.data);
        for (const [header, value] of pairs) {
          const h = header.trim();
          const v = cleanText(value);
          if (!v) continue;
          
          // Match by Arabic or English column headers
          if (h.includes('الكلية') || h.includes('كلية') || /faculty/i.test(h)) {
            if (!result.profile.faculty) result.profile.faculty = v;
          }
          if (h.includes('القسم') || h.includes('قسم') || /department/i.test(h)) {
            if (!result.profile.department) result.profile.department = v;
          }
          if (h.includes('البرنامج') || h.includes('برنامج') || h.includes('التخصص') || /program|major|special/i.test(h)) {
            if (!result.profile.program) result.profile.program = v;
          }
          if (h.includes('المستوى') || h.includes('مستوى') || /level/i.test(h)) {
            if (!result.profile.level) result.profile.level = v;
          }
          if (h.includes('الترم') || h.includes('الفصل') || /semester|term/i.test(h)) {
            if (!result.profile.semester) result.profile.semester = v;
          }
          if (h.includes('السنة') || h.includes('العام') || /year|academic/i.test(h)) {
            if (!result.profile.academicYear) result.profile.academicYear = v;
          }
          if (h.includes('تليفون') || h.includes('موبايل') || h.includes('هاتف') || /phone|mobile|tel/i.test(h)) {
            if (!result.profile.phone) result.profile.phone = v;
          }
          if (h.includes('العنوان') || h.includes('عنوان') || h.includes('السكن') || /address/i.test(h)) {
            if (!result.profile.address) result.profile.address = v;
          }
          if (h.includes('الاسم') || /name/i.test(h)) {
            if (h.includes('عربي') || h.includes('Arabic')) {
              if (!result.profile.nameAr) result.profile.nameAr = v;
            } else if (h.includes('English') || h.includes('انجل')) {
              if (!result.profile.nameEn) result.profile.nameEn = v;
            }
          }
        }
      }

      // --- Strategy 2c: Scrape label→value pairs from div-based layouts ---
      const labelValuePairs = await page.evaluate(() => {
        const pairs = [];
        
        // Pattern 1: label + next sibling input/span/div
        document.querySelectorAll('label, .control-label, dt, .field-label, strong').forEach(label => {
          const text = label.textContent.trim();
          if (!text || text.length > 100) return;
          
          let value = '';
          // Check next sibling
          const next = label.nextElementSibling;
          if (next) {
            if (next.tagName === 'INPUT' || next.tagName === 'TEXTAREA') value = next.value;
            else if (next.tagName === 'SELECT') value = next.options[next.selectedIndex]?.text || '';
            else value = next.textContent.trim();
          }
          // Check parent's next sibling
          if (!value) {
            const parentNext = label.parentElement?.nextElementSibling;
            if (parentNext) {
              const inp = parentNext.querySelector('input, textarea');
              if (inp) value = inp.value;
              else value = parentNext.textContent.trim();
            }
          }
          if (value) pairs.push({ label: text, value: value.trim() });
        });

        // Pattern 2: .row with .col for label and .col for value
        document.querySelectorAll('.row, .form-group, .k-edit-field').forEach(row => {
          const cols = row.querySelectorAll('.col, .col-md-3, .col-md-4, .col-md-6, .col-md-8, .col-md-9, .col-sm-4, .col-sm-8, .col-lg-4, .col-lg-8');
          if (cols.length >= 2) {
            const labelText = cols[0].textContent.trim();
            const inp = cols[1].querySelector('input, textarea, select');
            let valueText = inp ? (inp.value || inp.textContent) : cols[1].textContent.trim();
            if (labelText && valueText) pairs.push({ label: labelText, value: valueText.trim() });
          }
        });

        return pairs;
      });

      logger.info(`[UMS] 🏷️  Found ${labelValuePairs.length} label→value pairs:`);
      for (const { label, value } of labelValuePairs) {
        if (value.length > 200) continue; // skip huge values
        logger.info(`[UMS]   "${label}" → "${value}"`);

        const lbl = label.toLowerCase();
        const val = cleanText(value);
        if (!val) continue;

        if (lbl.includes('الكلية') || lbl.includes('كلية') || lbl.includes('faculty')) {
          if (!result.profile.faculty) result.profile.faculty = val;
        }
        if (lbl.includes('القسم') || lbl.includes('قسم') || lbl.includes('department')) {
          if (!result.profile.department) result.profile.department = val;
        }
        if (lbl.includes('البرنامج') || lbl.includes('برنامج') || lbl.includes('التخصص') || lbl.includes('program') || lbl.includes('major') || lbl.includes('specialization')) {
          if (!result.profile.program) result.profile.program = val;
        }
        if (lbl.includes('المستوى') || lbl.includes('مستوى') || lbl.includes('level')) {
          if (!result.profile.level) result.profile.level = val;
        }
        if (lbl.includes('الترم') || lbl.includes('الفصل') || lbl.includes('semester') || lbl.includes('term')) {
          if (!result.profile.semester) result.profile.semester = val;
        }
        if (lbl.includes('السنة') || lbl.includes('العام') || lbl.includes('year') || lbl.includes('academic')) {
          if (!result.profile.academicYear) result.profile.academicYear = val;
        }
        if (lbl.includes('تليفون') || lbl.includes('موبايل') || lbl.includes('هاتف') || lbl.includes('phone') || lbl.includes('mobile') || lbl.includes('tel')) {
          if (!result.profile.phone) result.profile.phone = val;
        }
        if (lbl.includes('العنوان') || lbl.includes('عنوان') || lbl.includes('السكن') || lbl.includes('address') || lbl.includes('محل الاقامة') || lbl.includes('محل السكن')) {
          if (!result.profile.address) result.profile.address = val;
        }
        if (lbl.includes('الاسم') && (lbl.includes('عربي') || lbl.includes('arabic'))) {
          if (!result.profile.nameAr) result.profile.nameAr = val;
        }
        if (lbl.includes('name') && lbl.includes('english')) {
          if (!result.profile.nameEn) result.profile.nameEn = val;
        }
        if ((lbl.includes('الاسم') || lbl.includes('name')) && !lbl.includes('عربي') && !lbl.includes('arabic') && !lbl.includes('english')) {
          // Generic name field
          if (!result.profile.nameAr && /[\u0600-\u06FF]/.test(val)) result.profile.nameAr = val;
          else if (!result.profile.nameEn && /^[a-zA-Z\s]+$/.test(val) && val.length > 3) result.profile.nameEn = val;
        }
      }

    } catch (err) {
      logger.error(`[UMS] Profile page scrape error: ${err.message}`);
    }

    // --- Strategy 3: Try /StudentInformation page (different view in some UMS versions) ---
    try {
      await page.goto(`${UMS_BASE}/StudentInformation`, { waitUntil: 'networkidle2', timeout: 15000 });
      await new Promise(r => setTimeout(r, 2000));
      
      // Save debug screenshot for this page too
      try {
        await page.screenshot({ path: path.join(DEBUG_DIR, 'student_info_page.png'), fullPage: true });
      } catch (e) { /* ignore */ }

      const studentInfoData = await page.evaluate(() => {
        const data = {};
        // Read all input fields
        document.querySelectorAll('input').forEach(input => {
          const val = (input.value || '').trim();
          if (val) data[input.id || input.name || 'unknown'] = val;
        });
        // Read all visible text in .card or .panel sections
        document.querySelectorAll('.card-body, .panel-body, .form-group').forEach(section => {
          const labels = section.querySelectorAll('label, .control-label, strong');
          labels.forEach(label => {
            const lbl = label.textContent.trim();
            const next = label.nextElementSibling;
            if (next) {
              const val = (next.tagName === 'INPUT' ? next.value : next.textContent).trim();
              if (val) data[lbl] = val;
            }
          });
        });
        return data;
      });

      logger.info(`[UMS] 📋 StudentInformation page data (${Object.keys(studentInfoData).length} fields):`);
      for (const [key, val] of Object.entries(studentInfoData)) {
        logger.info(`[UMS]   ${key} = "${val}"`);
        
        const k = key.toLowerCase();
        const v = cleanText(val);
        if (!v) continue;

        if (!result.profile.phone && (k.includes('phone') || k.includes('mobile') || k.includes('تليفون') || k.includes('موبايل'))) {
          result.profile.phone = v;
        }
        if (!result.profile.address && (k.includes('address') || k.includes('عنوان') || k.includes('سكن'))) {
          result.profile.address = v;
        }
        if (!result.profile.department && (k.includes('القسم') || k.includes('قسم') || k.includes('department'))) {
          result.profile.department = v;
        }
        if (!result.profile.program && (k.includes('البرنامج') || k.includes('برنامج') || k.includes('program') || k.includes('التخصص'))) {
          result.profile.program = v;
        }
        if (!result.profile.level && (k.includes('المستوى') || k.includes('level'))) {
          result.profile.level = v;
        }
        if (!result.profile.semester && (k.includes('الترم') || k.includes('الفصل') || k.includes('semester'))) {
          result.profile.semester = v;
        }
      }
    } catch (err) {
      logger.warn(`[UMS] StudentInformation page not available: ${err.message}`);
    }

    // --- Strategy 4: Scrape the body text for phone numbers and Egyptian addresses ---
    try {
      const bodyText = await page.evaluate(() => document.body.innerText);
      
      // Phone number fallback
      if (!result.profile.phone) {
        const phoneMatch = bodyText.match(/01[0-9]{9}/);
        if (phoneMatch) {
          result.profile.phone = phoneMatch[0];
          logger.info(`[UMS] Phone found via body text regex: ${result.profile.phone}`);
        }
      }
    } catch (err) { /* ignore */ }

    // Parse level number
    if (result.profile.level) {
      const m = result.profile.level.toString().match(/(\d+)/);
      if (m) result.profile.levelNum = parseInt(m[1]);
    }

    // Final profile log
    logger.info(`[UMS] ═══════════════════════════════════════`);
    logger.info(`[UMS] ✅ FINAL SCRAPED PROFILE:`);
    logger.info(`[UMS]   nameAr     = ${result.profile.nameAr || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   nameEn     = ${result.profile.nameEn || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   email      = ${result.profile.email || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   phone      = ${result.profile.phone || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   address    = ${result.profile.address || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   faculty    = ${result.profile.faculty || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   department = ${result.profile.department || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   program    = ${result.profile.program || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   level      = ${result.profile.level || '❌ NOT FOUND'} (num: ${result.profile.levelNum || 'N/A'})`);
    logger.info(`[UMS]   semester   = ${result.profile.semester || '❌ NOT FOUND'}`);
    logger.info(`[UMS]   academicYr = ${result.profile.academicYear || '❌ NOT FOUND'}`);
    logger.info(`[UMS] ═══════════════════════════════════════`);

    // Fetch courses
    try {
      await page.goto(`${UMS_BASE}/UserInformation/CurrentCourse`, { waitUntil: 'networkidle2', timeout: 20000 });
      await new Promise(r => setTimeout(r, 2000));
      const coursesHtml = await page.content();
      result.courses = parseCoursesHtml(coursesHtml);
      logger.info(`[UMS] ✅ Found ${result.courses.length} courses`);
    } catch (err) {
      logger.error(`[UMS] Courses fetch error: ${err.message}`);
    }

    // Fetch grades
    try {
      await page.goto(`${UMS_BASE}/StudentGrades`, { waitUntil: 'networkidle2', timeout: 20000 });
      await new Promise(r => setTimeout(r, 2000));
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
